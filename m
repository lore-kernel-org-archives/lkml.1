Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbXLLTaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbXLLTaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:30:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbXLLT35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:29:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50925 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbXLLT34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:29:56 -0500
Message-ID: <476035C0.1040708@zytor.com>
Date: Wed, 12 Dec 2007 11:25:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: Rene Herman <rene.herman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl> <20071212052304.GB20883@fattire.cabal.ca>
In-Reply-To: <20071212052304.GB20883@fattire.cabal.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin wrote:
> On Wed, Dec 12, 2007 at 12:31:18AM +0100, Rene Herman wrote:
>> 	asm volatile ("rdtsc": "=A" (tsc));
> 
> rdtsc returns a 64-bit value in two 32-bit regs, you need to do
> 
> inline unsigned long long rdtsc(void)
> {
> 	unsigned int lo, hi;
> 	asm volatile ("rdtsc": "=a" (lo), "=d" (hi));
> 	return (unsigned long long)hi << 32 | lo;
> }
> 
> as in msr.h, otherwise you'll only be looking at the value in %rax.
> 

"=A" works on 32-bit systems (only), obviously, and gcc will generally 
produce slightly better code as a result (gcc could really use a 
register renaming/copy propagation step *after* multi-register entities 
are broken apart, at least on architectures which don't have register 
pairs as a hardware constraint.)

	-hpa
