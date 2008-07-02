Return-Path: <linux-kernel-owner+w=401wt.eu-S1754310AbYGBSUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbYGBSUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 14:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYGBSUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 14:20:42 -0400
Received: from chrocht.moloch.sk ([62.176.169.44]:36082 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbYGBSUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 14:20:41 -0400
Message-ID: <486BC6F7.2090709@fastmq.com>
Date: Wed, 02 Jul 2008 20:20:39 +0200
From: Martin Sustrik <sustrik@fastmq.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Roger Heflin <rogerheflin@gmail.com>, Martin Lucina <mato@kotelna.sk>,
       linux-kernel@vger.kernel.org
Subject: Re: Higher than expected disk write(2) latency
References: <20080628121131.GA14181@nodbug.moloch.sk>	<48663873.5010200@gmail.com> <486921AD.8060308@fastmq.com>	<48692DC0.6060904@gmail.com> <486BB14D.5060609@fastmq.com> <x49abh0p2y1.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49abh0p2y1.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I thought you were doing I/O to the underlying block device.  If so,
> there's no need to open with O_SYNC.  You do, however, need to open the
> device with O_DIRECT and align your buffers (and buffer lengths)
> properly.

Yes, we are using O_DIRECT + aligning the buffers. However, usign O_SYNC 
vs. O_ASYNC seems to matter (different latency). Maybe this is because 
we are using librt?

> Which AIO interface are you using, libaio or librt?  How many I/Os are
> you queueing to the device?  You may want to take a look at aio-stress.c
> as a way to test your device (this uses libaio, the in-kernel AIO
> interface).

We are using librt, queueing 10240 writes, 512 bytes each.

We'll retry with libaio. Thanks for advice.

Martin
