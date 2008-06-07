Return-Path: <linux-kernel-owner+w=401wt.eu-S1762874AbYFGWGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762874AbYFGWGn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 18:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761965AbYFGVvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 17:51:07 -0400
Received: from hpsmtp-eml16.kpnxchange.com ([213.75.38.116]:8116 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758231AbYFGVvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 17:51:03 -0400
From: Frans Pop <elendil@planet.nl>
To: Jesper Krogh <jesper@krogh.cc>
Subject: Re: Linux 2.6.26-rc5
Date: Sat, 7 Jun 2008 23:50:59 +0200
User-Agent: KMail/1.9.9
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Avuton Olrich <avuton@gmail.com>
References: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org> <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org> <484AE520.7050001@krogh.cc>
In-reply-To: <484AE520.7050001@krogh.cc>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806072350.59976.elendil@planet.nl>
X-OriginalArrivalTime: 07 Jun 2008 21:51:00.0438 (UTC) FILETIME=[93018F60:01C8C8E8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Krogh wrote:
> Not that they seem critical to the system but I do get alot of these. I
> cant remember having seen that before.
 
> [    2.904467] system 00:06: iomem range 0x0-0x0 could not be reserved
> [    2.904469] system 00:06: iomem range 0x0-0x0 could not be reserved
> [    2.904471] system 00:06: iomem range 0x0-0x0 could not be reserved
> [    2.904473] system 00:06: iomem range 0x0-0x0 could not be reserved
[...]

I'm getting these too. Not present in the last -rc4 kernel I built.

Reverting this commit (the only recent one to the file the message 
originates from), gets rid of the extra zero-range messages:

commit 4b34fe156455d26ee6ed67b61539f136bf4e439c
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Jun 2 16:42:49 2008 -0600

    PNP: mark resources that conflict with PCI devices "disabled"

    Both the PNP/PCI conflict detection quirk and the PNP system
    driver must use the same mechanism to mark resources as disabled.

    I think it's best to keep the resource and to keep the type bit
    (IORESOURCE_MEM, etc), so that we match the list from firmware
    as closely as possible.

    Fixes this regression from 2.6.25: http://lkml.org/lkml/2008/6/1/82

    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Tested-by: Avuton Olrich <avuton@gmail.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Relevant CCs added.

Cheers,
FJP
