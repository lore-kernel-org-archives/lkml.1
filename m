Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab0CEEk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 23:40:56 -0500
Received: from THUNK.ORG ([69.25.196.29]:50089 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330Ab0CEEkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 23:40:55 -0500
Date: Thu, 4 Mar 2010 23:40:54 -0500
From: tytso@mit.edu
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] X doesn't work with 2.6.33 (can't find any input
 devices)
Message-ID: <20100305044054.GB5747@thunk.org>
Mail-Followup-To: tytso@mit.edu, David Miller <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
References: <20100303151720.GA3191@thunk.org>
 <20100303.072007.170106625.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100303.072007.170106625.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 07:20:07AM -0800, David Miller wrote:
> From: tytso@mit.edu
> Date: Wed, 3 Mar 2010 10:17:20 -0500
> 
> > It worked just *fine* using 2.6.33-rc4.  I have no xorg.conf file (X
> > is autoconfiguring itself) and I'm using an Ubuntu 9.10 userspace.
> 
> X uses udev events to find input devices these days, so it's probably
> the same problem preventing your lvm devices from showing up correctly
> from initramfs.

It uses libhal, I believe to find input devices and I was finally able
to work around the problem by configuring an manually recreated
xorg.conf file with the magic option:

Section "ServerFlags"
	Option "AllowEmptyInput" "off"
EndSection

... and then making sure that the kbd and mouse input drivers were
installed.  There is definitely something wrong though if sometime
between 2;6.33-rc4 and 2.6.33 we've made some incompatible sysfs
change that breaks hal on Ubuntu 9.10 (which is still the latest
Ubuntu community release), such that people can't test 2.6.33 kernels
using it --- at least not easily.

See Linus's complaints over the nouveau driver; it's the same
principle; something is really broken.

							- Ted

