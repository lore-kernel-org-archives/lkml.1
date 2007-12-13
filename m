Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbXLMCpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbXLMCpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 21:45:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbXLMCpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 21:45:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55457 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbXLMCpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 21:45:04 -0500
Message-ID: <47609BCB.30702@zytor.com>
Date: Wed, 12 Dec 2007 18:41:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Kyle McMartin <kyle@mcmartin.ca>,
       Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl> <20071212052304.GB20883@fattire.cabal.ca> <475F8B45.7060103@keyaccess.nl>
In-Reply-To: <475F8B45.7060103@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 12-12-07 06:23, Kyle McMartin wrote:
> 
>> On Wed, Dec 12, 2007 at 12:31:18AM +0100, Rene Herman wrote:
>>>     asm volatile ("rdtsc": "=A" (tsc));
>>
>> rdtsc returns a 64-bit value in two 32-bit regs, you need to do
>>
>> inline unsigned long long rdtsc(void)
>> {
>>     unsigned int lo, hi;
>>     asm volatile ("rdtsc": "=a" (lo), "=d" (hi));
>>     return (unsigned long long)hi << 32 | lo;
>> }
>>
>> as in msr.h, otherwise you'll only be looking at the value in %rax.
> 
> On 32-bit, "=A" is edx:eax. Not sure what the point is in not letting it 
> be that on 64-bit in fact, but yes, the thing should be compiled as 32-bit.

On 64-bit, "=A" is rdx:rax, which means that a 64-bit value ends up in 
rax only (a 128-bit value, which gcc does support on 128-bit platforms, 
would be in rdx:rax.)

gcc can't deal internally with values that span partial registers.

	-hpa
