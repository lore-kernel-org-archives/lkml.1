Return-Path: <linux-kernel-owner+w=401wt.eu-S1760824AbZE0RZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760824AbZE0RZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 13:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756789AbZE0RZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 13:25:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37188 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756021AbZE0RZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 13:25:48 -0400
Subject: Re: [KVM PATCH v4 3/3] kvm: add iosignalfd support
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
       mtosatti@redhat.com
In-Reply-To: <4A1D2DD8.2050709@redhat.com>
References: <20090526191010.20860.75372.stgit@dev.haskins.net>
	 <20090526191539.20860.1385.stgit@dev.haskins.net>
	 <4A1D01F8.8080508@redhat.com> <4A1D285C.9050008@novell.com>
	 <4A1D2DD8.2050709@redhat.com>
Content-Type: text/plain
Date: Wed, 27 May 2009 17:25:44 +0000
Message-Id: <1243445144.16318.15.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 15:11 +0300, Avi Kivity wrote:

> Multiple cookies on the same address are required by virtio.  You can't 
> mux since the data doesn't go anywhere.
> 
> Virtio can survive by checking all rings on a notify, and we can later 
> add a mechanism that has a distinct address for each ring, but let's see 
> if we can cope with multiple cookies.  Mark?

Trying to catch up, but you're talking about replacing virtio-pci
QUEUE_NOTIFY handling with iosignalfd ?

For a perfect replacement, what you really need is to be able to
register multiple cookies per address range, but only have them trigger
if the written data matches a provided value.

If the data is lost, virtio has no way of knowing which queue is being
notified, so we either end up with per-device, rather than per-queue,
notifications (probably not too bad for net, at least) or a different
notify address per queue (limiting the number of queues per device).

Cheers,
Mark.

