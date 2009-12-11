Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbZLKFh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbZLKFh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbZLKFhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:37:25 -0500
Received: from smtp.nokia.com ([192.100.122.230]:23522 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbZLKFhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:37:24 -0500
Subject: Re: [PATCH 3/3] gpiolib: use chip->names for symlinks, always use
 gpioN for device names
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Greg KH <gregkh@suse.de>
Cc: David Brownell <david-b@pacbell.net>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>,
       dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       dsilvers@simtec.co.uk, ben@simtec.co.uk, akpm@linux-foundation.org
In-Reply-To: <20091211043849.GA18007@suse.de>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com>
	 <200912101939.30446.david-b@pacbell.net> <20091211034711.GA2773@suse.de>
	 <200912102013.59329.david-b@pacbell.net>  <20091211043849.GA18007@suse.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Fri, 11 Dec 2009 07:36:11 +0200
Message-Id: <1260509771.12346.138.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 11 Dec 2009 05:36:14.0186 (UTC) FILETIME=[DA81BCA0:01CA7A23]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-10 at 20:38 -0800, Greg KH wrote:
> On Thu, Dec 10, 2009 at 08:13:58PM -0800, David Brownell wrote:
> > On Thursday 10 December 2009, Greg KH wrote:
> > > 
> > > > IMO a "good" solution in this space needs to accept that
> > > > those names are not going to be globally unique ... but
> > > > that they'll be unique within some context, of necessity.
> > > > 
> > > > If Greg doesn't want to see those names under classes,
> > > > so be it ... but where should they then appear?
> > > 
> > > As a sysfs file within the device directory called 'name'? ?Then just
> > > grep through the tree to find the right device, that also handles
> > > duplicates just fine, right?
> > 
> > I want a concrete example.  Those chip->names things don't
> > seem helpful to me though...
> > 
> > If for example I were building a JTAG adapter on Linux, it
> > might consist of a spidev node (chardev) plus a handful of
> > GPIOs.  So "the device directory" would be the sysfs home
> > of that spidev node (or some variant)?  And inside that
> > directory would be files named after various signals that
> > are used as GPIOs ... maybe SRST, TRST, and DETECT to start
> > with?  Holding some cookie that gets mapped to those GPIO's
> > sysfs entries?
> 
> Um, I really don't know, as I don't know the GPIO subsystem, nor why you
> all have this problem in the first place :)
> 
> I also find it funny that you think changing the kernel is easier than
> userspace, that's a strange situation.

User-space does not know which GPIO number is what. E.g., is the
"power_button" GPIO number 6 or 99? It just does not have this
information.

Kernel knows this, either because it was compiled for a specific board
revision, or it got this information from the bootloader.

And the whole idea is to make kernel export this name. Currently, the
kernel exports only the numbers in sysfs, which is not enough.

And because gpiolib is designed as it is designed, we found that having
additional link in /sys/class/gpio is the nicest solution from gpiolib's
POW. It just fits naturally to the existing design.

And no, we do not have per-gpio struct device, so we cannot add a new
"name" attribute there. We need to either persuade you to accept our
solution or make you take closer look at gpoiolib subsystem and suggest
us the right way to go :-)

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

