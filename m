Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbXJ0Gkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbXJ0Gkk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 02:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbXJ0Gke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 02:40:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55308 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbXJ0Gkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 02:40:33 -0400
Date: Sat, 27 Oct 2007 07:40:29 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Shannon Nelson <shannon.nelson@intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, greg@kroah.com,
       hskinnemoen@atmel.com, dan.j.williams@intel.com
Subject: Re: [PATCH] DMAENGINE: too many kref_put calls
Message-ID: <20071027064029.GM8181@ftp.linux.org.uk>
References: <20071026235648.5737.45405.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026235648.5737.45405.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 04:56:48PM -0700, Shannon Nelson wrote:

>  static void dma_dev_release(struct device *dev)
>  {
> -	struct dma_chan *chan = to_dma_chan(dev);
> -	kref_put(&chan->device->refcount, dma_async_device_cleanup);
> +	return;
>  }

Practically guaranteed to be broken.  Empty ->release() is almost certain
to mean that you can get operations on already freed object.
