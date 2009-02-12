Return-Path: <linux-kernel-owner+w=401wt.eu-S1759117AbZBLQIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117AbZBLQIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 11:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbZBLQH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 11:07:56 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:8368 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbZBLQHy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 11:07:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kguii9j8AoFVmmPNCp9J+9r8bUN+AkoLP2oVoWR8WIFSvfa0P4el27OQdC0nWx4Jlp
         BAVPpt3Zemhnia1OMffIJDtFGp3ZIRy95h2fOHvZCT0xcrKvBlLAvAAv8c1Ea/U5nai1
         szSqXSfYK4YoU0gdjdhm0F/soTAYPe9YGR0Z0=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0902121022450.3559@qirst.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	 <1232697998.6094.17.camel@penberg-laptop>
	 <1232699401.11429.163.camel@ymzhang>
	 <1232703989.6094.29.camel@penberg-laptop>
	 <alpine.DEB.1.10.0901231020030.21692@qirst.com>
	 <1232765728.11429.193.camel@ymzhang>
	 <84144f020901232336v71687223y2fb21ee081c7517f@mail.gmail.com>
	 <1234416153.2604.387.camel@ymzhang>
	 <1234417660.2604.391.camel@ymzhang>
	 <alpine.DEB.1.10.0902121022450.3559@qirst.com>
Date: Thu, 12 Feb 2009 18:07:51 +0200
X-Google-Sender-Auth: 31bd9ca537e54020
Message-ID: <84144f020902120807v25f52301s2713d143b38f3d8c@mail.gmail.com>
Subject: Re: Mainline kernel OLTP performance update
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, matthew.r.wilcox@intel.com,
       chinang.ma@intel.com, linux-kernel@vger.kernel.org,
       sharad.c.tripathi@intel.com, arjan@linux.intel.com,
       suresh.b.siddha@intel.com, harita.chilukuri@intel.com,
       douglas.w.styner@intel.com, peter.xihong.wang@intel.com,
       hubert.nueckel@intel.com, chris.mason@oracle.com, srostedt@redhat.com,
       linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com,
       anirban.chakraborty@qlogic.com, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Thu, 12 Feb 2009, Zhang, Yanmin wrote:
>> ﻿The default order of ﻿kmalloc-8192 on 2*4 stoakley is an issue of calculate_order.
>>
>>
>> slab_size       order           name
>> -------------------------------------------------
>> 4096            3               sgpool-128
>> 8192            2               kmalloc-8192
>> 16384           3               kmalloc-16384
>>
>> ﻿kmalloc-8192's default order is smaller than ﻿sgpool-128's.

On Thu, Feb 12, 2009 at 5:25 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> You reverted the page allocator passthrough patch before this right?
> Otherwise kmalloc-8192 should not exist and allocation calls for 8192
> bytes would be converted inline to request of an order 1 page from the
> page allocator.

Yup, I assume that's the case here.
