Return-Path: <linux-kernel-owner+w=401wt.eu-S932927AbYETSq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927AbYETSq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933084AbYETSqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:46:01 -0400
Received: from rn-out-0910.google.com ([64.233.170.191]:17568 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933045AbYETSqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:46:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mo/T1wCDomip/7xj53tTobqfBp+Axv0hKzk8/vomdUt73oC3g92gOltIDzyVPRO5mi7CI8Ca6VX41QfxeFI/2Sr1yPRPwcs+qusXzgBaqRPRcThWbZrjtG9yOTPxMxaxp+RBnalDcdUn66+pIwHBVl0lg22am+PgPu2oWJsJAcs=
Subject: Re: [PATCH 05/21] drivers/usb: use aligned-endian get/put helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1211306772.5915.173.camel@brick>
References: <1211306772.5915.173.camel@brick>
Content-Type: text/plain
Date: Tue, 20 May 2008 11:45:53 -0700
Message-Id: <1211309154.5915.189.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-20 at 11:06 -0700, Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---

After all that I compiled with the wrong config to make sure
it all compiled after splitting, extra bracket in devio.c

>  drivers/usb/c67x00/c67x00-hcd.c |    4 ++--
>  drivers/usb/core/devio.c        |   12 ++++++------
>  drivers/usb/gadget/net2280.c    |    2 +-
>  drivers/usb/host/ehci.h         |    6 ++----
>  drivers/usb/host/isp116x-hcd.c  |    4 ++--
>  drivers/usb/host/ohci.h         |   16 ++++++----------
>  drivers/usb/host/uhci-hub.c     |    6 +++---
>  drivers/usb/misc/auerswald.c    |    2 +-
>  drivers/usb/serial/garmin_gps.c |    9 ++++-----
>  drivers/usb/storage/isd200.c    |    4 ++--
>  10 files changed, 29 insertions(+), 36 deletions(-)
>  
> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index de17738..b44a061 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -993,18 +993,18 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
>  			kfree(dr);
>  			return -EFAULT;
>  		}
> -		if (uurb->buffer_length < (le16_to_cpup(&dr->wLength) + 8)) {
> +		if (uurb->buffer_length < get_le16(&dr->wLength) + 8)) {
								      ^
Sorry.

Harvey

