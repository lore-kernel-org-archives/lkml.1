Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbZEIQjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbZEIQjV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbZEIQjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:39:04 -0400
Received: from kroah.org ([198.145.64.141]:41998 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbZEIQjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:39:03 -0400
Date: Sat, 9 May 2009 09:35:23 -0700
From: Greg KH <greg@kroah.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Eric Valette <eric.valette@free.fr>,
       Hin-Tak Leung <hintak.leung@gmail.com>, linux-wireless@vger.kernel.org,
       Larry Finger <Larry.Finger@lwfinger.net>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [RFT] rtl8187: use DMA-aware buffers with usb_control_msg
Message-ID: <20090509163523.GA1200@kroah.com>
References: <20090506064513.GA7460@kroah.com> <1241632963-25601-1-git-send-email-linville@tuxdriver.com> <3ace41890905081620h10d0250eq1ede9cd73021dc5b@mail.gmail.com> <4A054F18.7020501@free.fr> <20090509135731.GD17349@kroah.com> <20090509155013.GA21763@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509155013.GA21763@tuxdriver.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 11:50:14AM -0400, John W. Linville wrote:
> > usb_control messages are slow and should not be on the "fast path" of
> > any data being sent through the device.  Any overhead of the
> > kmalloc/kfree is totally eaten up by the actual transmission turn around
> > time of the message itself, so you don't have to worry about the
> > performance impact.
> 
> Yeah, I don't like the original version either.  Even if the kmalloc's
> aren't a big performance hit, the failure path sucks.  I've included a
> new version below, but unfortunately I haven't had a chance to test it.
> Please give it a try if you get a chance?

Looks good to me, a bit cleaner even.

thanks,

greg k-h
