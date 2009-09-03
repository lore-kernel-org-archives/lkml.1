Return-Path: <linux-kernel-owner+w=401wt.eu-S932073AbZICOFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbZICOFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 10:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755316AbZICOFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 10:05:31 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:60703 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbZICOF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 10:05:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=IzKnUjZrwitfe+Cg7M/mXuwSOibd6v/QhKCQbr+oT8n+lkhy6mIxOAdjFelG0MJfJR
         NhslZr6ElZwm5aCy43nXa/+l2xbeng+vI3ckboOu9aWnS0LVTorMh+pyQFBDEXNyw7q3
         tKtb4e5HIJ4lSFmsLn1PC3DgEyirlCgzbLsj8=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0909031246010.27903@V090114053VZO-1>
References: <c4e36d110908110542l3de51aaepcbd62c84b9848f2b@mail.gmail.com>
	 <4A896324.3040104@trash.net>
	 <c4e36d110909021445l5f44183es9e338437dfbbd195@mail.gmail.com>
	 <4A9EEF07.5070800@gmail.com>
	 <c4e36d110909021531v324a9ce2x3ff2c93b7c5a57de@mail.gmail.com>
	 <4A9F1620.2080105@gmail.com>
	 <84144f020909022331x2b275aa5n428f88670e0ae8bc@mail.gmail.com>
	 <4A9F7283.1090306@gmail.com>
	 <84144f020909030051u6cf6ae01he25c268f718ff3af@mail.gmail.com>
	 <alpine.DEB.1.10.0909031246010.27903@V090114053VZO-1>
Date: Thu, 3 Sep 2009 17:05:30 +0300
X-Google-Sender-Auth: 70f942cb88801efc
Message-ID: <84144f020909030705x7909cf07w7ea0d3662a66c5cc@mail.gmail.com>
Subject: Re: [PATCH] slub: fix slab_pad_check() and SLAB_DESTROY_BY_RCU
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Patrick McHardy <kaber@trash.net>, Robin Holt <holt@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Netfilter Developers <netfilter-devel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Thu, 3 Sep 2009, Pekka Enberg wrote:
>> Oh, sure, the fix looks sane to me. It's just that I am a complete
>> coward when it comes to merging RCU related patches so I always try to
>> fish an Acked-by from Paul or Christoph ;).

On Thu, Sep 3, 2009 at 8:50 PM, Christoph
Lameter<cl@linux-foundation.org> wrote:
> I am fine with acking the poison piece.

Ok.

On Thu, Sep 3, 2009 at 8:50 PM, Christoph
Lameter<cl@linux-foundation.org> wrote:
> I did not ack the patch that added rcu to kmem_cache_destroy() and I
> likely wont ack that piece either.

Right. I didn't remember that I merged that over your NAK but I don't
share your view that kmem_cache_destroy() callers should do
rcu_barrier() or whatever is necessary if we can do it from
kmem_cache_destroy(). So I am happy to take both changes but I would
appreciate them being split into two separate patches.

                        Pekka
