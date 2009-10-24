Return-Path: <linux-kernel-owner+w=401wt.eu-S1751891AbZJXWp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbZJXWp0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 18:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbZJXWp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 18:45:26 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:48936 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbZJXWpZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 18:45:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FJaCQFV55BpxRfqFGEQMFaDAN75LZRY9Lf2ffTRUBA2W0l3fhSXaQ+00YNpW2uyDym
         54UiAd+pErVuOPQVrpwNmUE4MjHkiV0uTEY0q4WQQgL1UmMlj/jW06kTTAPi74k8hhjp
         Cl3j1vXp1H285N+J+7/35ZvFvXDYw/lVmkWn0=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.61.0910242207180.2439@ginsburg.homenet>
References: <20091023233743.439628000@alcatraz.americas.sgi.com>
	 <20091023233756.941535000@alcatraz.americas.sgi.com>
	 <b647ffbd0910241309u7b2f8c94t1f886ef31882539e@mail.gmail.com>
	 <Pine.LNX.4.61.0910242207180.2439@ginsburg.homenet>
Date: Sun, 25 Oct 2009 00:45:29 +0200
Message-ID: <b647ffbd0910241545g4697a170peb00e541298d5a30@mail.gmail.com>
Subject: Re: [PATCH 6/8] SGI x86_64 UV: Limit the number of microcode messages
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Andreas Mohr <andi@lisas.de>,
       Hugh Dickins <hugh@veritas.com>, Hannes Eder <hannes@hanneseder.net>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/24 Tigran Aivazian <tigran@aivazian.fsnet.co.uk>:
> On Sat, 24 Oct 2009, Dmitry Adamushko wrote:
>>>
>>> -       printk(KERN_INFO "microcode: CPU%d sig=0x%x, pf=0x%x,
>>> revision=0x%x\n",
>>> +       if (cpu_num < 4 || !limit_console_output(false))
>>> +               printk(KERN_INFO
>>> +                       "microcode: CPU%d sig=0x%x, pf=0x%x,
>>> revision=0x%x\n",
>>>                        cpu_num, csig->sig, csig->pf, csig->rev);
>>>
>>
>> Hmm, I guess we wouldn't lose a lot by simply removing those messages
>> completely. Per-cpu pf/revision is available via /sys anyway.
>
> The reason for printing them is that the pf (possibly others?) can change by the update and so the log has this info handy.

We might store the old sig/pf/revision set as well, export them via
/sys or/and print them at update-to-new-microcode time.

If it's really so useful to have this info in the log and, at the same
time, to avoid the flood of messages (which, I guess for the majority
of systems, are the same) at startup time, we might delay the printout
until the end of microcode_init(). Then do something like this:

microcode cpu0: up to date version sig, pf, rev          // let's say,
it was updated by BIOS
microcode cpus [1 ... 16] : update from sig, pf, rev to sig, pf2, rev2.

Anyway, my humble opinion, is that (at the very least) the current
patch should be accompanied by a similar version for amd.


>
> Kind regards
> Tigran


-- Dmitry
