Return-Path: <linux-kernel-owner+w=401wt.eu-S932915AbZLKPtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915AbZLKPtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932845AbZLKPtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:49:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932837AbZLKPtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:49:11 -0500
Date: Fri, 11 Dec 2009 07:38:14 -0800
From: Greg KH <gregkh@suse.de>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: bn@niasdigital.com,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dsilvers@simtec.co.uk" <dsilvers@simtec.co.uk>,
       "ben@simtec.co.uk" <ben@simtec.co.uk>,
       "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] gpiolib: add support for having symlinks under
	gpio class directory
Message-ID: <20091211153814.GE28097@suse.de>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com> <71eff9c88d3fec3daa218341c83c19a106ee1f62.1260364108.git.ext-jani.1.nikula@nokia.com> <20091210024834.GB20410@suse.de> <1260455537.25352.1762.camel@jani-desktop> <20091210144920.GA27237@suse.de> <1260520900.25352.2823.camel@jani-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260520900.25352.2823.camel@jani-desktop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 10:41:40AM +0200, Jani Nikula wrote:
> Let's see. 'udevadm monitor --env' gives me this when I 'echo add >
> uevent' for an exported gpio #5:
> 
> UDEV  [1230784956.241303] add      /class/gpio/gpio5 (gpio)                     
> UDEV_LOG=3                                                                      
> ACTION=add                                                                      
> DEVPATH=/class/gpio/gpio5                                                       
> SUBSYSTEM=gpio                                                                  
> SEQNUM=930                                                                      
> UDEVD_EVENT=1
> 
> Now *assuming* we had /sys/class/gpio/gpioN/name, I could create very
> crude udev rules along the lines of this:
> 
> SUBSYSTEM=="gpio", ACTION=="add", ATTR{name}!="", RUN="/bin/ln -s /sys$devpath /tmp/gpio-$attr{name}"
> SUBSYSTEM=="gpio", ACTION=="remove", ATTR{name}!="", RUN="/bin/rm /tmp/gpio-$attr{name}"
> 
> Not exactly pretty, but seems to work (using another attr for testing).
> Is there a more elegant way of doing this with udev when there are no
> device nodes? Or is it even sensible to use udev without the device
> nodes? And what would be the right place for the symlinks?

Kay said he didn't like you creating symlinks in /dev with udev, but
this looks ok to me.

> *If* we got that working in a sensible fashion, it'd be a matter of
> adding the "name" attribute to each gpio.

Yup, just use whatever you were wanting to use as the symlink name, it
seems that logic was already done.

thanks.

greg k-h
