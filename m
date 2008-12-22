Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbYLVCK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbYLVCK3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 21:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbYLVCKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 21:10:19 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:39893 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbYLVCKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 21:10:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NyI8Dv5CC10KVLtvH07JaABCYdijYMIcrh4s56CdTd6E9+Ylpskk8uh7s5HyYVSy1w
         PEL4PLBVD+a6DaDmYeCbst2CK8JrA7ww1pVZsgJ9k9plr7o7jp9ZwA5VeA5NE5aV7xFT
         sknJO38tgZcr7ZalbfWaYrN/3/i2nMJL3Wp2o=
Message-ID: <1197ff4c0812211810s796a367m7b5dc6b43724c0e0@mail.gmail.com>
Date: Mon, 22 Dec 2008 10:10:17 +0800
From: YanBo <dreamfly281@gmail.com>
To: "Julia Lawall" <julia@diku.dk>
Subject: Re: [PATCH 2/3] drivers/staging/agnx: Move a dereference below a NULL test
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0812191810240.11217@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0812191810240.11217@ask.diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2008 at 1:11 AM, Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
>
> If the NULL test is necessary, then the dereference should be moved below
> the NULL test.
>
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
>
> // <smpl>
> @@
> type T;
> expression E;
> identifier i,fld;
> statement S;
> @@
>
> - T i = E->fld;
> + T i;
>  ... when != E
>      when != i
>  if (E == NULL) S
> + i = E->fld;
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
>
> ---
>  drivers/staging/agnx/pci.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff -u -p a/drivers/staging/agnx/pci.c b/drivers/staging/agnx/pci.c
> --- a/drivers/staging/agnx/pci.c
> +++ b/drivers/staging/agnx/pci.c
> @@ -440,11 +440,12 @@ static struct ieee80211_ops agnx_ops = {
>  static void __devexit agnx_pci_remove(struct pci_dev *pdev)
>  {
>        struct ieee80211_hw *dev = pci_get_drvdata(pdev);
> -       struct agnx_priv *priv = dev->priv;
> +       struct agnx_priv *priv;
>        AGNX_TRACE;
>
>        if (!dev)
>                return;
> +       priv = dev->priv;
>        ieee80211_unregister_hw(dev);
>        pci_iounmap(pdev, priv->ctl);
>        pci_iounmap(pdev, priv->data);
>

Thanks! Will pulled to the AGNX git tree.

BR
Yanbo
