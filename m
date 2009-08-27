Return-Path: <linux-kernel-owner+w=401wt.eu-S1751661AbZH0LKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbZH0LKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 07:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbZH0LKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 07:10:04 -0400
Received: from ozlabs.org ([203.10.76.45]:41781 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbZH0LKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 07:10:03 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCHv4 2/2] vhost_net: a kernel-level virtio server
Date: Thu, 27 Aug 2009 20:40:02 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       gregory.haskins@gmail.com
References: <cover.1250693417.git.mst@redhat.com> <200908252140.41295.rusty@rustcorp.com.au> <20090827104517.GB8545@redhat.com>
In-Reply-To: <20090827104517.GB8545@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908272040.02628.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009 08:15:18 pm Michael S. Tsirkin wrote:
> On Tue, Aug 25, 2009 at 09:40:40PM +0930, Rusty Russell wrote:
> > Also, see other fixes to the lguest launcher since then which might
> > be relevant to this code:
> > 	lguest: get more serious about wmb() in example Launcher code
> 
> Heh, this just gets one step closer to a real wmb.  I just used the
> correct code from linux, so I think nothing needs to be done in vhost.
> Apropos this change in lguest: why is a compiler barrier sufficient? The
> comment says devices are run in separate threads (presumably from
> guest?), if so don't you need to tell CPU that there's a barrier as
> well?

Yep, but x86 only :)  The kernel uses a real insn if XMM/XMM2, but I don't
know if userspace needs that.  I just use compiler barriers.

Thanks,
Rusty.
