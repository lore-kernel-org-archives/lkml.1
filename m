Return-Path: <linux-kernel-owner+w=401wt.eu-S1759568AbXGXW1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568AbXGXW1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 18:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756759AbXGXW1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 18:27:11 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:48364 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333AbXGXW1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 18:27:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=FnBOKePCcYaGmV8ES/F0pQ8wVuD2UaHYTn04+Oz3Fj0Uyp/jcp/7c+JEPQFBAvBsI1T4WT2+T+Hq9ylUDQP+iHDk6Ojirh5BfOVg74ujrbU9JVXh3sxi1fIRGM1993ymaB9/DJe2TZWnYlao6NCfUQVzX3c7FNiZ3UDpj9JgVgA=
Message-ID: <e9c3a7c20707241527o55f3b2dbh4d218c96c6bb612b@mail.gmail.com>
Date: Tue, 24 Jul 2007 15:27:05 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: linux-kernel@vger.kernel.org,
       "device-mapper development" <dm-devel@redhat.com>
Subject: Re: [PATCH 2/8] dm: Fix workqueue leak for raid5
In-Reply-To: <20070724085642.GB16507@dnb.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070724085106.GD20538@dnb.sw.ru>
	 <20070724085642.GB16507@dnb.sw.ru>
X-Google-Sender-Auth: 66fac2675c06b5fc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/07, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  drivers/md/raid5.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 0f30826..79dd2c7 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4985,6 +4985,8 @@ static int run(mddev_t *mddev)
>  abort:
>         if (conf) {
>                 print_raid5_conf(conf);
> +               if (conf->workqueue)
> +                       destroy_workqueue(conf->workqueue);
>                 safe_put_page(conf->spare_page);
>                 kfree(conf->disks);
>                 kfree(conf->stripe_hashtbl);
> --
I assume this patch is against -mm.  I will fold it into:

git://lost.foo-projects.org/~dwillia2/git/iop md-for-linus

Thanks,
Dan
