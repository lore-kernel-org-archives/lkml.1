Return-Path: <linux-kernel-owner+w=401wt.eu-S1752158AbZHIQkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbZHIQkN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 12:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZHIQkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 12:40:12 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:32770 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbZHIQkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 12:40:11 -0400
Message-ID: <4A7EFBE8.7050409@codemonkey.ws>
Date: Sun, 09 Aug 2009 11:40:08 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org, avi@redhat.com, bhutchings@solarflare.com,
       andi@firstfloor.org, gregkh@suse.de, herber@gondor.apana.org.au,
       chrisw@sous-sol.org, shemminger@vyatta.com,
       "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC PATCH v2 19/19] virtio: add a vbus transport
References: <20090409155200.32740.19358.stgit@dev.haskins.net> <20090409163221.32740.38373.stgit@dev.haskins.net>
In-Reply-To: <20090409163221.32740.38373.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> We add a new virtio transport for accessing backends located on vbus.  This
> complements the existing transports for virtio-pci, virtio-s390, and
> virtio-lguest that already exist.
>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>

Very interesting...

I'm somewhat confused by what you're advocating vbus as.  I'm trying to 
figure out how we converge vbus and virtio and become one big happy 
family :-)

What parts of it do you think are better than virtio?  Should we forget 
about venet and just focus on virtio-net on top of virtio-vbus assuming 
that we can prove venet-tap/virtio-vbus/virtio-net is just as good as 
venet-tap/vbus/venet?

If we can prove that an in-kernel virtio-net 
backend/virtio-pci/virtio-net does just as well as 
venet-tap/virtio-vbus/virtio-net does that mean that vbus is no longer 
needed?

If you concede that the transport mechanisms can be identical, are you 
really advocating the discovering and configuration mechanisms in vbus?  
Is that what we should be focusing on? Do you care only about the host 
mechanisms or do you also require the guest infrastructure to be present?

I think two paravirtual I/O frameworks for KVM is a bad thing.  It 
duplicates a ton of code and will very likely lead to user unhappiness.

Regards,

Anthony Liguori
