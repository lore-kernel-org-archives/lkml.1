Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbXFVVUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbXFVVUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbXFVVU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:20:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:55084 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbXFVVU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:20:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=btXyRr0AY3Gs174wu5NyRSMg1YST0xMkuPk+a9E7tXJAPO+C0NYnooQVgm5lJI9Y0PqyZRerl/wK+yBg3l+GTQTN6Qkjbk7y1QY0aF4rEzKJJspu1FolS3xLqYYUmJMF+QWkz7JtUwB4blc47CsQWU8iH9uM22VQG3inCXVgH5k=
Message-ID: <a781481a0706221420u6935e75er1ee5601e013b40d2@mail.gmail.com>
Date: Sat, 23 Jun 2007 02:50:25 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Trent Piepho" <xyzzy@speakeasy.org>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re: [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in zc0301_core.c
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Linux and Kernel Video" <video4linux-list@redhat.com>,
       linux-usb-devel@lists.sourceforge.net, toralf.foerster@gmx.de,
       "Oliver Neukum" <oneukum@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Luca Risolia" <luca.risolia@studio.unibo.it>
In-Reply-To: <Pine.LNX.4.58.0706221259500.4914@shell4.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706211117.55908.toralf.foerster@gmx.de>
	 <200706211231.53898.luca.risolia@studio.unibo.it>
	 <200706211326.45031.toralf.foerster@gmx.de>
	 <200706211350.14526.oneukum@suse.de>
	 <1182518566.14289.20.camel@gaivota>
	 <Pine.LNX.4.58.0706221259500.4914@shell4.speakeasy.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trent,

On 6/23/07, Trent Piepho <xyzzy@speakeasy.org> wrote:
> [...]
> What you have is tristate depends on bool depends on tristate.  The bool
> between the two tristates "promotes" the first tristate from m to y.
> [...]
> Or another way, add the dependencies of the menuconfig to the if statement:
> diff -r dfbe7cc4e21e drivers/media/video/Kconfig
> --- a/drivers/media/video/Kconfig       Thu Jun 21 16:02:50 2007 -0700
> +++ b/drivers/media/video/Kconfig       Fri Jun 22 13:10:43 2007 -0700
> @@ -691,7 +691,7 @@ menuconfig V4L_USB_DRIVERS
>         depends on USB
>         default y
>
> -if V4L_USB_DRIVERS
> +if V4L_USB_DRIVERS && USB
>
>  source "drivers/media/video/pvrusb2/Kconfig"
>
> Now all the usb drivers will gain USB as a dependency directly and can't be
> set to something higher than USB.

Ok, so we add this as solution 2.(c) to the reply I just sent to Jan :-)

But I still prefer 2.(b) -- making the config scripts intelligent so that if a
given "menuconfig FOO depends on BAR", then all the "config BAZ"s
inside this menuconfig also automatically "depend on" BAR too.
This is simpler in the long run because it requires least amount
(actually none) of redundant typing and would continue to work in
the future if/when the:

menuconfig FOO
if FOO
...
endif # FOO

idiom is converted to an:

configmenu FOO
...
endconfigmenu # FOO

kind of idiom ...

Satyam
