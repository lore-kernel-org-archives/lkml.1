Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbZHTCtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbZHTCtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 22:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbZHTCtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 22:49:03 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49070 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbZHTCtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 22:49:01 -0400
To: Luis Fernando Planella Gonzalez <lfpg.dev@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org
References: <d12c1890908101630m2a4d0d68yf6dc1e0e0e4f4314@mail.gmail.com>
	<4A80C2F8.2040208@gmail.com>
	<d12c1890908101825t44138bf4x9a4733ece6f74b88@mail.gmail.com>
	<d12c1890908111528p47cdd30bw24749e34fc1cc8d3@mail.gmail.com>
	<4A835760.2050803@gmail.com> <m14os3lkb9.fsf@fess.ebiederm.org>
	<d12c1890908191446k5497d9c8t2f355074eb7ca4ff@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 19 Aug 2009 19:48:59 -0700
In-Reply-To: <d12c1890908191446k5497d9c8t2f355074eb7ca4ff@mail.gmail.com> (Luis Fernando Planella Gonzalez's message of "Wed\, 19 Aug 2009 18\:46\:56 -0300")
Message-ID: <m1k50zi4is.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: lfpg.dev@gmail.com, linux-kernel@vger.kernel.org, hancockrwd@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Luis Fernando Planella Gonzalez <lfpg.dev@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: Flooded by do_IRQ: 0.91 No irq handler for vector
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis Fernando Planella Gonzalez <lfpg.dev@gmail.com> writes:

> I have changed my distro to sidux, so it won't be an easy task to
> return to 2.6.24....
> Anyway, I do use the 64bit kernel.

> But I've downloaded the 32 bit version (sidux 2009.02 with the
> 2.6.30.1 kernel), and the very same error occurs. I've just used the
> live cd, and it does happen.

Sure.  I inferred this by how early this message starting showing
up.   This code did not get added into the 32bit kernels until
recently.

> Something that changed from 2.6.28 to 2.6.30 is that it no longer
> happens the 0.99 message. All complaints are about 0.91...

Interesting.

> One more thing: Deleting /usr/sbin/irqbalance changed nothing, which
> is no surprise, as I had already tested the noirqbalance kernel
> option....

Even after a reboot?

Are you running any kind of vitalization on your box?

> I'm pasting here something I had previously replied personally to
> Robert Hancock, and may be useful:
>
> Well, as I've installed sidux, it has upgraded the kernel to 2.6.30.5,
> but the error is the same.
> I've also tried:
> * noapic: the message changes to do_IRQ: 0.55 No irq handler for
> vector (irq -1), but then the X server fails to start

Interesting... 

> * noacpi: have no effect on the error message.

There is something very strange about your box.  Possibly it is
just VIA interrupt controller madness.  VIA has been known
to interrupt interrupt related fields in creative ways, and
we may be on the edge of another of these.

I expect it is going to come down to writing a patch to dump out
all of the interrupt routing state on the system and to see what
is generating the totally unexpected interrupt and then to work our
way backwards from there.

The fact that the vector number is changing indicates that it is
a programmable something that is causing the problem.

I'm drawing a blank on which patch to write up.

Eric
