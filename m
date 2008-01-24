Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbYAXNOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbYAXNOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 08:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbYAXNOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 08:14:11 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:6007 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbYAXNOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 08:14:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ScYaYM+p22IKdLHJqOvOUSD2V3a0A5yikHB3U0kCzjRDf06NmPzgxCpLjE6uwEGGTGlLY+NwK8M+D9fV27/gm6U0eUuqDoHhzCbuCHVYl3WR+WyooBUrffHfianNqV5L2uEk/sc70yoHru6FepGLd6Zi2LQ4QUPs+xu4lM7dhYw=
Message-ID: <84144f020801240514m135789d4nc14586598f8b4aca@mail.gmail.com>
Date: Thu, 24 Jan 2008 15:14:09 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: [PATCH] Missing usb_find_device symbol from usb.c
Cc: "Wilco Beekhuizen" <wilcobeekhuizen@gmail.com>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200801241358.51496.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com>
	 <200801241324.26868.oliver@neukum.org>
	 <84144f020801240434s3ce63e58m8ffb74d70c0aef32@mail.gmail.com>
	 <200801241358.51496.oliver@neukum.org>
X-Google-Sender-Auth: 609fdf0f7855e8a8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Jan 24, 2008 2:58 PM, Oliver Neukum <oliver@neukum.org> wrote:
> So we put it into drivers/usb/misc
> Does that change the code?

Yes. It's assumes only one device is plugged in.

On Jan 24, 2008 2:58 PM, Oliver Neukum <oliver@neukum.org> wrote:
> How do you make a block device on top of this device? It has no notion
> of reading/writing arbitrary blocks. It operates on files.

So you don't make it a block device which is even simpler. Now
get_sb_bdev() will fail before attempting to read the superblock. In
iriverfs, we only need to check for USB_DEVICE_MAJOR and then look up
struct usb_device to make sure we're allowed to mount.

                        Pekka
