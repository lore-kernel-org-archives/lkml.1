Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbZBGPfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbZBGPfv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 10:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbZBGPfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 10:35:40 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:53361 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbZBGPfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 10:35:40 -0500
Date: Sun, 08 Feb 2009 00:35:36 +0900 (JST)
Message-Id: <20090208.003536.72707389.anemo@mba.ocn.ne.jp>
To: sshtylyov@ru.mvista.com
Cc: bzolnier@gmail.com, geert@linux-m68k.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, apw@canonical.com
Subject: Re: [PATCH 01/15] ide: include <asm/ide.h> only when needed
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <498CB3CF.8070306@ru.mvista.com>
References: <498B7D09.6040100@ru.mvista.com>
	<200902061721.46813.bzolnier@gmail.com>
	<498CB3CF.8070306@ru.mvista.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Feb 2009 01:03:59 +0300, Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:
> > config CONFIG_IDE_BE_IO
> > 	bool
> 
>     If it was that simple... Normally the BE case gets handled automagically 
> (moreover, there is MIPS option that additionally controls I/O and memory 
> space byte swapping). The case we have to address for TX493x is actually where 
> the usual magic fails (or actually the code just doesn't want to use that 
> option). So this doesn't look like a good name to me...

Well, for TX493x (MIPS), we have CONFIG_SWAP_IO_SPACE for big endian
and it works fine for PCI-IDE host controllers.  For SoC internal
controllers, no swapping is needed for both endian, thus custom tp_ops
is needed only for big endian.

So ... IDE_BE_IO looks actually not best name for this case.  It is
IDE_RAW_IO or something.  But IDE_RAW_IO might not fit for other
cases.  IDE_SWAPPED_IO?  Any other good name?

---
Atsushi Nemoto
