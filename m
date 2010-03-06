Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab0CFRTK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 12:19:10 -0500
Received: from mail.vyatta.com ([76.74.103.46]:55798 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049Ab0CFRTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 12:19:08 -0500
Date: Sat, 6 Mar 2010 09:18:49 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, mst@redhat.com, jdike@c2.user-mode-linux.org,
       Zhao Yu <yzhao81@gmail.com>
Subject: Re: [PATCH v1 3/3] Let host NIC driver to DMA to guest user space.
Message-ID: <20100306091849.0e5d2a66@s6510>
In-Reply-To: <1267868318-19268-4-git-send-email-xiaohui.xin@intel.com>
References: <1267868318-19268-1-git-send-email-xiaohui.xin@intel.com>
	<1267868318-19268-2-git-send-email-xiaohui.xin@intel.com>
	<1267868318-19268-3-git-send-email-xiaohui.xin@intel.com>
	<1267868318-19268-4-git-send-email-xiaohui.xin@intel.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  6 Mar 2010 17:38:38 +0800
xiaohui.xin@intel.com wrote:

> From: Xin Xiaohui <xiaohui.xin@intel.com>
> 
> The patch let host NIC driver to receive user space skb,
> then the driver has chance to directly DMA to guest user
> space buffers thru single ethX interface.
> 
> Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
> Signed-off-by: Zhao Yu <yzhao81@gmail.com>
> Sigend-off-by: Jeff Dike <jdike@c2.user-mode-linux.org>
> ---
>  include/linux/netdevice.h |   76 ++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/skbuff.h    |   30 +++++++++++++++--
>  net/core/dev.c            |   32 ++++++++++++++++++
>  net/core/skbuff.c         |   79 +++++++++++++++++++++++++++++++++++++++++----
>  4 files changed, 205 insertions(+), 12 deletions(-)
> 

There are too many ifdef's in this implementation.
I would prefer to see a few functions (with stub for the non-ifdef case),
like the network namespace code.
