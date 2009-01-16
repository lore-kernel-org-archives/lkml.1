Return-Path: <linux-kernel-owner+w=401wt.eu-S932341AbZAPKbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbZAPKbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 05:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760409AbZAPKbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 05:31:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:38709 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462AbZAPKbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 05:31:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=JiGOpsVZ9OYxUDLgGxGFR0kuYIaydw7BluJis87EuGokjTORCjwHniZu05GjvWBdsY
         9xD+UVPTsnFNdEH98TzGFFzpzazOFZVuD1qmucKOsf1Jz1dtlDPlUwF1QVRcJ2OV5dGL
         HQ7Yv2H98XHPHXn5LcJtNbTcAXn+gvW210KjA=
Message-ID: <84144f020901160231k9e896d2o672079c1a2973632@mail.gmail.com>
Date: Fri, 16 Jan 2009 12:31:03 +0200
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
In-Reply-To: <200901162121.09128.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	 <20090115135236.GB29283@parisc-linux.org>
	 <84144f020901160216q17f1b558q955d5b8fb7c528c0@mail.gmail.com>
	 <200901162121.09128.nickpiggin@yahoo.com.au>
X-Google-Sender-Auth: 3795dad4f0e62422
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2009 21:16:31 Pekka Enberg wrote:
>> I had lockdep enabled in my config so I ran the tests again with
>> x86-64 defconfig and I'm back to square one:
>>
>>   [ number of transactions per second from 10 runs, bigger is better ]
>>
>>                    min      max      avg      sd
>>   2.6.29-rc1-slab  802.02   805.37   803.93   0.97
>>   2.6.29-rc1-slub  807.78   811.20   809.86   1.05

On Fri, Jan 16, 2009 at 12:21 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> Hm, I wonder why it is going slower with lockdep disabled?
> Did something else change?

I don't have the exact config for the previous tests but it's was just
my laptop regular config whereas the new tests are x86-64 defconfig.
So I think I'm just hitting some of the other OLTP regressions here,
aren't I? There's some scheduler related options such as
CONFIG_GROUP_SCHED and CONFIG_FAIR_GROUP_SCHED enabled in defconfig
that I didn't have in the original tests. I can try without them if
you want but I'm not sure it's relevant for SLAB vs SLUB tests.

                                Pekka
