Return-Path: <linux-kernel-owner+w=401wt.eu-S933517AbYBBS6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517AbYBBS6d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 13:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbYBBS6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 13:58:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:54612 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbYBBS6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 13:58:23 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] ide-core: remove conditional compiling with MODULE in ide-core.c
To: Denis Cheng <crquan@gmail.com>, linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Sat, 02 Feb 2008 19:58:15 +0100
References: <9Slso-6q4-5@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1JLNZ9-0000iB-G8@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/0JgT4eKNBFy+YOp6jZpzM5N30Bp1+SHvPIv+
 xN3H/VGFCWNRQRhB+m15iMrTGOLRpMCdVFucrAqQgP0Jg9XOiZ
 LcUN1wPuAmQz+RIWhwW7g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Cheng <crquan@gmail.com> wrote:

> use module_init/module_exit to replace the original cond-compiling, these
> macros were well designed to deal module/built-in compiling.
> 
> the original __setup with null string was invalid and not executed,
> __setup("", ide_setup);
> 
> however, with the current module_param mechanics, module parameters also can
> be input on the kernel command line, with this style:
> 
> ide-core.options="ide=nodma hdd=cdrom idebus=..."
> 
> so Documentation/kernel-parameters.txt also updated.

> --- a/Documentation/kernel-parameters.txt

> -     ide=            [HW] (E)IDE subsystem
> -                     Format: ide=nodma or ide=doubler or ide=reverse
> -                     See Documentation/ide.txt.
> -
> -     ide?=           [HW] (E)IDE subsystem
> -                     Format: ide?=noprobe or chipset specific parameters.
> -                     See Documentation/ide.txt.
> -
> -     idebus=         [HW] (E)IDE subsystem - VLB/PCI bus speed
> +     ide-core.options= [HW] (E)IDE subsystem
> +                     Format: ide-core.options="ide=nodma hdd=cdrom idebus=..."

IMO you should use separate options for things like nodma while you're at it.

¢¢

