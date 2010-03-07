Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab0CGL0l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 06:26:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab0CGL0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 06:26:40 -0500
Date: Sun, 7 Mar 2010 13:18:16 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, jdike@c2.user-mode-linux.org
Subject: Re: [PATCH v1 2/3] Provides multiple submits and asynchronous
	notifications.
Message-ID: <20100307111816.GC20004@redhat.com>
References: <1267868318-19268-1-git-send-email-xiaohui.xin@intel.com> <1267868318-19268-2-git-send-email-xiaohui.xin@intel.com> <1267868318-19268-3-git-send-email-xiaohui.xin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267868318-19268-3-git-send-email-xiaohui.xin@intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/* The structure to notify the virtqueue for async socket */
> +struct vhost_notifier {
> +	struct list_head list;
> +	struct vhost_virtqueue *vq;
> +	int head;
> +	int size;
> +	int log;
> +	void *ctrl;
> +	void (*dtor)(struct vhost_notifier *);
> +};
> +

So IMO, this is not the best interface between vhost
and your driver, exposing them to each other unnecessarily.

If you think about it, your driver should not care about this structure.
It could get e.g. a kiocb (sendmsg already gets one), and call ki_dtor
on completion.  vhost could save it's state in ki_user_data.  If your
driver needs to add more data to do more tracking, I think it can put
skb pointer in the private pointer.

-- 
MST
