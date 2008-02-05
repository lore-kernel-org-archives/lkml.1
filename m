Return-Path: <linux-kernel-owner+w=401wt.eu-S1759276AbYBESVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276AbYBESVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbYBESVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:21:05 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:41903 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753740AbYBESVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:21:03 -0500
Message-ID: <47A8A90B.6010602@garzik.org>
Date: Tue, 05 Feb 2008 13:20:59 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: netdev@vger.kernel.org, michael.pyne@kdemail.net, AAbdulla@nvidia.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/4] forcedeth: fix MAC address detection on network card
 (regression in 2.6.23)
References: <200802050746.m157ktY9010399@imap1.linux-foundation.org>
In-Reply-To: <200802050746.m157ktY9010399@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> From: Michael Pyne <michael.pyne@kdemail.net>
> 
> Partially revert a change to mac address detection introduced to the forcedeth
> driver.  The change was intended to correct mac address detection for newer
> nVidia chipsets where the mac address was stored in reverse order.  One of
> those chipsets appears to still have the mac address in reverse order (or at
> least, it does on my system).
> 
> The change that broke mac address detection for my card was commit
> ef756b3e56c68a4d76d9d7b9a73fa8f4f739180f "forcedeth: mac address correct"
> 
> My network card is an nVidia built-in Ethernet card, output from lspci as
> follows (with text and numeric ids):
> $ lspci | grep Ethernet
> 00:07.0 Bridge: nVidia Corporation MCP61 Ethernet (rev a2)
> $ lspci -n | grep 07.0
> 00:07.0 0680: 10de:03ef (rev a2)
> 
> The vendor id is, of course, nVidia.  The device id corresponds to the
> NVIDIA_NVENET_19 entry.
> 
> The included patch fixes the MAC address detection on my system.
> Interestingly, the MAC address appears to be in the range reserved for my
> motherboard manufacturer (Gigabyte) and not nVidia.
> 
> Signed-off-by: Michael J. Pyne <michael.pyne@kdemail.net>
> Cc: Jeff Garzik <jeff@garzik.org>
> Cc: Ayaz Abdulla <aabdulla@nvidia.com>
> Cc: <stable@kernel.org>
> 
> On Wed, 21 Nov 2007 15:34:52 -0800
> "Ayaz Abdulla" <AAbdulla@nvidia.com> wrote:
> 
>> The solution is to get the OEM to update their BIOS (instead of
>> integrating this patch) since the MCP61 specs indicate that the MAC
>> Address should be in correct order from BIOS.
>>
>> By changing the feature DEV_HAS_CORRECT_MACADDR to all MCP61 boards, it
>> could cause it to break on other OEM systems who have implemented it
>> correctly.
>>
> 
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

NAK - this fixes one set of users, and breaks a working set of users.

Need to add DMI check for the specific motherboard (dmi_check_system), 
and flip flag according to success/failure of that check.

	Jeff




