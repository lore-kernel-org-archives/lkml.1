Return-Path: <linux-kernel-owner+w=401wt.eu-S1762048AbZATXge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762048AbZATXge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 18:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756577AbZATXgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 18:36:22 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:59012 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540AbZATXgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 18:36:21 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] usb/mcs7830: Don't use buffers from stack for USB transfers
Date: Wed, 21 Jan 2009 00:36:49 +0100
User-Agent: KMail/1.9.10
Cc: arnd@arndb.de, ceggers@gmx.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
References: <200901202345.47792.arnd@arndb.de> <200901210017.19038.arnd@arndb.de> <20090120.152345.78877396.davem@davemloft.net>
In-Reply-To: <20090120.152345.78877396.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901210036.51681.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wednesday 21 January 2009 00:23:45 schrieb David Miller:
> > GFP_NOIO seems out of place in a network driver: there is nothing
> > wrong with waiting for I/O here, so plain GFP_KERNEL should be fine.
> 
> There seems to be a large precendence for this in other USB drivers,
> both for networking and storage.  Probably a mutex or other locking
> hierarchy issue.

Usb storage uses a lot of infrastructure in error handling. As a storage
interface and another interface can share a device and be reset only
together. All drivers' reset handling must be written as if they were
block devices. Therefore you see a lot of GFP_NOIO in USB.

	Regards
		Oliver

