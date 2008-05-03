Return-Path: <linux-kernel-owner+w=401wt.eu-S935995AbYECAmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935995AbYECAmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 20:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758221AbYECAmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 20:42:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37771 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738AbYECAmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 20:42:01 -0400
Message-ID: <481BB4D5.3020004@zytor.com>
Date: Fri, 02 May 2008 17:41:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Moore, Eric" <Eric.Moore@lsi.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: HELP:  Is writeq an atomic operation??
References: <0631C836DBF79F42B5A60C8C8D4E822901047B2F@NAMAIL2.ad.lsil.com>
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E822901047B2F@NAMAIL2.ad.lsil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moore, Eric wrote:
> Is a 64bit write to MMIO registers an atomic operation when using the
> writeq API?  
> 
> My concern is when I send 64bit data via writeq, will it be sent out as
> two 32 bit writes?  If so, is it possible that another CPU be sending
> the data at the same time.  Meaning can I write the 1st 32bit data from
> CPU-A, meanwhile CPU-B is writing his 32bit data at the same time, and
> CPU-A didn't complete the full 64bit in one shot.  If this could occur,
> is there an API that I can use to make sure the entire data sent in one
> atomic operation?
> 
> 
> Here is a trace from pci express analyzer.   I'm sending
> 0x0800010000000000 to the adress DD1400C0 using writeq.   Notice that in
> the TLP header it sent a 32bit Memory write with data length of two.
> 
> Trace follows:
> 
> Link Tra(597) Downstream 2.5(x1) TLP(1992) Mem MWr(32)(10:00000) TC(0)
> TD(0) 
> _______| EP(0) Attributes(01) Length(2) RequesterID(000:02:0) Tag(8) 
> _______| Address(DD1400C0) 1st BE(1111) Last BE(1111) Data(08000100
> 00000000) 
> _______| VC ID(0) Explicit ACK(Packet #1195) Metrics # Packets(2) 
> _______| Time Stamp(0003 . 120 181 840 s) 

That is how that operation is represented on the PCI Express bus.

"32 bit" refers to the size of the address, not the size of the data.

However, for 32-bit systems, including x86 in 32-bit mode, there isn't 
any 64-bit atomic operation without using MMX/SSE.

	-hpa
