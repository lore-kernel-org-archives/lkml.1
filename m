Return-Path: <linux-kernel-owner+w=401wt.eu-S1758703AbZANFqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbZANFqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 00:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbZANFqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 00:46:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39266 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835AbZANFqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 00:46:09 -0500
Date: Wed, 14 Jan 2009 06:45:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bodo Eggert <7eggert@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@ftp.linux.org.uk>,
       Alain Knaff <alain@knaff.lu>
Subject: Re: The policy on initramfs decompression failure
Message-ID: <20090114054556.GB11153@elte.hu>
References: <bU0fj-7Ap-43@gated-at.bofh.it> <E1LMstm-0001QW-7i@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LMstm-0001QW-7i@be1.7eggert.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bodo Eggert <7eggert@gmx.de> wrote:

> If the initrd is not decompressed successfully, [...]

No, that's not the issue - i think hpa's description was misleading in 
that respect.

This is not some sort of corruption. I have hit this pointless panic 
during testing: there was nothing wrong with either the initrd or the 
system, the bzImage simply did not include the right decompressor .config 
option to even read the initrd.

The analogue is if i booted a kernel with CONFIG_MODULES disabled. I do it 
all the time, it always worked without problems and the initrd with 
modules in it cannot be interpreted in any sane way CONFIG_MODULES - still 
it works just fine because the initrd is uninteresting as far as the 
modules go.

So basically now the kernel has regressed in its bzImage utility: "oh, i 
dont have a decompressor for the initrd. PANIC!". And that is a step 
backwards. Unless you use bzImage i dont think you can really appreciate 
this argument.

I would not mind a warning message though, that bit makes sense.

	Ingo
