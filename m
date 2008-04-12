Return-Path: <linux-kernel-owner+w=401wt.eu-S1758855AbYDLBnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbYDLBnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 21:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbYDLBnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 21:43:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54405 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755827AbYDLBnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 21:43:02 -0400
Message-ID: <480013A3.1010502@garzik.org>
Date: Fri, 11 Apr 2008 21:42:59 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Peer Chen <pchen@nvidia.com>, Kuan Luo <kluo@nvidia.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200804031347.20352.volker.armin.hemmann@tu-clausthal.de> <47FEFFC6.4@gmail.com> <200804111355.55364.volker.armin.hemmann@tu-clausthal.de> <48000FF8.300@gmail.com>
In-Reply-To: <48000FF8.300@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Volker Armin Hemmann wrote:
>> Hi,
>>
>>> Aiee.... Can you please try 2.6.25-rc8 with both configurations?  And
>>> w/o systemrescuecd?  Just seeing whether things mount properly or not is
>>> good enough.  There isn't much risk of losing data.
>>
>> 2.6.25-rc8 is a 'no change'. AHCI+pci=nomsi boots, AHCI without hangs.
>> with AHCI I also get this:
>>
>> [    0.363828] ------------[ cut here ]------------
>> [    0.363828] WARNING: at drivers/ata/ahci.c:645 
>> ahci_init_one+0x190/0xa3a()
>> [    0.363828] Modules linked in:
>> [    0.363828] Pid: 1, comm: swapper Not tainted 2.6.25-rc8 #2
> 
> Heh.. that's AHCI_EN not getting set.  Peer, any ideas?  The driver set 
> AHCI_EN in the HOST_CTL register but on reading back it's still clear.

Possibly the hardware is not idle?  I wonder if the BIOS is doing 
anything with the IDE interface.  _Probably_ not, but that is certainly 
a situation where switching to AHCI can be a problem for certain AHCI chips.

	Jeff



