Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbZEEIOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbZEEIOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 04:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbZEEIOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 04:14:14 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36247 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbZEEIOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 04:14:11 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Matt Mackall <mpm@selenic.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, Jake Edge <jake@lwn.net>,
       security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Dave Jones <davej@redhat.com>
References: <20090504125114.5e391564@chukar>
	<alpine.LFD.2.01.0905041159480.4983@localhost.localdomain>
	<20090504125124.0f469970@infradead.org>
	<m1vdogbows.fsf@fess.ebiederm.org>
	<alpine.LFD.2.01.0905041514350.4983@localhost.localdomain>
	<20090505055011.GE31071@waste.org> <20090505063156.GA24504@elte.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 05 May 2009 01:14:05 -0700
In-Reply-To: <20090505063156.GA24504@elte.hu> (Ingo Molnar's message of "Tue\, 5 May 2009 08\:31\:56 +0200")
Message-ID: <m14ow0ynjm.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: mingo@elte.hu, davej@redhat.com, greg@kroah.com, akpm@linux-foundation.org, mingo@redhat.com, roland@redhat.com, alan@lxorguk.ukuu.org.uk, eparis@redhat.com, linux-security-module@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, security@kernel.org, jake@lwn.net, arjan@infradead.org, torvalds@linux-foundation.org, mpm@selenic.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@elte.hu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4337]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [Security] [PATCH] proc: avoid information leaks to non-privileged processes
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Matt Mackall <mpm@selenic.com> wrote:
>
>> As to what's the appropriate sort of RNG for ASLR to use, finding 
>> a balance between too strong and too weak is tricky. [...]
>
> In exec-shield i mixed 'easily accessible and fast' semi-random 
> state to the get_random_int() result: xor-ed the cycle counter, the 
> pid and a kernel address to it. That strengthened the result in a 
> pretty practical way (without strengthening the theoretical 
> randomless - each of those items are considered guessable) and does 
> so without weakening the entropy of the random pool.

The trouble is, that thinking completely misses the problem, and I
expect that is why we have a problem.  Throwing a bunch of possibly
truly random values into the pot for luck is nice.  But you didn't
throw in a pseudo random number generator.  An unpredictable sequence
that is guaranteed to change from one invocation to the next.

In a very practical sense a pseudo random generator is completely
sufficient.  Throwing in a few truly random numbers guards against
attacks on the random number generator.

What we have now is a hash over an a value that changes every 5 minutes
and some well known values.

Eric
