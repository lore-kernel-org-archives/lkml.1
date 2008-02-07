Return-Path: <linux-kernel-owner+w=401wt.eu-S1763227AbYBGVMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763227AbYBGVMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762785AbYBGUyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:54:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39185 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933252AbYBGUyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:54:08 -0500
Message-ID: <47AB6FD7.1030502@zytor.com>
Date: Thu, 07 Feb 2008 12:53:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24 says "serial8250: too much work for irq4" a lot.
References: <200802051455.10831.rob@landley.net> <20080207123937.GC15647@elte.hu> <47AB41C8.3010001@zytor.com> <200802071413.45085.rob@landley.net>
In-Reply-To: <200802071413.45085.rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> 
> Specifically, qemu isn't paravirtualized, it's fully virtualized.  The same 
> kernel can run on real hardware just fine.  (Sort of the point of the 
> project...)
> 
> I can yank the warning for the kernels I build (or set PASS_LIMIT to 9999999), 
> but I'd rather not carry any more patches than I can avoid...
> 

The right thing to do is to add virtual FIFO exhaustion into the Qemu 
device model.  It really isn't a valid emulation of a UART that it has 
an infinite FIFO behind it that can flood the interrupt handler for an 
arbitrary number of fetches.

I was going to give a technical description of how to do it here, but 
then I realized I might as well just write it up as a patch.  Stay tuned.

	-hpa

