Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbZBDIL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbZBDIL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 03:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbZBDILr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 03:11:47 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:43485 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZBDILq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 03:11:46 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] usb-serial : fix the nousb oops
Date: Wed, 4 Feb 2009 09:12:39 +0100
User-Agent: KMail/1.9.10
Cc: Dave Young <hidave.darkstar@gmail.com>, wgreathouse@smva.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <49857F23.3090208@gmail.com> <a8e1da0902011743o47764edfjf53a397b5a4aeeef@mail.gmail.com> <20090203235814.GA22380@kroah.com>
In-Reply-To: <20090203235814.GA22380@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902040912.40521.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wednesday 04 February 2009 00:58:14 schrieb Greg KH:
> On Mon, Feb 02, 2009 at 09:43:04AM +0800, Dave Young wrote:
 
> > No, it is not new thing.  usb serial drivers normally call
> > usb_serial_register first, then usb_register, usb_register will fail
> > due to "nousb" checking, but usb_serial_register no.
> 
> But as usb_register will fail, shouldn't they properly back out and no
> oopses happen?  This sounds like a simple fix to the drivers that are
> failing here, not changing the usb-serial core.

usb_register() can also fail for other reasons. There's no way you
can save drivers from needing to cleanly fail in that case.

> And this should only be an issue if you build your drivers into the
> kernel, right?

No, you can load drivers by other methods than udev.

	Regards
		Oliver
