Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656Ab0AGTIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab0AGTIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184Ab0AGTIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:08:47 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:44586 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab0AGTIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:08:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=glseQfgvrbo3JXcMRiU9bN9LWWQ1BXWHxdlQyP4WGeFFdq8QddcsZaaGLRD0lhmKCI
         +Xev9JprXTETiELSXTxnqT5zAom9s9J+XQulmlVH7/k9z7fy7ToIBZeqN2Y5MsFvV6f6
         lC9i6tpjZb+IPKFjohVzZKTDP8qWYkTz6oShw=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bastian Blank <waldi@debian.org>
Subject: Re: [PATCH 7/7] Input: wacom - Fail on missing features
Date: Thu, 7 Jan 2010 11:08:38 -0800
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc3; KDE/4.3.4; x86_64; ; )
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ping Cheng <pingc@wacom.com>
References: <20100107182553.GA11236@wavehammer.waldi.eu.org> <20100107183009.GA13036@wavehammer.waldi.eu.org>
In-Reply-To: <20100107183009.GA13036@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001071108.38253.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 January 2010 10:30:09 am Bastian Blank wrote:
> The driver needs a correct setup feature list, fail if it is not
> correctly set.
> 
> Signed-off-by: Bastian Blank <waldi@debian.org>
> ---
>  drivers/input/tablet/wacom_sys.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/tablet/wacom_sys.c
>  b/drivers/input/tablet/wacom_sys.c index 41a631b..c44b9f0 100644
> --- a/drivers/input/tablet/wacom_sys.c
> +++ b/drivers/input/tablet/wacom_sys.c
> @@ -534,6 +534,9 @@ static int wacom_probe(struct usb_interface *intf,
>  const struct usb_device_id *i struct input_dev *input_dev;
>  	int error = -ENOMEM;
> 
> +	if (!features)
> +		return -EIO;
> +

-EINVAL is probably better.

>  	wacom = kzalloc(sizeof(struct wacom), GFP_KERNEL);
>  	wacom_wac = kzalloc(sizeof(struct wacom_wac), GFP_KERNEL);
>  	input_dev = input_allocate_device();
> 

-- 
Dmitry
