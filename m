Return-Path: <linux-kernel-owner+w=401wt.eu-S933223AbYBBQ0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223AbYBBQ0s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 11:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765662AbYBBQ0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 11:26:18 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:8495 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760740AbYBBQ0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 11:26:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y8j+nO26HFGEKZRqXeqcxpCu26/aCPzwthWEM45AeQdDEfmL8IMnK0K1oYQUdXRY7NyHm6lKns3VH1zWXWgHCjW4B0o8yrPuhrqRlSjIltyxDDMyhGGnJha+Wk3U9SCTRpKJNJdKgc52OaRWNPZexz8ZcfRQA9vfOgGSzXDPGJ4=
Message-ID: <40f31dec0802020826y6ab12219j8d22093462cc5a52@mail.gmail.com>
Date: Sat, 2 Feb 2008 18:26:15 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Denis Cheng" <crquan@gmail.com>
Subject: Re: [PATCH] wireless/ath5k: renamed to ath5k_pci_driver to fix Section mismatch warnings
Cc: "Jiri Slaby" <jirislaby@gmail.com>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1201920910-6649-1-git-send-email-crquan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201920910-6649-1-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/2/2, Denis Cheng <crquan@gmail.com>:
> the struct pci_driver refered ath5k_pci_id_table which in __devinit section,
> the sparse tool suggest this renamed to "*driver", kills mismatch warnings.
>
> Signed-off-by: Denis Cheng <crquan@gmail.com>
> ---
>  drivers/net/wireless/ath5k/base.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index d6599d2..ddc8714 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -153,7 +153,7 @@ static int          ath5k_pci_resume(struct pci_dev *pdev);
>  #define ath5k_pci_resume NULL
>  #endif /* CONFIG_PM */
>
> -static struct pci_driver ath5k_pci_drv_id = {
> +static struct pci_driver ath5k_pci_driver = {
>         .name           = "ath5k_pci",
>         .id_table       = ath5k_pci_id_table,
>         .probe          = ath5k_pci_probe,
> @@ -329,7 +329,7 @@ init_ath5k_pci(void)
>
>         ath5k_debug_init();
>
> -       ret = pci_register_driver(&ath5k_pci_drv_id);
> +       ret = pci_register_driver(&ath5k_pci_driver);
>         if (ret) {
>                 printk(KERN_ERR "ath5k_pci: can't register pci driver\n");
>                 return ret;
> @@ -341,7 +341,7 @@ init_ath5k_pci(void)
>  static void __exit
>  exit_ath5k_pci(void)
>  {
> -       pci_unregister_driver(&ath5k_pci_drv_id);
> +       pci_unregister_driver(&ath5k_pci_driver);
>
>         ath5k_debug_finish();
>  }
> --
> 1.5.3.8
>
>

Thanx ;-)

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
