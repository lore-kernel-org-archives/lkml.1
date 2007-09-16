Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbXIPWPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbXIPWPY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 18:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbXIPWPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 18:15:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60316 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753074AbXIPWPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 18:15:10 -0400
Date: Sun, 16 Sep 2007 15:14:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <kees@ubuntu.com>
Cc: Greg KH <greg@kroah.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Ben Collins <bcollins@ubuntu.com>, Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] modpost: detect unterminated device id lists
Message-Id: <20070916151447.dc925a9e.akpm@linux-foundation.org>
In-Reply-To: <20070913004937.GM8183@outflux.net>
References: <20070912064134.GO7910@outflux.net>
	<46E7C91D.3070001@garzik.org>
	<b6fcc0a0709120448s69528fc9reed593229124a4fa@mail.gmail.com>
	<20070912215356.GC23294@kroah.com>
	<20070913004937.GM8183@outflux.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007 17:49:37 -0700 Kees Cook <kees@ubuntu.com> wrote:

> This patch against 2.6.23-rc6 will cause modpost to fail if any device
> id lists are incorrectly terminated, after reporting the offender.

I'm getting this:

rusb2/pvrusb2: struct usb_device_id is 20 bytes.  The last of 3 is:
0x03 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 
FATAL: drivers/media/video/pvrusb2/pvrusb2: struct usb_device_id is not terminated with a NULL entry!

("rusb2/pvrusb2" ??)

but:

struct usb_device_id pvr2_device_table[] = {
	[PVR2_HDW_TYPE_29XXX] = { USB_DEVICE(0x2040, 0x2900) },
	[PVR2_HDW_TYPE_24XXX] = { USB_DEVICE(0x2040, 0x2400) },
	{ USB_DEVICE(0, 0) },
};
	
looks OK?

Using plain old "{ }" shut the warning up.
