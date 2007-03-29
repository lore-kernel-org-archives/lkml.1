Return-Path: <linux-kernel-owner+w=401wt.eu-S934060AbXC2J7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934060AbXC2J7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 05:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934078AbXC2J7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 05:59:32 -0400
Received: from styx.suse.cz ([82.119.242.94]:41074 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934060AbXC2J7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 05:59:31 -0400
Date: Thu, 29 Mar 2007 11:24:09 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Li Yu <raise.sail@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>, hongzhiyi@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       yanghong@ccoss.com.cn, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
In-Reply-To: <460B507E.60305@gmail.com>
Message-ID: <Pine.LNX.4.64.0703291056360.19566@jikos.suse.cz>
References: <200703051532096508636@gmail.com>  <45FE6971.6090503@gmail.com>
 <1174897676.5815.6.camel@violet> <4609CAF2.3040303@ccoss.com.cn>
 <Pine.LNX.4.64.0703280945560.19566@jikos.suse.cz> <460B507E.60305@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2007, Li Yu wrote:

> The last word is a question, what's the future of hiddev? It will merge 
> into hidraw later?  I think so, but can't sure.

Hi Li,

no, it won't, it doesn't provide compatible interface for purpose.

hiddev has currently the following drawbacks:

- USB-transport specific

- uses in-kernel HID parser to parse reports and fill in usages and 
  values. This is usually not what authors of the userspace drivers for 
  HID devices want - the devices often have quirks or behave in a strange 
  way, and making workarounds is more complicated when kernel parser 
  operates on the received reports

- only a few applications use it (acupsd, nut, hid2hcianything else?). All 
  other drivers rather use libhid, which is built on top of libusb, in 
  order to be able to receive and send really raw HID reports, and parse 
  them on their own. This is however also USB-transport specific

The purpose of hidraw is to provide the applications the same 
functionality they are having when using libhid/libusb, but in a 
transport-independent way, as it is hooked to generic HID layer, which 
works as a 'proxy' for different transports that use it.

-- 
Jiri Kosina
