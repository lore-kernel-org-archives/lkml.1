Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080AbZIWOIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbZIWOIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZIWOIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:08:15 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:39613 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbZIWOIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:08:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PXdWYcx8W7+CVYtzQ256hOXuXPDCWvl0Ag7/3E7QoYwtaVdFDS8BlWgB+2pnJEYqTx
         7zCWmlC9pE0CS0HW4sNK6huRq85ZGAn8K2WiaUR6N3LjILbe/CIAlZIOOdpC1D8pGuhd
         VmADrT8ZeMnDiTdnbQmKEI4ZPuiFGwoxnEgaE=
MIME-Version: 1.0
In-Reply-To: <4ABA20FF.4020601@evidence.eu.com>
References: <1253615424.20345.76.camel@Palantir>
	 <63386a3d0909221355o45cccdf2j707a5cb4cf36754b@mail.gmail.com>
	 <4ABA20FF.4020601@evidence.eu.com>
Date: Wed, 23 Sep 2009 16:08:17 +0200
Message-ID: <63386a3d0909230708g10aa2911vaa39a6e02530c902@mail.gmail.com>
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: Raistlin <raistlin@linux.it>, Peter Zijlstra <peterz@infradead.org>,
       michael@evidence.eu.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Claudio, thanks for the detailed answer!

2009/9/23 Claudio Scordino <claudio@evidence.eu.com>:

> With EDF, instead, the test is much easier: if the bandwidth is less than
> 100%, then you are sure that the deadlines will be met. In other words, you
> can fully exploit processor bandwidth up to 100% being sure that timing
> constraints of EDF tasks will be guaranteed.

This must be under the assumption that all code running in the system
is preemtible, is it not? Which means, negligible or close to negligible
non-preemptible code.

How much as we might like it to be, that is not (yet) the situation
with the Linux kernel, far off.

So we will still very much need the CONFIG_PREEMPT_RT patch
to get closer to that ideal situation, and we still need to get rid of
the BKL.

Well I guess you aldready know that, but take it as a note to
the bystanders of this discussion, which are plenty.

Now I ought to write fewer mails and look into solving that little
problem... You don't happen to know if we can have a EU FP7
project sponsored to rid out the BKL and switch and test drivers
en masse to use threaded interrupt handlers do you? ;-)

Linus Walleij
