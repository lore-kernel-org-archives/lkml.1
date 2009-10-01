Return-Path: <linux-kernel-owner+w=401wt.eu-S932133AbZJAJiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbZJAJiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 05:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbZJAJiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 05:38:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754771AbZJAJiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 05:38:07 -0400
Date: Thu, 1 Oct 2009 11:35:48 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 29/34] move virtballoon_remove to .devexit.text
Message-ID: <20091001093548.GH5718@redhat.com>
References: <20091001082607.GA2181@pengutronix.de> <1254385718-14254-29-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1254385718-14254-29-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 10:28:33AM +0200, Uwe Kleine-König wrote:
> The function virtballoon_remove is used only wrapped by __devexit_p so
> define it using __devexit.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: linux-kernel@vger.kernel.org

Acked-by: Michael S. Tsirkin <mst@redhat.com>

Generally I think all remove pointers on virtio bus are devexit.  How do
you find all these, and remember to mark new ones properly?  Can we
annotate the remove pointer in struct virtio_driver so that sparse can
find them?

> ---
>  drivers/virtio/virtio_balloon.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 200c22f..b2d28bb 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -248,7 +248,7 @@ out:
>  	return err;
>  }
>  
> -static void virtballoon_remove(struct virtio_device *vdev)
> +static void __devexit virtballoon_remove(struct virtio_device *vdev)
>  {
>  	struct virtio_balloon *vb = vdev->priv;
>  
> -- 
> 1.6.4.3
