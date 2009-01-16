Return-Path: <linux-kernel-owner+w=401wt.eu-S932331AbZAPKzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbZAPKzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 05:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbZAPKzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 05:55:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:61726 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050AbZAPKze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 05:55:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=myzr0LRbqFBGvxOTz4a3LdVkIC+WyVcpYDGM83qTkEI1J4IbFKfD1n5RcE4d6m9hGp
         njcACFnJCvndeXZPDAgghFTj5zDnuEO0WHn56k+fMK3YJTmH8dG5/luBx1dTHnzgUuhe
         p6u2YLdUtglo6xko9OVZpMu5/wKeWDJFeVCjc=
Message-ID: <84144f020901160255i530755bboc07750a61240d4bf@mail.gmail.com>
Date: Fri, 16 Jan 2009 12:55:30 +0200
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
In-Reply-To: <200901162142.51306.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	 <200901162121.09128.nickpiggin@yahoo.com.au>
	 <84144f020901160231k9e896d2o672079c1a2973632@mail.gmail.com>
	 <200901162142.51306.nickpiggin@yahoo.com.au>
X-Google-Sender-Auth: 3c4d74b19ab231bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Fri, Jan 16, 2009 at 12:42 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>> I don't have the exact config for the previous tests but it's was just
>> my laptop regular config whereas the new tests are x86-64 defconfig.
>> So I think I'm just hitting some of the other OLTP regressions here,
>> aren't I? There's some scheduler related options such as
>> CONFIG_GROUP_SCHED and CONFIG_FAIR_GROUP_SCHED enabled in defconfig
>> that I didn't have in the original tests. I can try without them if
>> you want but I'm not sure it's relevant for SLAB vs SLUB tests.
>
> Oh no that's fine. It just looked like you repeated the test but
> with lockdep disabled (and no other changes).

Right. In any case, I am still unable to reproduce the OLTP issue and
I've seen SLUB beat SLAB on my machine in most of the benchmarks
you've posted. So I have very mixed feelings about SLQB. It's very
nice that it works for OLTP but we still don't have much insight (i.e.
numbers) on why it's better. I'm also bit worried if SLQB has gotten
enough attention from the NUMA and HPC folks that brought us SLUB.

The good news is that SLQB can replace SLAB so either way, we're not
going to end up with four allocators. Whether it can replace SLUB
remains to be seen.

                        Pekka
