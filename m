Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbXJIFA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbXJIFA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 01:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbXJIFAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 01:00:16 -0400
Received: from smtp123.sbc.mail.re3.yahoo.com ([66.196.96.96]:40583 "HELO
	smtp123.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751037AbXJIFAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 01:00:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=u+cTPtwlkzZid6ZSydFt+4H2Np3PGYlvQdWg/S4o9PXk6yewFuEaQbtsaRYg7EOcW6oK8eSNUF8cFodf3XDRmn2AnFaOWKSHDRZXqGjYWAT7zkEDj4NoV9GMvZQoUFqkNmcS3hlMXzwGq9BwPswC5nH6Gy2E0eFYeQRfw+PahwY=  ;
X-YMail-OSG: bP0msiEVM1lFUhVLCs4WUaVz1a9k.fv6c4Nhg54n6PbgOn.VXI1iXtMBfU9t6iTRC1C8xsgI5w--
Date: Mon, 08 Oct 2007 22:00:19 -0700
From: David Brownell <david-b@pacbell.net>
To: greg@kroah.com, davem@davemloft.net
Subject: Re: OHCI root_port_reset() deadly loop...
Cc: linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20071009031049.GD14127@kroah.com>
 <20071008.201653.43030513.davem@davemloft.net>
 <20071009033412.E37E323700C@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20071008.204236.92016616.davem@davemloft.net>
 <20071009043909.GA4940@kroah.com>
In-Reply-To: <20071009043909.GA4940@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071009050019.C6C6023718A@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > The old /etc/hotplug/usb.rc script made sure to load those modules
> > > in the correct order:  EHCI first.
> > 
> > I expected to find something cute attempting to handle this under
> > /etc/udev, I have failed so far :-)
>
> No, nothing cute in udev itself, but it seems that all distros that I
> know of have a "load these modules now" type setting in their init
> scripts that can be used here.
>
> I can't think of a way to enforce this load order on the modules
> themselves due to the fact that OHCI might not even be needed for EHCI
> devices on UHCI (Intel) based chipsets :(

Assuming PCI is present, /sys/bus/pci/devices/*/class can tell
if EHCI is present (0x0c0320) ... if so, load that driver.
Then repeat for OHCI (0x0c0310) and UHCI (0x0c0300).
