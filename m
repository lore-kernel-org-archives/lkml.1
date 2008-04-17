Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbYDQWtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbYDQWtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 18:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbYDQWtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 18:49:10 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53007 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbYDQWtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 18:49:08 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4807D374.8090608@s5r6.in-berlin.de>
Date: Fri, 18 Apr 2008 00:47:16 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH update] firewire: fw-ohci: work around generation bug
 in	TI controllers (fix AV/C and more)
References: <tkrat.95472d87fa4e6c81@s5r6.in-berlin.de>	<tkrat.3e4f8089bffc4e81@s5r6.in-berlin.de> <200804141330.22131.jwilson@redhat.com>
In-Reply-To: <200804141330.22131.jwilson@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> On Saturday 12 April 2008 04:31:25 pm Stefan Richter wrote:
>> +	ohci->bus_reset_packet_quirk = dev->vendor == PCI_VENDOR_ID_TI;
>> +
> 
> I have a few cards with PCI_VENDOR_ID_CREATIVE with a TI TSB41AB2 chip on 'em 
> (SoundBlaster Audigy w/FireWire port). I've not had any issues on any of the 
> cards I've got, but do we want to add them to the work-around list just to be 
> safe?

No, we don't need to.  TSB41AB2 is only a PHY, not a link layer 
controller.  While the PHYs (the combination of PHYs which are present 
on the bus) influence the conditions under which the bug can happen, the 
cause for the bug is in the link layer controller alone.

So unless Creative used a TI design in their link layer controller or 
otherwise managed to implement this same quirk as TI (Agere, NEC, and 
VIA didn't according to my tests so far), the presence of TSB41AB2 on a 
card does not make it necessary to activate the quirk workaround.
-- 
Stefan Richter
-=====-==--- -=-- =--=-
http://arcgraph.de/sr/
