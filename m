Return-Path: <linux-kernel-owner+w=401wt.eu-S1765669AbXIMG5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765669AbXIMG5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 02:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759669AbXIMG45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 02:56:57 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:44170 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759493AbXIMG44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 02:56:56 -0400
Date: Thu, 13 Sep 2007 08:58:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Jeff Garzik <jeff@garzik.org>, Kees Cook <kees@ubuntu.com>,
       linux-kernel@vger.kernel.org, Ben Collins <bcollins@ubuntu.com>,
       Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] pci: fix unterminated pci_device_id lists
Message-ID: <20070913065819.GA23235@uranus.ravnborg.org>
References: <20070912064134.GO7910@outflux.net> <46E7C91D.3070001@garzik.org> <b6fcc0a0709120448s69528fc9reed593229124a4fa@mail.gmail.com> <20070912215356.GC23294@kroah.com> <20070912160827.e359a53b.akpm@linux-foundation.org> <b6fcc0a0709122334qa31fffby4afbf857c92efb89@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6fcc0a0709122334qa31fffby4afbf857c92efb89@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 10:34:02AM +0400, Alexey Dobriyan wrote:
> [non-terminated PCI ids arrays]
> 
> Here is compile-time hack (yep, warped and whitespace damaged :))
> It's better than modpost-time hack. because it triggers earlier.
> It's worse than modpost-time hack, because of tree-wide changes.
> 
> diff --git a/drivers/net/8139too.c b/drivers/net/8139too.c
> index f4e4298..b895b5f 100644
> --- a/drivers/net/8139too.c
> +++ b/drivers/net/8139too.c
> @@ -237,7 +237,7 @@ static const struct {
>  };
> 
> 
> -static struct pci_device_id rtl8139_pci_tbl[] = {
> +PCI_MODULE_DEVICE_TABLE_BEGIN(rtl8139_pci_tbl)
>  	{0x10ec, 0x8139, PCI_ANY_ID, PCI_ANY_ID, 0, 0, RTL8139 },
>  	{0x10ec, 0x8138, PCI_ANY_ID, PCI_ANY_ID, 0, 0, RTL8139 },
>  	{0x1113, 0x1211, PCI_ANY_ID, PCI_ANY_ID, 0, 0, RTL8139 },
> @@ -273,10 +273,7 @@ static struct pci_device_id rtl8139_pci_tbl[] = {
>  	{PCI_ANY_ID, 0x8139, 0x10ec, 0x8139, 0, 0, RTL8139 },
>  	{PCI_ANY_ID, 0x8139, 0x1186, 0x1300, 0, 0, RTL8139 },
>  	{PCI_ANY_ID, 0x8139, 0x13d1, 0xab06, 0, 0, RTL8139 },
> -
> -	{0,}
> -};
> -MODULE_DEVICE_TABLE (pci, rtl8139_pci_tbl);
> +PCI_MODULE_DEVICE_TABLE_END

Looks at bit too magic to my taste.
And anyway deferring the check until modpost time should not cause troubles
anyway assuming people do build their kernel after adding a device ID.

And the above requires one to use the special macro in all places
whereas the modpost check will catch it also for new device ID users.

	Sam
