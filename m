Return-Path: <linux-kernel-owner+w=401wt.eu-S1759111AbZANFkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111AbZANFkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 00:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbZANFkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 00:40:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43715 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412AbZANFkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 00:40:32 -0500
Date: Wed, 14 Jan 2009 06:40:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alain Knaff <alain@knaff.lu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: The policy on initramfs decompression failure
Message-ID: <20090114054022.GA11153@elte.hu>
References: <496D17F9.8080605@zytor.com> <496D20FB.5010307@knaff.lu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496D20FB.5010307@knaff.lu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4994]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alain Knaff <alain@knaff.lu> wrote:

> There is also the additional issue that continuing to boot might hide 
> the original error message. [...]

I have hit this pointless panic during testing, that's the motivation for 
this whole question. The initrd was unimportant in that bootup - but that 
is generally true of bzImage bootups.

And your argument makes little sense: if there is something wrong then one 
looks at the logs _anyway_. Are you suggesting that all warnings that 
signal some potential badness should result in a panic? That is 
nonsensical.

What you seem to be arguing for is to introduce a kernel option that says 
"panic on warnings" - so that folks cannot miss warnings. _That_ would be 
a fair argument.

Panics are rarely good, unless the user asks for it, period. We've been 
flipping over BUG_ON()s to WARN_ON() everywhere where it matters in 
practice.

	Ingo
