Return-Path: <linux-kernel-owner+w=401wt.eu-S1759835AbZFWQRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835AbZFWQRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZFWQRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:17:42 -0400
Received: from kroah.org ([198.145.64.141]:34982 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014AbZFWQRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:17:41 -0400
Date: Tue, 23 Jun 2009 09:13:34 -0700
From: Greg KH <greg@kroah.com>
To: Frans Pop <elendil@planet.nl>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.31-rc0-git: lsusb stopped working?
Message-ID: <20090623161334.GA503@kroah.com>
References: <20090623135529.GA2668@elf.ucw.cz> <200906231709.45851.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906231709.45851.elendil@planet.nl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 05:09:44PM +0200, Frans Pop wrote:
> Pavel Machek wrote:
> > On thinkpad x60. Otherwise usb seems to work, including btusb dongle.
> > 
> > /proc/bus/usb does not seem to exists.
> 
> Correct. usbfs has been removed in 2.6.31.

To be pedantic, no, the filesystem has not been "removed".  Only the
user-mountable filesystem option has been moved under CONFIG_EMBEDDED,
as there should not be any userspace code that still uses that interface
into usbfs.

The recommended solution is to use the device nodes for usbfs, which
have been around for a few years now, and usually show up under
/dev/bus/usb/ and have the proper ACL and permissions that the
filesystem nodes can't have for a variety of reasons.

If for some reason you can not use the /dev/bus/usb/ device nodes, you
can enable the config option by turning on CONFIG_EMBEDDED.

Hope this helps,

greg k-h
