Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbYIPHGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbYIPHGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 03:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbYIPHF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 03:05:59 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:33253 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYIPHF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 03:05:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=D1mtHbnxEMDLzZnq3Shw86awKpjn/FoQXvb7X0Dfari5t3xqJJx9N7fGRoKEC8XhbK
         gESzxkMAVXdV8OeZwbMxIwLniLQO64OwupGmOf2+XGn7jXVdoRhw1I9Cz//HHY5k6Gci
         mVKKKieA1mOYmCvW9jnw0lIVLo7q5h8rLfERA=
Message-ID: <71cd59b00809160005t62bbeb7ek984a47e61b452049@mail.gmail.com>
Date: Tue, 16 Sep 2008 09:05:56 +0200
From: "Corentin Chary" <corentin.chary@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH -mm] eeepc: depends on RFKILL
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       acpi4asus-user@lists.sourceforge.net
In-Reply-To: <20080915125258.77b14e2b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080915125258.77b14e2b.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yep, it should depends on RFKILL, and I should start porting
asus-laptop to rfkill.
Thanks for this patch.

On Mon, Sep 15, 2008 at 9:52 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> EEEPC_LAPTOP uses RFKILL, so the former should depend on RFKILL.
> Build errors happen when EEEPC_LAPTOP=y and RFKILL=m.
>
> eeepc-laptop.c:(.text+0xd5a7b): undefined reference to `rfkill_allocate'
> eeepc-laptop.c:(.text+0xd5b04): undefined reference to `rfkill_register'
> eeepc-laptop.c:(.text+0xd5b48): undefined reference to `rfkill_allocate'
> eeepc-laptop.c:(.text+0xd5bd4): undefined reference to `rfkill_register'
> eeepc-laptop.c:(.text+0xd5ece): undefined reference to `rfkill_unregister'
> eeepc-laptop.c:(.text+0xd5ef6): undefined reference to `rfkill_unregister'
> make[1]: *** [.tmp_vmlinux1] Error 1
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Corentin Chary <corentincj@iksaif.net>
> ---
>  drivers/misc/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>
> --- linux-2.6.27-rc5-mm1.orig/drivers/misc/Kconfig
> +++ linux-2.6.27-rc5-mm1/drivers/misc/Kconfig
> @@ -410,6 +410,7 @@ config EEEPC_LAPTOP
>        depends on BACKLIGHT_CLASS_DEVICE
>        depends on HWMON
>        depends on EXPERIMENTAL
> +       depends on RFKILL
>        ---help---
>          This driver supports the Fn-Fx keys on Eee PC laptops.
>          It also adds the ability to switch camera/wlan on/off.
>
