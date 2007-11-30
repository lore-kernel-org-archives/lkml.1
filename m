Return-Path: <linux-kernel-owner+w=401wt.eu-S1764271AbXK3Ehn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764271AbXK3Ehn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 23:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756775AbXK3Eha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 23:37:30 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:30959 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbXK3Eh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 23:37:29 -0500
Message-ID: <1618816c0711292037w34bd383av6cf32bfbd8d45707@mail.gmail.com>
Date: Thu, 29 Nov 2007 21:37:28 -0700
From: "Raymano Garibaldi" <raymano@faunos.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] [BUG] USB_PERSIST
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Denys Vlasenko" <vda.linux@googlemail.com>,
       "Kernel development list" <linux-kernel@vger.kernel.org>,
       "USB development list" <linux-usb-devel@lists.sourceforge.net>,
       kirk@faunos.com
In-Reply-To: <Pine.LNX.4.44L0.0711291102290.4516-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1618816c0711290353h3c0e4192we5909725d1aff3e9@mail.gmail.com>
	 <Pine.LNX.4.44L0.0711291102290.4516-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/07, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 29 Nov 2007, Raymano Garibaldi wrote:
>
> > The feature does work as long as the device remains plugged in and
> > that is what I have said in my previous postings too. What I'm saying
> > that should work and worked under 2.6.21 and is not working currently
> > is the ability to unplug and plug back in the device while the
> > computer is suspended before resuming without losing the mount.
>
> Okay, guess I misunderstood what you wrote before.
>
> The patch below for 2.6.23 should do what you want (and more besides).
> It forces the USB Persist feature to apply to all persist-enabled
> devices, whether they were unplugged or not.
>
> There's no chance of this getting accepted into the official kernel in
> such a simple form, but at least it will allow you to do what you want.
>
> Alan Stern
>
>
> --- 2.6.23/drivers/usb/core/driver.c1   2007-11-29 10:57:36.000000000 -0500
> +++ 2.6.23/drivers/usb/core/driver.c    2007-11-29 11:01:44.000000000 -0500
> @@ -1550,6 +1550,9 @@
>                 if (!(udev->reset_resume && udev->do_remote_wakeup))
>                         return -EPERM;
>         }
> +
> +       /* Force all system resumes to be reset-resumes */
> +       udev->reset_resume = 1;
>         return usb_external_resume_device(udev);
>  }
>
>
>

Alan,

Thank you! Thank you! Thank you!

Who'd have thought such a simple patch could make someone so happy?

That did the trick. I just tried it and it works beautifully whether
the device remains plugged in during suspend or if it's unplugged and
plugged back in during suspend and before resume.

Now if this could only become the default behavior ;-)

Thanks again,
Raymano G.
