Return-Path: <linux-kernel-owner+w=401wt.eu-S1751847AbXBAPsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbXBAPsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbXBAPsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:48:31 -0500
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:33172
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbXBAPs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:48:29 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: Free Linux Driver Development!
Date: Thu, 1 Feb 2007 16:46:38 +0100
User-Agent: KMail/1.9.5
Cc: Jeff Garzik <jeff@garzik.org>, Roland Dreier <rdreier@cisco.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
References: <20070130012904.GA9617@kroah.com> <45BFC2CF.8010603@garzik.org> <20070130222344.GF7584@csclub.uwaterloo.ca>
In-Reply-To: <20070130222344.GF7584@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702011646.38762.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 January 2007 23:23, Lennart Sorensen wrote:
> On Tue, Jan 30, 2007 at 05:12:31PM -0500, Jeff Garzik wrote:
> > You mean the bcm43xx wireless driver that's been upstream for months?
> 
> And seems to do 802.11b only and screw up the eeprom settings so that
> the windows driver gets confused next time you boot windows.  Lovely

Nah, why do you think it will screw up the eeprom?
Did you try to completely power off the machine before rebooting
into windows?

I _really_ _really_ _really_ think that there is no chance of writing
the eeprom by accident. It is protected by some write-enable bit in
PCI config space. There is only one place where we enable that bit
and where we actually _write_ to the eeprom shadow mmio space. That's
the eeprom writing code. It will output _lots_ of kernelmessages that
you really can't miss when that happens. And it's only called on behalf
of a private ioctl user request. _And_ it verifies the data with a CRC
check. So you really can't call it by accident.

But prove me wrong and show the code that writes to eeprom. :)

> driver.  If the bios on the laptop in question would let me change the
> minipci card I would.  To something with a ralink on it.
> 
> Seems the ralink driver maintainers are doing a lot of the work on the
> core wifi infastructure too.  Lots of work beyond just the driver then.

Are you suggesting that bcm43xx people don't, or what?
Are you living on another planet than me? Mine is called "Earth".

-- 
Greetings Michael.
