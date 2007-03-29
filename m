Return-Path: <linux-kernel-owner+w=401wt.eu-S933388AbXC2RhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388AbXC2RhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 13:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933688AbXC2RhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 13:37:09 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:43281 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933388AbXC2RhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 13:37:07 -0400
X-Sasl-enc: pKqy3nkNIBLqt1ripUghh+xpRtCFNtyUruDpWoOkWO8t 1175189825
Date: Thu, 29 Mar 2007 14:37:00 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Adam Jackson <ajackson@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix 82875 PCI setup
Message-ID: <20070329173700.GA9348@khazad-dum.debian.net>
References: <1175185000.26247.33.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175185000.26247.33.camel@localhost.localdomain>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2007, Adam Jackson wrote:
> The 82875 EDAC driver enables an otherwise-hidden PCI device, but
> doesn't register it as a PCI device properly.  Therefore, the device
> list in /proc/bus/pci/devices is different than the tree in 
> /sys/bus/pci. This usually manifests as the X server failing to start,
> since it expects the two lists to be consistent.

Just a note: when EDAC needs to unhide the overflow configuration space of
the 82875, it is because the BIOS hid it.  And some BIOSes actually reserve
the area of the hidden device in the memory map/acpi tables/whatever.
Intel's D875PBZ motherboard does this.  EDAC can and does enable the
overflow device, but it might fail to reserve that region because of that
the BIOS did (and that is not a problem, in fact it is expected behaviour).

I don't know if this affects this patch in any way.  If it doesn't just
delete this email.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
