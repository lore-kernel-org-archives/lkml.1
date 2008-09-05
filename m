Return-Path: <linux-kernel-owner+w=401wt.eu-S1752315AbYIEADz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbYIEADz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 20:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbYIEADn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 20:03:43 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:47178 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbYIEADm (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 20:03:42 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] HID: fix tty<->hid deadlock
In-Reply-To: Your message of "Thu, 04 Sep 2008 17:16:07 +0200."
             <1220541367-10984-1-git-send-email-jirislaby@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <48BFFAE0.5010001@gmail.com>
            <1220541367-10984-1-git-send-email-jirislaby@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1220573006_3066P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 04 Sep 2008 20:03:26 -0400
Message-ID: <3717.1220573006@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1220573006_3066P
Content-Type: text/plain; charset=us-ascii

On Thu, 04 Sep 2008 17:16:07 +0200, Jiri Slaby said:

> hid_compat_load() runs on the default workqueue, it request_module(), it
> execs modprobe, it exits, tty flushes default workqueue, it hangs, because
> we are still in it.
> 
> I haven't run into it since there always was at least one opener of the tty,
> I guess. Could you try the patch below?
> 
> --
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  drivers/hid/hid-core.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 92c16e1..18d952a 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c

With this patch applied, the kernel behaves as expected for my config: it
requests a 'modprobe hid_dummy', which prints a nasty message about being
unable to find it on the initrd, and then we continue with the boot.

Thanks for the quick fix...

--==_Exmh_1220573006_3066P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIwHdOcC3lWbTT17ARArj3AKD0ASFsYPnjn1rC0svO+2Z/W30ZKgCg9s6k
WnegiFLQrVjNvZLWWRTKRxQ=
=r6SI
-----END PGP SIGNATURE-----

--==_Exmh_1220573006_3066P--
