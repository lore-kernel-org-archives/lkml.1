Return-Path: <linux-kernel-owner+w=401wt.eu-S1760743AbZATWuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760743AbZATWuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 17:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756581AbZATWt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 17:49:57 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:55130 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbZATWt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 17:49:57 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] usb/mcs7830: Don't use buffers from stack for USB transfers
Date: Tue, 20 Jan 2009 23:50:21 +0100
User-Agent: KMail/1.9.10
Cc: "Christian Eggers" <ceggers@gmx.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>
References: <34115.192.168.0.40.1232483361.squirrel@server> <200901202345.47792.arnd@arndb.de>
In-Reply-To: <200901202345.47792.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901202350.23231.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Tuesday 20 January 2009 23:45:47 schrieb Arnd Bergmann:
> Have you observed problems with this, or just suspected trouble?
> 
> When I wrote this code, I looked at other code doing the same
> and assumed it was ok, because usb_control_msg waits for the
> DMA to complete before returning.
> 
> Is the problem only on systems that have noncoherent DMA, or
> something else?

That's not enough. Tasks can leave pointers to variables on the
stack to other tasks. You must under no circumstances do DMA
on the stack if the driver may run on system that have noncoherent
DMA.

	Regards
		Oliver

