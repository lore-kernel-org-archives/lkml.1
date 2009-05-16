Return-Path: <linux-kernel-owner+w=401wt.eu-S1757681AbZEPNkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681AbZEPNkg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 09:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbZEPNkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 09:40:19 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53485 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368AbZEPNkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 09:40:14 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Willy Tarreau <w@1wt.eu>, Linus Torvalds <torvalds@linux-foundation.org>,
       security@kernel.org, Linux@hera.kernel.org, stable@kernel.org,
       Cox <alan@lxorguk.ukuu.org.uk>, Arjan@hera.kernel.org,
       List <linux-kernel@vger.kernel.org>, Alan@hera.kernel.org,
       Eric Paris <eparis@redhat.com>, Jake Edge <jake@lwn.net>,
       linux-security-module@vger.kernel.org, mingo@redhat.com,
       Matt Mackall <mpm@selenic.com>, Dave Jones <davej@redhat.com>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, de Ven <arjan@infradead.org>
References: <20090505195246.GC21973@elte.hu>
	<20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu>
	<20090506162543.GT31071@waste.org>
	<alpine.LFD.2.01.0905060942340.4983@localhost.localdomain>
	<20090506200954.GA21484@elte.hu> <20090514164737.6eaab4f0@chukar>
	<alpine.LFD.2.01.0905141553010.3343@localhost.localdomain>
	<20090515134717.GA16389@elte.hu> <20090516100039.GA24619@1wt.eu>
	<20090516103909.GB6261@elte.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 16 May 2009 05:02:42 -0700
In-Reply-To: <20090516103909.GB6261@elte.hu> (Ingo Molnar's message of "Sat\, 16 May 2009 12\:39\:09 +0200")
Message-ID: <m1bpptw90d.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: w@1wt.eu, mingo@elte.hu, Alan@hera.kernel.org, Arjan@hera.kernel.org, Linux@hera.kernel.org, arjan@infradead.org, stable@kernel.org, security@kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org, jake@lwn.net, alan@lxorguk.ukuu.org.uk, jmorris@namei.org, roland@redhat.com, davej@redhat.com, mingo@redhat.com, eparis@redhat.com, mpm@selenic.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@elte.hu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4995]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [Security] [patch] random: make get_random_int() more random
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Willy Tarreau <w@1wt.eu> wrote:
>
>
> Bad idea IMHO ...
>
> It is a bad idea because such sort of tunables do not really help 
> the user as those who tweak are a distinct minority.
>
> Also, having a two-way hack _hinders_ your good idea from being 
> adopted for example. Why bother with a faster hash and with using 
> the resulting bits sparingly if we can get an 'easy' tunable in and 
> can have two sub-par solutions instead of one (harder to implement) 
> good solution?
>
> So tunables are really counter-productive - and this is a pet peeve 
> of mine.
>
> Every time we have such a tunable for something fundamental we've 
> not improved the kernel, we've documented a _failure_ in kernel 
> design and implementation.
>
> Sure, we do use tunables for physical constants, limits and other 
> natural parameters - and _sometimes_ we just grudingly admit defeat 
> and admit that something is really impossible to implement. IMHO 
> here we are not at that point yet, at all.

In the lwn comment section there was a suggestion to use a high
quality stream cipher (AES?) instead of sha1 or the half md4 thing.
Apparently those should be both stronger and faster.

I don't know enough about it except to say that sounds right in
principle.

Apparently some of the BSDs do something similar with arc4random.
arc4 is old and in some case broken so it is unlikely to make a good
choice at this point, but the overall design of a stream cipher
that is rekeyed ever 5 minutes seems sound.

Eric
