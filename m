Return-Path: <linux-kernel-owner+w=401wt.eu-S1751855AbZGUAuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbZGUAuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 20:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbZGUAuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 20:50:23 -0400
Received: from smtp.microsoft.com ([131.107.115.212]:52084 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZGUAuW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 20:50:22 -0400
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jul 2009 20:50:22 EDT
From: Hank Janssen <hjanssen@microsoft.com>
To: Arnd Bergmann <arnd@arndb.de>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <greg@kroah.com>, Sam Ramji <sramji@microsoft.com>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       "shemminger@linux-foundation.org" <shemminger@linux-foundation.org>
Subject: RE: [patch 27/54] Staging: hv: remove ULONG and LONG typedefs
Thread-Topic: [patch 27/54] Staging: hv: remove ULONG and LONG typedefs
Thread-Index: AQHKCVPQj6mhFmQrk02S/bcT1owjx5B/jyUA//+WyWA=
Date: Tue, 21 Jul 2009 00:44:55 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56209A3A56B@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <20090717180850.873962925@mini.kroah.org>
 <20090717180920.285605541@mini.kroah.org> <200907210200.16295.arnd@arndb.de>
In-Reply-To: <200907210200.16295.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Arnd,

Thanks for this and the other mails reviewing the code.

My TODO list keeps on getting bigger :). I will check into all of these and correct them.

Keep them coming!

Thanks!

Hank.


-----Original Message-----
From: Arnd Bergmann [mailto:arnd@arndb.de]
Sent: Monday, July 20, 2009 5:00 PM
To: virtualization@lists.linux-foundation.org
Cc: Greg Kroah-Hartman; linux-kernel@vger.kernel.org; devel@driverdev.osuosl.org; virtualization@lists.osdl.org; Greg KH; Sam Ramji; Haiyang Zhang; Hank Janssen; shemminger@linux-foundation.org
Subject: Re: [patch 27/54] Staging: hv: remove ULONG and LONG typedefs

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
> -typedef unsigned int         ULONG;
> -
> -//
> -// signed types
> -//
> -typedef int                                  LONG;

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
> -     ULONG   PortNumber;
> +     unsigned long   PortNumber;
>      unsigned char    PathId;
>      unsigned char    TargetId;
>  } STORVSC_DEVICE_INFO;

If this is an API (as the header file name suggests), you just changed it.
Same for the other hunks in this patch.

        Arnd <><

