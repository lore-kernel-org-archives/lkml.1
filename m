Return-Path: <linux-kernel-owner+w=401wt.eu-S1760918AbZATWqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918AbZATWqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 17:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbZATWp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 17:45:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:54356 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551AbZATWpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 17:45:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Christian Eggers" <ceggers@gmx.de>
Subject: Re: [PATCH] usb/mcs7830: Don't use buffers from stack for USB transfers
Date: Tue, 20 Jan 2009 23:45:47 +0100
User-Agent: KMail/1.9.9
References: <34115.192.168.0.40.1232483361.squirrel@server>
In-Reply-To: <34115.192.168.0.40.1232483361.squirrel@server>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901202345.47792.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+W/cVvYai8jkpOP7iU+k8gJgmZDmkANpa3LLT
 FVmXFhjrYMxMKcE3I2yYo8Uef1JLBUDDUzeIDMoDDLNOZyprea
 sJ9Or8oKOpVV7ZcAHSvQw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 January 2009, you wrote:
> From: Christian Eggers <christian.eggers@kathrein.de>
> 
> mcs7830_set_reg() and mcs7830_get_reg() are called with buffers
> from stack which must not be used directly for USB transfers.
> This causes corruption of the stack particulary on non x86
> architectures because DMA may be used for these transfers.
> 
> Signed-off-by: Christian Eggers <christian.eggers@kathrein.de>

Have you observed problems with this, or just suspected trouble?

When I wrote this code, I looked at other code doing the same
and assumed it was ok, because usb_control_msg waits for the
DMA to complete before returning.

Is the problem only on systems that have noncoherent DMA, or
something else?

> This is my first patch submission for Linux. I hope everything is fine.

I was about to say that you should have Cc:'d me, but then I noticed
that I'm not listed in the driver as maintainer, nor in the MAINTAINERS
file, so I can't really complain here ;-)

	Arnd <><
