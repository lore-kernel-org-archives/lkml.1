Return-Path: <linux-kernel-owner+w=401wt.eu-S1753784Ab0A0NH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab0A0NH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 08:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198Ab0A0NH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 08:07:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57824 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab0A0NH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 08:07:26 -0500
Date: Wed, 27 Jan 2010 14:07:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86-64: Use normal ptregs stub for execve
Message-ID: <20100127130716.GA26908@elte.hu>
References: <1264434453-2204-1-git-send-email-brgerst@gmail.com>
 <tip-f19a25c872b20ae4357f72687cf3e7b0da220ee2@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-f19a25c872b20ae4357f72687cf3e7b0da220ee2@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Brian Gerst <brgerst@gmail.com> wrote:

> Commit-ID:  f19a25c872b20ae4357f72687cf3e7b0da220ee2
> Gitweb:     http://git.kernel.org/tip/f19a25c872b20ae4357f72687cf3e7b0da220ee2
> Author:     Brian Gerst <brgerst@gmail.com>
> AuthorDate: Mon, 25 Jan 2010 10:47:33 -0500
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Tue, 26 Jan 2010 23:38:14 -0800
> 
> x86-64: Use normal ptregs stub for execve
> 
> Execve historically passed regs by value, so it had a seperate stub.
> This is no longer true, so change it to use a normal PTREGSCALL stub.
> 
> Signed-off-by: Brian Gerst <brgerst@gmail.com>
> LKML-Reference: <1264434453-2204-1-git-send-email-brgerst@gmail.com>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> ---
>  arch/x86/kernel/entry_64.S |   17 +----------------
>  1 files changed, 1 insertions(+), 16 deletions(-)

FYI, -tip testing found that this commit breaks the grub binary on 64-bit, 
simply running /sbin/grub causes it to segfault:

[ 3145.999766] grub[6706] general protection ip:805c481 sp:ff95629c error:0 in 
grub[8048000+8c000]

i've excluded this commit for now.

	Ingo

