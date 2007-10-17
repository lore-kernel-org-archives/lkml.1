Return-Path: <linux-kernel-owner+w=401wt.eu-S1762520AbXJQTkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762520AbXJQTkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbXJQTkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:40:05 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:46852 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbXJQTkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:40:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GcA8GAuZwovW9G1XCEEC8hrS5pA/xslsk44B2k78eI1PwNRkKkCa/AQcCI23oGwZ/7VBOvjZB2wmEfDovaftvopsNHM1o9Uv4nqVP0QNFXuorWzS8kkDllP4Ck/h/AUuJPgNfVZY1TeHQEIfGWfug/qA2RANcZij993YhOUtUZ8=
Message-ID: <29495f1d0710171239i30776a2ci6db65c4f135b0754@mail.gmail.com>
Date: Wed, 17 Oct 2007 12:39:59 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] hwmon/ibmpex.c: fix NULL dereference
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071017192902.GB3778@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071017192902.GB3778@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/07, Adrian Bunk <bunk@kernel.org> wrote:
> Don't dereference "data" when we know for sure it's NULL.
>
> Spotted by the Coverity checker.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> ---
> 66bec2ef5c6d55fc30ef6ac5bb97fdfcfaf394f2
> diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
> index c462824..e14ce3d 100644
> --- a/drivers/hwmon/ibmpex.c
> +++ b/drivers/hwmon/ibmpex.c
> @@ -457,7 +457,7 @@ static void ibmpex_register_bmc(int iface, struct device *dev)
>         data = kzalloc(sizeof(*data), GFP_KERNEL);
>         if (!data) {
>                 printk(KERN_ERR DRVNAME ": Insufficient memory for BMC "
> -                      "interface %d.\n", data->interface);
> +                      "interface.\n");

Hrm but what data->interface would be is specified by the iface
parameter? Just spit that out instead?

Thanks,
Nish
