Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbYAXRma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbYAXRma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYAXRmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 12:42:22 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:35620 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbYAXRmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 12:42:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jkVL/7b/4bCLcVyiK+WiGX3chUOTQr8r3ZjcB/E58PdgOvKsHaj/7os6U3onkkJNcvG7nsuVK13m2FydehYAJL2iDD23aEH0mcPVgOL3l3E31vIWRrUTbyVVDzjjJHuLazFs7Oy0PmAqH5I0XwmeHPQSlhMcXMUJRJa5IFwQ8Xw=
Message-ID: <84144f020801240942y1c75c82geddc250b7e7814ac@mail.gmail.com>
Date: Thu, 24 Jan 2008 19:42:20 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] Missing usb_find_device symbol from usb.c
Cc: "Wilco Beekhuizen" <wilcobeekhuizen@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080124172049.GA9665@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com>
	 <20080124013720.GA21978@kroah.com>
	 <6c4c86470801240205u5361e090jc057270b03b5ebe7@mail.gmail.com>
	 <84144f020801240319o1f51613fx6e823120f74a9cf9@mail.gmail.com>
	 <20080124164418.GA8226@kroah.com>
	 <84144f020801240906l7e018a95wfd4ad7736851dd63@mail.gmail.com>
	 <20080124172049.GA9665@kroah.com>
X-Google-Sender-Auth: 98355e8834a8e65c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Jan 24, 2008 7:20 PM, Greg KH <greg@kroah.com> wrote:
> > So it's not a simple code change at all.
>
> Just create a root directory for every device that is seen in the
> probe() function.  That should be pretty simple to do.

Yeah, that would work but why do we want to mount all devices under
the same mount point? If you move device discovery to ->probe() it's
simple to have per-device mount points by overriding ->get_sb() to
check for USB_DEVICE_MAJOR and look up the actual device, no?
Otherwise you have to deal with device plug/unplug at filesystem
level...

                        Pekka
