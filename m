Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbXLLHUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbXLLHUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 02:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbXLLHT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 02:19:59 -0500
Received: from hu-out-0506.google.com ([72.14.214.226]:18849 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbXLLHT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 02:19:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=I3unufqzX0HysD4XdfMaBMjrubPbehT4GOOYq1Ja0ltoFrj3jWX1hv+5D3tUXdCYBIu6lskTzHgBkPnDJwGy0UcE1T6ZZeyb9P17xoNBq62RnCEDsbQ9aoUz+QpH0DF/n3YGdfPR10DsQ6t4orxGwkC1qUhf6efLpRjSliQg0DU=
Message-ID: <475F8B45.7060103@keyaccess.nl>
Date: Wed, 12 Dec 2007 08:18:29 +0100
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl> <20071212052304.GB20883@fattire.cabal.ca>
In-Reply-To: <20071212052304.GB20883@fattire.cabal.ca>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
From: Rene Herman <rene.herman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-12-07 06:23, Kyle McMartin wrote:

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

On 32-bit, "=A" is edx:eax. Not sure what the point is in not letting it be 
that on 64-bit in fact, but yes, the thing should be compiled as 32-bit.

Rene.
