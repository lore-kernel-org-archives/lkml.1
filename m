Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbYK0Qhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbYK0Qhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 11:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYK0QhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 11:37:21 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53309 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751272AbYK0QhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 11:37:20 -0500
Date: Thu, 27 Nov 2008 16:35:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com,
       matthew@wil.cx
Subject: Re: [PATCH v2 2/2] relatime: Allow making relatime the default
 behaviour
Message-ID: <20081127163535.775729bf@lxorguk.ukuu.org.uk>
In-Reply-To: <20081127150341.GB20941@srcf.ucam.org>
References: <20081126195457.GA3541@srcf.ucam.org>
	<20081126195824.GB3541@srcf.ucam.org>
	<492DD035.5020705@oracle.com>
	<20081127150126.GA20941@srcf.ucam.org>
	<20081127150341.GB20941@srcf.ucam.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +config DEFAULT_RELATIME
> +	bool "Mount all filesystems with relatime by default"
> +	default y

NAK this

This is a change in behaviour and you don't turn it on by default so most
users will miss it. You don't need it anyway and it doesn't need to be
a kernel configuration option

> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -135,6 +135,7 @@ extern int dir_notify_enable;
>  #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
>  #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
>  #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
> +#define MS_NORELATIME	(1<<24)	/* Disable relatime even if the default */

NAK this

Putting in extra flags to allow the kernel and user space to fight each
other over mount defaults is a recipe for disaster. Take your userspace
mount command and beat it up appropriately. If you want a mount command
that defaults to relatime then ship a mount command that does.

This patch really doesn't make sense.

You add a compile time option to vary behaviour
Because it is compile time you then add a way to change it back at runtime
Because you need to override this you then add a flag to mount

It's rather easier just to fix your distribution mount package.

Also please keep different features in different patches. This patch
muddles together

- Improvements to relatime algorithms for stuff like tmpwatch
- A large chunk of material to do with changing mount behaviour

The two are I think unrelated and the algorithm change looks quite
sensible.

Alan
PS: NTL still hates you ;)
