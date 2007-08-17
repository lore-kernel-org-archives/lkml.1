Return-Path: <linux-kernel-owner+w=401wt.eu-S1764196AbXHQQgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764196AbXHQQgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 12:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbXHQQgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 12:36:08 -0400
Received: from turtle-out.mxes.net ([216.86.168.191]:3936 "EHLO
	turtle-out.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbXHQQgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 12:36:07 -0400
X-Greylist: delayed 2160 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Aug 2007 12:36:07 EDT
Message-ID: <46C5C5E5.3040503@tuffmail.co.uk>
Date: Fri, 17 Aug 2007 16:59:33 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: rtl8187: Invalid hwaddr! Using randomly generated MAC address
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've just acquired this buggy piece of hardware otherwise known as a
NetGear WG111v2.  I googled and eventually found an explanation in the
form of source code here:

<http://www.gelato.unsw.edu.au/lxr/source/include/linux/etherdevice.h#L93>.


It seems linux rejects the hardware MAC address because it is either all
zero or a multicast address (ie the first byte has 0x01 set.

On the side of this buggy piece of hardware is written:

MAC 001B2F7604E6

which AFAICS is valid; it's definitely not all zeros and the first byte
has no bits set at all.


Q.  Udev can't access the invalid mac address.  Does that mean there is
no persistent identifier for the device?  I know I could identify a
device as a NetGear WG111v2, but I do have two of them.  It would be
nice if I could fix them by adding udev rules to identify individual
devices, and set their MAC address to what it's "supposed" to be.

/me scrabbles around for a Windows installation to find out whether the
MAC address is somehow set correctly on the Other OS.
