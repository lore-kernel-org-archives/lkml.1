Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab0BBO3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 09:29:38 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:60129 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab0BBO3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 09:29:37 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH] dvb: return -ENOMEM if kzalloc failed in dvb_usb_device_init()
Date: Tue, 2 Feb 2010 15:29:36 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <4B6836DA.8030907@gmail.com>
In-Reply-To: <4B6836DA.8030907@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002021529.36727.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 2. Februar 2010 15:29:46 schrieb Roel Kluin:
> If in a cold state and the download succeeded ret is zero, but we
> should return -ENOMEM.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Or shouldn't we?

We should and we do if cold==0.
The bug is caused by this:

	if (cold) {
		info("found a '%s' in cold state, will try to load a firmware",desc->name);
		ret = dvb_usb_download_firmware(udev,props);
		if (!props->no_reconnect || ret != 0)
			return ret;
	}

which overwrites ret

	Regards
		Oliver
