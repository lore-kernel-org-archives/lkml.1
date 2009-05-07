Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbZEGUZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbZEGUZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762013AbZEGUZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:25:29 -0400
Received: from sous-sol.org ([216.99.217.87]:60328 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761977AbZEGUZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:25:27 -0400
Date: Thu, 7 May 2009 13:25:06 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Gregory Haskins <ghaskins@novell.com>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
Message-ID: <20090507202506.GG3036@sequoia.sous-sol.org>
References: <4A032390.6030100@gmail.com> <4A032472.4030106@redhat.com> <4A03259B.3050500@gmail.com> <4A032771.6050703@redhat.com> <4A032A74.2020809@novell.com> <4A032FDD.8020209@redhat.com> <20090507190751.GE3036@sequoia.sous-sol.org> <4A033281.8050002@novell.com> <20090507192145.GF3036@sequoia.sous-sol.org> <4A033685.7070802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A033685.7070802@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gregory Haskins (gregory.haskins@gmail.com) wrote:
> What I am not clear on is how you would know to flag the address to
> begin with.

That's why I mentioned pv_io_ops->iomap() earlier.  Something I'd expect
would get called on IORESOURCE_PVIO type.  This isn't really transparent
though (only virtio devices basically), kind of like you're saying below.

> Here's a thought: "PV" drivers can flag the IO (e.g. virtio-pci knows it
> would never be a real device).  This means we route any io requests from
> virtio-pci though pv_io_ops->mmio(), but not unflagged addresses.  This
> is not as slick as boosting *everyones* mmio speed as Avi's original
> idea would have, but it is perhaps a good tradeoff between the entirely
> new namespace created by my original dynhc() proposal and leaving them
> all PF based.
>
> This way, its just like using my dynhc() proposal except the mmio-addr
> is the substitute address-token (instead of the dynhc-vector). 
> Additionally, if you do not PV the kernel the IO_COND/pv_io_op is
> ignored and it just slow-paths through the PF as it does today.  Dynhc()
> would be dependent  on pv_ops.
> 
> Thoughts?
