Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbXKAQUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbXKAQUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 12:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbXKAQT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 12:19:57 -0400
Received: from smtp106.biz.mail.mud.yahoo.com ([68.142.200.254]:42481 "HELO
	smtp106.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752810AbXKAQT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 12:19:56 -0400
X-YMail-OSG: 6b1tJMcVM1k9Idl2cERfa4yAO3A8NAV6EPEIWFnUIy6TTWDIyTfUkO04M4ORXY2k_Oxu56ftcg--
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc.com
To: linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] ti_usb_3410_5052 breakage in 2.6.24-rc1
Date: Thu, 1 Nov 2007 09:19:52 -0700
User-Agent: KMail/1.9.7
References: <Pine.LNX.4.44L0.0711011044400.4146-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0711011044400.4146-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711010919.53057.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 November 2007 7:47:24 Alan Stern wrote:
> On Wed, 31 Oct 2007, Steven King wrote:
> >   My TI eZ430 (MSP-FET430UIF JTAG Tool) usb dongle works fine with
> > 2.6.23.1 and earlier, but doesn't work with 2.6.24-rc1; the
> > ti_usb_3410_5052 module is loaded but the device descriptor is bogus,
> > reporting only a single configuration, whereas in 2.6.23.1 it reports 2
> > configurations, allowing one to select the second configuration to get a
> > serial port.
> >
> > git bisect fingered this commit:
> >
> > 063a2da8f01806906f7d7b1a1424b9afddebc443 "USB: serial core should respect
> > driver requirements"
>
> Are you certain about this?  That commit could not possibly have
> changed the way the USB core evaluates the device or configuration
> descriptors.  In fact, the commit affects only code in the usb-serial
> driver, which doesn't get loaded until well after the descriptors have
> been parsed.


 100% certain.  After bisecting it, I reversed that commit on an otherwise 
stock -rc1 and the device started working again.

-- 
Steven King -- sfking at fdwdc dot com
