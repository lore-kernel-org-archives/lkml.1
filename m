Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbYBYHsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbYBYHsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 02:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYBYHsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 02:48:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:24081 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbYBYHsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 02:48:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=A0oQzv1Pa8fudY4gFXc9L9s+YJCmNk4L1K9Jz85vSlH30+moeuzJA3WU2z18ckEKE+Avr1weGn3HLDxNAuTrOiO/a34JzOzhOoKQ3bVSQevE0WHjlK2LUberN9H3llP/1F2LLpZ0M3o2beoqWZVBm7eJl3ygozygjtK1QYgGTlo=
Message-ID: <fe810cf0802242348w625a7e7bj1a5476d6c79662@mail.gmail.com>
Date: Mon, 25 Feb 2008 10:48:10 +0300
From: "Alexander Belyakov" <abelyako@googlemail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: jffs2: -ENOSPC when truncating file?!
Cc: "kernel list" <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org, "David Woodhouse" <dwmw2@infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>
In-Reply-To: <20080223235742.GE2202@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080223235742.GE2202@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 2:57 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>  I'm trying to free space by truncating big file, and I get:
>
>  root@fic-gta01:~# ls -al gps.nmea
>  -rw-r--r--    1 root     root      2332070 Feb 19 22:13 gps.nmea
>  root@fic-gta01:~# > gps.nmea
>  -sh: cannot create gps.nmea: No space left on device
>  root@fic-gta01:~# rm gps.nmea
>  root@fic-gta01:~# > gps.nmea
>  root@fic-gta01:~#
>
>  :-(
>
>  Kernel is not-so-ancient, on openmoko:

Hi!

JFFS2 has known bug in GC leading to -ENOSPC upon file removal. Time
ago I've sent a patch with detailed explanations of what is going on.
Probably your case is the same.

Here is the patch
http://lists.infradead.org/pipermail/linux-mtd/2007-December/020091.html
(though infradead mailing list archive is missing most of messages
from this thread)

And here are some details
http://lists.infradead.org/pipermail/linux-mtd/2007-June/018756.html

Alexander
