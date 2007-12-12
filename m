Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbXLLFXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbXLLFXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 00:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbXLLFXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 00:23:07 -0500
Received: from there.is.no.cabal.ca ([134.117.69.58]:53261 "EHLO
	fattire.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbXLLFXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 00:23:07 -0500
Date: Wed, 12 Dec 2007 00:23:04 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Rene Herman <rene.herman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
Message-ID: <20071212052304.GB20883@fattire.cabal.ca>
References: <475F1DC6.5090403@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 12:31:18AM +0100, Rene Herman wrote:
> 	asm volatile ("rdtsc": "=A" (tsc));

rdtsc returns a 64-bit value in two 32-bit regs, you need to do

inline unsigned long long rdtsc(void)
{
	unsigned int lo, hi;
	asm volatile ("rdtsc": "=a" (lo), "=d" (hi));
	return (unsigned long long)hi << 32 | lo;
}

as in msr.h, otherwise you'll only be looking at the value in %rax.

cheers,
	Kyle
