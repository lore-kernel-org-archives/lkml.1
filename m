Return-Path: <linux-kernel-owner+w=401wt.eu-S932877AbXK2TEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877AbXK2TEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758399AbXK2TEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:04:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60611 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719AbXK2TEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:04:42 -0500
Message-ID: <474F0D47.7020006@zytor.com>
Date: Thu, 29 Nov 2007 11:04:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: =?UTF-8?B?IlBhdWwgUm9sbGFuZCAo44Od44O844Or44O744Ot44Op44OzKSI=?= 
	<rol@witbe.net>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: constant_tsc and TSC unstable
References: <20071129171142.56c7890a@tux.DEF.witbe.net>
In-Reply-To: <20071129171142.56c7890a@tux.DEF.witbe.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Rolland (ポール・ロラン) wrote:
> Hello,
> 
> I've a machine with a Core2Duo CPU. /proc/cpuinfo reports the flag
> constant_tsc, but at boot time, I have the log :
> 
> ...
> Total of 2 processors activated (6919.15 BogoMIPS).
> ENABLING IO-APIC IRQs
> ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> checking TSC synchronization [CPU#0 -> CPU#1]:
> Measured 3978592228 cycles TSC warp between CPUs, turning off TSC clock.
> Marking TSC unstable due to: check_tsc_sync_source failed.
> Brought up 2 CPUs
> ...
> 
> This machine is running 2.6.23.1-21.fc7. I know I should report to Fedora,
> but I was wondering if this is a bug or a feature ;)
> 

constant_tsc means the TSC doesn't change with CPU core frequency.

The problem you're having is that the TSCs of your two cores are 
completely different, over a second apart.  This is a bug, unrelated to 
constant_tsc.

	-hpa



