Return-Path: <linux-kernel-owner+w=401wt.eu-S933389AbXGOB7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389AbXGOB7U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 21:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932409AbXGOB7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 21:59:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50391 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390AbXGOB7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 21:59:12 -0400
Date: Sun, 15 Jul 2007 03:58:11 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3][try 1] init: enable system-on-initramfs
In-Reply-To: <4699337E.2060908@zytor.com>
Message-ID: <Pine.LNX.4.58.0707150339480.2213@be1.lrz>
References: <Pine.LNX.4.58.0707132039080.3222@be1.lrz> <4697D6EB.5020404@zytor.com>
 <Pine.LNX.4.58.0707132344140.13842@be1.lrz> <469801B7.7010909@zytor.com>
 <Pine.LNX.4.58.0707141629510.5288@be1.lrz> <469919D5.3070709@zytor.com>
 <Pine.LNX.4.58.0707142141030.2346@be1.lrz> <4699337E.2060908@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+VQOo7vdKi2a0op8pxnVmGHT5ECcevJR6aCeB
 ViTx9hA8gXXzAUZIGtQ8UUpIiVoSZnDEFeNVVvbbqyy/dhkvrP
 4Qv2HxdGy/sU7bfnfDcaw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jul 2007, H. Peter Anvin wrote:
> Bodo Eggert wrote:
> > On Sat, 14 Jul 2007, H. Peter Anvin wrote:
> >> Bodo Eggert wrote:

> >>> Setting the name of the rdinit process to the name of the init process
> >>> in order to select the root device should not be the right knob.
> >>>
> >> What's wrong with it?
> > 
> > rdinit is supposed to be the program that mounts, root is supposed to be 
> > whatever is mounted and init is supposed to run the system. Three 
> > different things. Now if you want to change the third, just set the first 
> > to the second ...
> 
> That only applies to a model that you explicitly doesn't want to use.

I don't want to use rdinit, because there is no task for rdinit(3), and I 
don't want to mount a filesystem(3). But I do want to use init(2).

I have to lie to the kernel saying (2) is (1) in order to trick it into
beleaving I'd do (3) myself, which I don't, just in order to not do (3).
If the bug of not calling the security hook would be fixed, this trick
would use the path where rdinit is expected to trigger the callback, but
since that rdinit would be no rdinit, that callback would still be wrongly
skipped. That would not be a bad thing for my setup, but it clearly shows
this setup to be wrong.

The correct solution is tell the kernel not to do (3) if you don't want 
it to do (3). The rest will work as intended.

-- 
This message transmitted on 100% recycled electrons. 
