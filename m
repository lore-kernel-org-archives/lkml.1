Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbZICTsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbZICTsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 15:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756186AbZICTsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 15:48:11 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:51253 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206AbZICTsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 15:48:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=vFtvH7g/NO67xjI45O4ich7Wh8Q9pO70XQmEP1OLfiu2V/VXQnf92LrkFUhASYw3G1
         ORlhA/OMblFNKISclS3AFGjI4A2i4DgB2N0RLfHYkabCx2MWFIojls/+7l5huYhIR/qS
         gaPW6Wk0DScGo5lycZrs68+wpQ7+wrwVTdz/k=
MIME-Version: 1.0
In-Reply-To: <4A9FD047.9000002@gmail.com>
References: <c4e36d110908110542l3de51aaepcbd62c84b9848f2b@mail.gmail.com>
	 <4A9EEF07.5070800@gmail.com>
	 <c4e36d110909021531v324a9ce2x3ff2c93b7c5a57de@mail.gmail.com>
	 <4A9F1620.2080105@gmail.com>
	 <84144f020909022331x2b275aa5n428f88670e0ae8bc@mail.gmail.com>
	 <4A9F7283.1090306@gmail.com>
	 <84144f020909030051u6cf6ae01he25c268f718ff3af@mail.gmail.com>
	 <alpine.DEB.1.10.0909031246010.27903@V090114053VZO-1>
	 <84144f020909030705x7909cf07w7ea0d3662a66c5cc@mail.gmail.com>
	 <4A9FD047.9000002@gmail.com>
Date: Thu, 3 Sep 2009 22:48:10 +0300
X-Google-Sender-Auth: 06209338a1409741
Message-ID: <84144f020909031248s56c16205j7992930c413b1bbe@mail.gmail.com>
Subject: Re: [PATCH] slub: Fix kmem_cache_destroy() with SLAB_DESTROY_BY_RCU
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Patrick McHardy <kaber@trash.net>, Robin Holt <holt@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Netfilter Developers <netfilter-devel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com, "stable@kernel.org" <stable@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 3, 2009 at 5:18 PM, Eric Dumazet<eric.dumazet@gmail.com> wrote:
> Here is the second patch (RCU thing). Stable candidate
>
> [PATCH] slub: Fix kmem_cache_destroy() with SLAB_DESTROY_BY_RCU
>
> kmem_cache_destroy() should call rcu_barrier() *after* kmem_cache_close()
> and *before* sysfs_slab_remove() or risk rcu_free_slab()
> being called after kmem_cache is deleted (kfreed).
>
> rmmod nf_conntrack can crash the machine because it has to
> kmem_cache_destroy() a SLAB_DESTROY_BY_RCU enabled cache.

Do we have a bugzilla URL for this?

> Reported-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

OK, this is in for-next now and queued for 2.6.31. If you guys want to
fix this in a different way, lets do that in 2.6.32.

                        Pekka
