Return-Path: <linux-kernel-owner+w=401wt.eu-S1762125AbZATXiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762125AbZATXiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 18:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756792AbZATXh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 18:37:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:65163 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577AbZATXh4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 18:37:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] usb/mcs7830: Don't use buffers from stack for USB transfers
Date: Wed, 21 Jan 2009 00:37:51 +0100
User-Agent: KMail/1.9.9
Cc: ceggers@gmx.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <200901202345.47792.arnd@arndb.de> <200901210017.19038.arnd@arndb.de> <20090120.152345.78877396.davem@davemloft.net>
In-Reply-To: <20090120.152345.78877396.davem@davemloft.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901210037.51622.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+QFSNUd/nFaIyYsWSxxfFpVKmXzVycwqO6zCY
 CP4tPRc4auA1vnG/jeIhY6IqC1aq8aRnMwSHD/gY0MagqzTvou
 jG0L90laXLSiYSYt3sNfw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 January 2009, David Miller wrote:
> There seems to be a large precendence for this in other USB drivers,
> both for networking and storage.  Probably a mutex or other locking
> hierarchy issue.
> 
> Really, I would just apply this patch as-is.  It works, it's pretty
> clean, and every retort has been a misunderstanding or extreme
> nit-picking :-)

Ok, fair enough. Please add my Acked-by then.

On a related topic, can we put something in place that can check for
this error at run-time, like a WARN_ON(is_kernel_stack(addr)) in
dma_map_single?
Since I only copied this code from elsewhere, I would suspect that
there are lots of similar bugs that never get found on common hardware
otherwise.

	Arnd <><
