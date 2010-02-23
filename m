Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab0BWTbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 14:31:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab0BWTbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 14:31:22 -0500
From: Juan Quintela <quintela@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
       virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       markmc@redhat.com, gleb@redhat.com, herbert.xu@redhat.com,
       dlaor@redhat.com, avi@redhat.com
Subject: Re: [PATCH 2/3] vhost: initialize log eventfd context pointer
In-Reply-To: <f383d82104a04b92fe2953a4d8a98425c1ff6cde.1266943453.git.mst@redhat.com>
	(Michael S. Tsirkin's message of "Tue, 23 Feb 2010 18:57:51 +0200")
References: <cover.1266943453.git.mst@redhat.com>
	<f383d82104a04b92fe2953a4d8a98425c1ff6cde.1266943453.git.mst@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
Date: Tue, 23 Feb 2010 20:31:11 +0100
Message-ID: <m37hq3wxz4.fsf@trasno.mitica>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> wrote:
> vq log eventfd context pointer needs to be initialized, otherwise
> operation may fail or oops if log is enabled but log eventfd not set by
> userspace.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Reviewed-by: Juan Quintela <quintela@redhat.com>

When log_ctx for device is created, it is copied to the vq.  This reset
was missing.

> ---
>  drivers/vhost/vhost.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index c767279..d4f8fdf 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -121,6 +121,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>  	vq->kick = NULL;
>  	vq->call_ctx = NULL;
>  	vq->call = NULL;
> +	vq->log_ctx = NULL;
>  }
>  
>  long vhost_dev_init(struct vhost_dev *dev,
