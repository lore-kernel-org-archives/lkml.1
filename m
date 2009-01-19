Return-Path: <linux-kernel-owner+w=401wt.eu-S1759115AbZASJtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115AbZASJtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 04:49:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756573AbZASJsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 04:48:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:18340 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbZASJsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 04:48:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=uEQW0imTvf8pWp8rxU7ZVqyzVVxne43QwpZnKQ08UHDO3pXrJXyPkCrapWVzjf1hpU
         +b9W2Kf4Uwde03GmcfkBvZgsSlS1C8R6Xx6kznhxCyQ53WFbU9bYE+DIc+mfwvc7s0AG
         dvvuNwkOtPkxi6USwj4rDBJpNDdBGrgC4c05g=
Message-ID: <84144f020901190148r7ea135b6uead33842e93e59c2@mail.gmail.com>
Date: Mon, 19 Jan 2009 11:48:52 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: Mainline kernel OLTP performance update
Cc: "Matthew Wilcox" <matthew@wil.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com,
       linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com,
       arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com,
       harita.chilukuri@intel.com, douglas.w.styner@intel.com,
       peter.xihong.wang@intel.com, hubert.nueckel@intel.com,
       chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org,
       "Andrew Vasquez" <andrew.vasquez@qlogic.com>,
       "Anirban Chakraborty" <anirban.chakraborty@qlogic.com>,
       "Christoph Lameter" <cl@linux-foundation.org>
In-Reply-To: <200901191933.29322.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	 <200901191813.07960.nickpiggin@yahoo.com.au>
	 <1232352303.30141.25.camel@penberg-laptop>
	 <200901191933.29322.nickpiggin@yahoo.com.au>
X-Google-Sender-Auth: a2bd3eb568cbb62e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Mon, Jan 19, 2009 at 10:33 AM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>> All I am saying is that I don't like how we're fixing a performance bug
>> with a shiny new allocator without a credible explanation why the
>> current approach is not fixable.
>
> To be honest, my biggest concern with SLUB is the higher order pages
> thing. But Christoph always poo poos me when I raise that concern, and
> it's hard to get concrete numbers showing real fragmentation problems
> when it can take days or months to start biting.

To be fair to SLUB, we do have the pending slab defragmentation
patches in my tree. Not that we have any numbers on if defragmentation
helps and how much. IIRC, Christoph said one of the reasons for
avoiding queues in SLUB is to be able to do defragmentation. But I
suppose with SLQB we can do the same thing as long as we flush the
queues before attempting to defrag.

                                Pekka
