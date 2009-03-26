Return-Path: <linux-kernel-owner+w=401wt.eu-S1760336AbZCZSSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760336AbZCZSSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 14:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbZCZSR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 14:17:58 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:51470 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbZCZSR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 14:17:56 -0400
Date: Thu, 26 Mar 2009 11:17:47 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       shai@scalex86.org
Subject: Re: [PATCH] x86: don't compile vsmp_64 for 32bit
Message-ID: <20090326181747.GC10614@localdomain>
References: <20090324061429.GH7278@localdomain> <20090324091035.GA6605@elte.hu> <20090325185138.GI7278@localdomain> <49CAAD2E.3060904@goop.org> <20090325223642.GK7278@localdomain> <49CABB25.8040106@goop.org> <20090325232921.GL7278@localdomain> <49CAC543.5020205@goop.org> <20090326003154.GA10614@localdomain> <20090326091153.GB9369@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326091153.GB9369@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 10:11:53AM +0100, Ingo Molnar wrote:
>
>* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>
>> > unsynchronized_tsc() just returns a guess anyway, and if you 
>> > don't have X86_FEATURE_CONSTANT_TSC set, then it will return 
>> > unstable for your hardware anyway, even without the 
>> > is_vsmp_box() test.
>> 
>> Unfortunately we use hardware which has X86_FEATURE_CONSTANT_TSC.
>> 
>> >
>> > Failing that, you could add yourself to bad_tsc_dmi_table[] and 
>> > have that mark the tsc as unstable (you have DMI, right?).
>> >
>> 
>> Newer versions of the VMM does, but older ones don't :(, and 
>> obviously we have older versions out in the field that still needs 
>> to be supported.
>
>But those old versions wont have X86_FEATURE_CONSTANT_TSC set, 
>right?

No, the old versions also do have X86_FEATURE_CONSTANT_TSC.  The kernel
assumes that even netburst based cpus have synced tscs (of course this is
never mentioned in the intel documentation, but in the past we've
been told that that intel engineers say so -- that tscs are synced
and guaranteed to not drift between intel cpus)

Here's the code that sets X86_FEATURE_CONSTANT_TSC.

static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
{
        if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
                (c->x86 == 0x6 && c->x86_model >= 0x0e))
                set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);

...

Thanks,
Kiran
