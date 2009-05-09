Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbZEIOBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbZEIOBi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 10:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbZEIOB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 10:01:26 -0400
Received: from kroah.org ([198.145.64.141]:34581 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbZEIOBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 10:01:25 -0400
Date: Sat, 9 May 2009 06:57:31 -0700
From: Greg KH <greg@kroah.com>
To: Eric Valette <eric.valette@free.fr>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org,
       Larry Finger <Larry.Finger@lwfinger.net>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [RFT] rtl8187: use DMA-aware buffers with usb_control_msg
Message-ID: <20090509135731.GD17349@kroah.com>
References: <20090506064513.GA7460@kroah.com> <1241632963-25601-1-git-send-email-linville@tuxdriver.com> <3ace41890905081620h10d0250eq1ede9cd73021dc5b@mail.gmail.com> <4A054F18.7020501@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A054F18.7020501@free.fr>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 11:38:32AM +0200, Eric Valette wrote:
> The patch fix the DMA warning and the driver seems to work (just
> associated it) but I must say that the allocation failure handling path
> and the fact that we use now kmalloc for allocating a few bytes in such
> a routine makes me worry about possible negative performance impact
> unless theses routines are used only in a slow configuration path (did
> no took time to red the code due to many other problems).

usb_control messages are slow and should not be on the "fast path" of
any data being sent through the device.  Any overhead of the
kmalloc/kfree is totally eaten up by the actual transmission turn around
time of the message itself, so you don't have to worry about the
performance impact.

thanks for testing.

> BTW if someone know who I should send this attached patch for DRM git, I
> would gladly forward it.

To the drm maintainer?

thanks,

greg k-h
