Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbYHHN0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbYHHN0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 09:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbYHHN0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 09:26:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56169 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbYHHN0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 09:26:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Carl Love <cel@us.ibm.com>
Subject: Re: [PATCH 2/2] Cell OProfile: SPU mutex lock fix, version 4
Date: Fri, 8 Aug 2008 15:26:20 +0200
User-Agent: KMail/1.9.9
Cc: linuxppc-dev@ozlabs.org, cel <cel@linux.vnet.ibm.com>,
       cbe-oss-dev@ozlabs.org, linux-kernel <linux-kernel@vger.kernel.org>
References: <1217620879.15667.145.camel@carll-linux-desktop>
In-Reply-To: <1217620879.15667.145.camel@carll-linux-desktop>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808081526.21405.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19Sd8p1eDyVWJRlDqDFoBC/Oxw1txa16tBNPyX
 PZR59EczQRxPiqnQu6rbE/5r0v6F9YGIkTjovtxECnMpOKKmVf
 nuEjLKwH1HvO0a1NWsKBg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 August 2008, Carl Love wrote:
> If an error occurs on opcontrol start, the event and per cpu buffers 
> are released.  If later opcontrol shutdown is called then the free
> function will be called again to free buffers that no longer 
> exist.  This results in a kernel oops.  The following changes
> prevent the call to delete buffers that don't exist.
> 
> Signed-off-by: Carl Love <carll@us.ibm.com>
> 

vfree(NULL) is defined to be legal, so you don't need to check the
argument for being non-NULL, just set it to NULL after the free.

	Arnd <><
