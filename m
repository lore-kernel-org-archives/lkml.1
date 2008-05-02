Return-Path: <linux-kernel-owner+w=401wt.eu-S937225AbYEBXEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937225AbYEBXEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935309AbYEBXEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:04:04 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:40577 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765907AbYEBXED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:04:03 -0400
From: Roland Dreier <rdreier@cisco.com>
To: "Moore\, Eric" <Eric.Moore@lsi.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: HELP:  Is writeq an atomic operation??
References: <0631C836DBF79F42B5A60C8C8D4E822901047B2F@NAMAIL2.ad.lsil.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 02 May 2008 16:04:00 -0700
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E822901047B2F@NAMAIL2.ad.lsil.com>
	(Eric Moore's message of "Fri, 2 May 2008 16:40:40 -0600")
Message-ID: <adaskx02tr3.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 May 2008 23:04:01.0184 (UTC) FILETIME=[CF435A00:01C8ACA8]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Here is a trace from pci express analyzer.   I'm sending
 > 0x0800010000000000 to the adress DD1400C0 using writeq.   Notice that in
 > the TLP header it sent a 32bit Memory write with data length of two.

By the way, are you worried that there is something wrong with this
trace?  Your write went out in a single PCIe packet, so it looks perfect
to me.  Does the "Mem MWr(32)" worry you?  I can't see why it would be a
problem -- the PCIe TLP only has one type of memory write transaction
(well, except for 32-bit or 64-bit addressing, but you don't care about
that), and memory write transactions are sent as a string of 32-bit
chunks, so there's no other way a 64-bit write could be sent.

 > Trace follows:
 > 
 > Link Tra(597) Downstream 2.5(x1) TLP(1992) Mem MWr(32)(10:00000) TC(0)
 > TD(0) 
 > _______| EP(0) Attributes(01) Length(2) RequesterID(000:02:0) Tag(8) 
 > _______| Address(DD1400C0) 1st BE(1111) Last BE(1111) Data(08000100
 > 00000000) 
 > _______| VC ID(0) Explicit ACK(Packet #1195) Metrics # Packets(2) 
 > _______| Time Stamp(0003 . 120 181 840 s) 
