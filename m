Return-Path: <linux-kernel-owner+w=401wt.eu-S1761165AbZEGBjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761165AbZEGBjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 21:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759536AbZEGBjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 21:39:31 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:58529 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758248AbZEGBja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 21:39:30 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 6 May 2009 18:34:52 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: viro@ZenIV.linux.org.uk, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com
Subject: Re: [KVM PATCH v4 2/2] kvm: add support for irqfd via eventfd-notification
 interface
In-Reply-To: <4A01AEC1.8020201@novell.com>
Message-ID: <alpine.DEB.1.10.0905061834080.32606@makko.or.mcafeemobile.com>
References: <20090504175657.26758.12503.stgit@dev.haskins.net> <20090504175750.26758.7023.stgit@dev.haskins.net> <4A0175F0.1090705@novell.com> <alpine.DEB.1.10.0905060818000.32007@makko.or.mcafeemobile.com> <4A01AEC1.8020201@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009, Gregory Haskins wrote:

> I think we are ok in this regard (at least in v5) without the callback. 
> kvm holds irqfd, which holds eventfd.  In a normal situation, we will
> have eventfd with 2 references.  If userspace closes the eventfd, it
> will drop 1 of the 2 eventfd file references, but the object should
> remain intact as long as kvm still holds it as well.  When the kvm-fd is
> released, we will then decouple from the eventfd->wqh and drop the last
> fput(), officially freeing it.
> 
> Likewise, if kvm is closed before the eventfd, we will simply decouple
> from the wqh and fput(eventfd), leaving the last reference held by
> userspace until it closes as well.
> 
> Let me know if you see any holes in that.

Looks OK, modulo my knowledge of KVM internals.


- Davide


