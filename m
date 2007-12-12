Return-Path: <linux-kernel-owner+w=401wt.eu-S1760311AbXLLVWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760311AbXLLVWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 16:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbXLLVWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 16:22:31 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:63282 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758321AbXLLVWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 16:22:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bRW3aaf8TCrFqChrYhFk/XsIUqRMXRB+BNM5x+2Fuu6riOdiydPrJ8ukQg8ezKzsrCYFyiyx5FCWqtZ7nQswTUN8cijzBQ1l0V47pQ2jDt02FJtXTADoN4xlsWSWvGqSu9DCfgLuMXa5Gtbl4B0Ga+Sx9TpWiJ++T+4pkmk1YXA=
Message-ID: <fa4052ef0712121322h3ce78a39ve4fd1e10fafe3d15@mail.gmail.com>
Date: Wed, 12 Dec 2007 16:22:29 -0500
From: Shane <gnome42@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [2.6 patch] videobuf-core.c locking fixes
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "Adrian Bunk" <bunk@kernel.org>, "Brandon Philips" <brandon@ifup.org>,
       linux-kernel@vger.kernel.org,
       video4linux-list <video4linux-list@redhat.com>
In-Reply-To: <fa4052ef0712121235x54e1837cs2efe4ce5c6e0e84d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa4052ef0712112120l1165af5btc108ea2131760328@mail.gmail.com>
	 <20071212090709.GF14204@stusta.de> <1197457394.4807.40.camel@gaivota>
	 <20071212120308.GG14204@stusta.de> <1197469316.4744.22.camel@gaivota>
	 <fa4052ef0712120837i36cee3elbe0a5170f5904d2f@mail.gmail.com>
	 <fa4052ef0712121057o51230b22ycb79723091438779@mail.gmail.com>
	 <20071212194454.GF10069@stusta.de>
	 <fa4052ef0712121235x54e1837cs2efe4ce5c6e0e84d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes it does! I was just going to send the same patch myself :)

But, I am now seeing some errors that weren't there in 2.6.23

kernel: bttv0: SCERR @ 1fa0401c,bits: HSYNC OFLOW SCERR*
last message repeated 15 times
kernel: bttv0: timeout: drop=16 irq=105615/105615, risc=1fa0401c,
bits: HSYNC OFLOW
kernel: bttv0: reset, reinitialize
kernel: bttv0: PLL can sleep, using XTAL (28636363).

kernel: bttv0: SCERR @ 1fa0401c,bits: HSYNC OFLOW SCERR*
last message repeated 15 times
kernel: bttv0: timeout: drop=16 irq=106741/106741, risc=1fa0401c,
bits: HSYNC OFLOW
kernel: bttv0: reset, reinitialize
kernel: bttv0: PLL can sleep, using XTAL (28636363).

These happen occasionally and it causes an EIO DQBUF
error and the application has to re queue the buffers but it
recovers OK. Not sure if it causes some sort of internal
kernel corruption that will only be noticed later possibly?

I am using 15 userptr buffers so whatever is happening may
be happening once per buffer sometimes. dunno

Shane
