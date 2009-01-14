Return-Path: <linux-kernel-owner+w=401wt.eu-S1760367AbZANHqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760367AbZANHqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 02:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbZANHp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 02:45:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40129 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755024AbZANHp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 02:45:56 -0500
Date: Wed, 14 Jan 2009 08:45:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alain Knaff <alain@knaff.lu>
Cc: Bodo Eggert <7eggert@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: The policy on initramfs decompression failure
Message-ID: <20090114074542.GA16274@elte.hu>
References: <bU0fj-7Ap-43@gated-at.bofh.it> <E1LMstm-0001QW-7i@be1.7eggert.dyndns.org> <20090114054556.GB11153@elte.hu> <496D8A83.1040801@knaff.lu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496D8A83.1040801@knaff.lu>
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


* Alain Knaff <alain@knaff.lu> wrote:

> > Unless you use bzImage i dont think you can really appreciate this 
> > argument.
> 
> Maybe that's the source of our misunderstanding. What is this bzImage? 
> (I suppose it's not just the kernel name/format but something more. But 
> what?)

pure bzImages is what many kernel developers use to boot static kernel 
images, with drivers built in, often with no module support, etc.:

 $ make help | grep -i bzImage
 * bzImage      - Compressed kernel image (arch/x86/boot/bzImage)

the bzImage method never led to a panic related to a ramdisk before 
(unless the ramdisk was materially corrupted - which is not the case 
here), and should not lead to a panic afterwards either.

We use panics/crashes when the kernel meets a problem that makes 
continuing impossible, but that is not an issue here.

	Ingo
