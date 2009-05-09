Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbZEIVY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbZEIVY7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 17:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbZEIVYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 17:24:48 -0400
Received: from fmailhost03.isp.att.net ([207.115.11.53]:64404 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZEIVYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 17:24:47 -0400
X-Originating-IP: [71.195.50.4]
Message-ID: <4A05F485.4080303@lwfinger.net>
Date: Sat, 09 May 2009 16:24:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Greg KH <greg@kroah.com>, Eric Valette <eric.valette@free.fr>,
       Hin-Tak Leung <hintak.leung@gmail.com>, linux-wireless@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [RFT] rtl8187: use DMA-aware buffers with usb_control_msg
References: <20090506064513.GA7460@kroah.com> <1241632963-25601-1-git-send-email-linville@tuxdriver.com> <3ace41890905081620h10d0250eq1ede9cd73021dc5b@mail.gmail.com> <4A054F18.7020501@free.fr> <20090509135731.GD17349@kroah.com> <20090509155013.GA21763@tuxdriver.com>
In-Reply-To: <20090509155013.GA21763@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John W. Linville wrote:
> 
> Yeah, I don't like the original version either.  Even if the kmalloc's
> aren't a big performance hit, the failure path sucks.  I've included a
> new version below, but unfortunately I haven't had a chance to test it.
> Please give it a try if you get a chance?

This one tests just fine here running on the latest pull of wireless testing
(v2.6.30-rc4-22732-gd879ac6). I think there is a leak of priv->io_dmabuf when
the driver is unloaded, and kfree(priv->io_dmabuf) should be added to
rtl8187_disconnect(). Otherwise ACK.

Larry

