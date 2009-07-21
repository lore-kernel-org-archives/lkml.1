Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbZGUAA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbZGUAA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 20:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612AbZGUAAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 20:00:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:58905 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbZGUAAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 20:00:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: virtualization@lists.linux-foundation.org
Subject: Re: [patch 27/54] Staging: hv: remove ULONG and LONG typedefs
Date: Tue, 21 Jul 2009 02:00:16 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, virtualization@lists.osdl.org,
       Greg KH <greg@kroah.com>, Sam Ramji <sramji@microsoft.com>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Hank Janssen <hjanssen@microsoft.com>, shemminger@linux-foundation.org
References: <20090717180850.873962925@mini.kroah.org> <20090717180920.285605541@mini.kroah.org>
In-Reply-To: <20090717180920.285605541@mini.kroah.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907210200.16295.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+TB11xN6fCeJ8HMfvr+rLBAh73X2PZZkBwtM3
 Fzlg4NOPToV3I9JSRiF+FcLwKJHix3PIA996vbSSAHQJuaDw2A
 G47nxEIbQ4ce/S6emn/yQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 July 2009, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@suse.de>
> 
> The ULONG and LONG typedefs are now removed from the Hyper-V driver
> code
> 

This conversion is not equivalent:

>  //
> -// unsigned types
> -//
> -typedef unsigned int		ULONG;
> -
> -//
> -// signed types
> -//
> -typedef int					LONG;

- // redefine the world, because we can
- extern char *i;
- void abs(unsigned u);
- #define FALSE (2)

;-)

> --- a/drivers/staging/hv/include/StorVscApi.h
> +++ b/drivers/staging/hv/include/StorVscApi.h
> @@ -117,7 +117,7 @@ typedef struct _STORVSC_DRIVER_OBJECT {
>  } STORVSC_DRIVER_OBJECT;
>  
>  typedef struct _STORVSC_DEVICE_INFO {
> -	ULONG	PortNumber;
> +	unsigned long	PortNumber;
>      unsigned char	PathId;
>      unsigned char	TargetId;
>  } STORVSC_DEVICE_INFO;

If this is an API (as the header file name suggests), you just changed it.
Same for the other hunks in this patch.

	Arnd <><
