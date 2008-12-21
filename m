Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831AbYLUWns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbYLUWns (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 17:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbYLUWnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 17:43:39 -0500
Received: from rn-out-0910.google.com ([64.233.170.191]:25321 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbYLUWni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 17:43:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sk6HkHvlNs0mVNZ6Um89koVDgi20TfBu/ogz11ntvasR3nfKgJzx10jy403nR7RiFM
         goiwE/bt7M5QNV5FZvcfp74JH/Xw7ROE8Cu13nNB6g1JvzHrk1riFwlftNlSuIHFOgNv
         V6pfsbS0Su7Z4O29w4DtVHZG07azhkbMKInAM=
Message-ID: <b637ec0b0812211443u1ca9c11du5d61c41e3d82bc16@mail.gmail.com>
Date: Sun, 21 Dec 2008 23:43:36 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: TSC not updating after resume: Bug or Feature?
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Steven Rostedt" <srostedt@redhat.com>, dsaxena@plexity.net,
       linux-kernel@vger.kernel.org,
       "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>
In-Reply-To: <alpine.LFD.2.00.0812212031220.4548@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net>
	 <1229592279.9487.133.camel@twins> <20081218123924.GH25715@elte.hu>
	 <200812182319.57235.rjw@sisk.pl>
	 <alpine.LFD.2.00.0812211639210.3376@localhost.localdomain>
	 <alpine.LFD.2.00.0812212031220.4548@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas.

On Sun, Dec 21, 2008 at 8:43 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sun, 21 Dec 2008, Thomas Gleixner wrote:
>> On Thu, 18 Dec 2008, Rafael J. Wysocki wrote:
>> > >  5b7dba4: sched_clock: prevent scd->clock from moving backwards
>> > >
>> > > and the bug triggered by hibernation fixed instead.
>>
>> Hmm. Depending on the hibernation sleep time we can end up with a
>> pretty long delta between the pre suspend and the post resume call to
>> __update_sched_clock().
>>
>> I have the feeling that sched_clock looks into stale values after
>> resume and the first call to __update_sched_clock() trips over the
>> stale scd->clock value. Shaggy's patch brings scd->clock into the mix
>> and that might cause the whole machinery to blow up on resume.
>>
>> Also we need to investigate whether sched_clock is referencing gtod
>> values _before_ timekeeping is resume.
>
> I checked the two bugzillas (12149 & 12155) and both reporters have
> hpet=force on the command line.

Well, I'm the submitter of bug 12155 and I never had hpet=force on my
command line. I don't know where you found it.
Actually my command line is:

-------------------------------------------------------------------------------------------------------------------------
fcomolli@hawking:~> cat /proc/cmdline
root=/dev/sda2 resume=/dev/sda3 i8042.nomux=1 pciehp.pciehp_force=1
quiet splash=silent vga=791
-------------------------------------------------------------------------------------------------------------------------

By the way, I don't know if it matters but the problema happened with
in-kernel hibernation and also in out-of-tree TuxOnIce hibernation.
Maybe this can help debugging the issue, I don't know.

>
> One of the reporters said: "If I de-select CONFIG_HPET_TIMER then the
> issue went away ..."
>
> It looks like this was not further investigated. Is this problem
> reproducible on other systems as well ?
>
> Thanks,
>
>        tglx
> --

Regards,
Fabio


> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
