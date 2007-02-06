Return-Path: <linux-kernel-owner+w=401wt.eu-S965468AbXBFV7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965468AbXBFV7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965474AbXBFV7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:59:11 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53062 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S965468AbXBFV7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:59:10 -0500
Message-ID: <45C8FA2D.6010706@vmware.com>
Date: Tue, 06 Feb 2007 13:59:09 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Andi Kleen <ak@muc.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 9/11] Panic delay fix
References: <200702060353.l163rUmj000771@zach-dev.vmware.com> <20070206122729.GC47229@muc.de>
In-Reply-To: <20070206122729.GC47229@muc.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Mon, Feb 05, 2007 at 07:53:30PM -0800, Zachary Amsden wrote:
>   
>> Failure to use real-time delay here causes the keyboard to become demonically
>> possessed in the event of a kernel crash, with wildly blinking lights and
>> unpredictable behavior.  This has resulted in several injuries.
>>     
>
> There must be a reason why it wasn't default before. Has this
> reason changed?
>   

This only matters under paravirt; non-paravirt kernels and kernels 
running on native hardware will always behave properly.

But paravirtualized kernels with fake devices have no need to udelay to 
accommodate slow hardware - the hardware is just virtual.  The 
USE_REAL_TIME_DELAY define allows udelay to be specifically reverted 
back to being a real delay.  There are only a couple cases where it 
matters - one is booting APs on SMP systems (there is a real delay 
before they come up), and one is any hardware that drives world 
interacting devices - such as keyboard LEDs in a panic loop.

Zach
