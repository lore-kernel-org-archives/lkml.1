Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbYGXOil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbYGXOil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 10:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbYGXOi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 10:38:27 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:51962 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbYGXOi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 10:38:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ma5ykcedXLOPBsVM0j9Tu/GhJR+tI/kbXXC2Q2hWA9ayMOc9RMA0mGAa9pFEPOCWWn
         Pq7e9IQ1lpn4v2opBRQh3owDGn/YairP1+Mt/Xn7vFTkzjPyTXMAaBay9+TGWIt3NJqe
         AWNKDiD6l7IgMpgIJ0q4i0IIL/E8PdSP9zCx0=
Message-ID: <19f34abd0807240738h7ac5e716rcfa39d528b07870f@mail.gmail.com>
Date: Thu, 24 Jul 2008 16:38:23 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Jason Wessel" <jason.wessel@windriver.com>
Subject: Re: KGDB fails to pass selft tests on x86-64 (v2.6.26)
Cc: "Francis Moreau" <francis.moro@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <488891F2.9020509@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0807240624v7ec90c50n8105f830d10dddd@mail.gmail.com>
	 <38b2ab8a0807240708j7d6782b7te6123fdd7416ec95@mail.gmail.com>
	 <488891F2.9020509@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 4:30 PM, Jason Wessel
<jason.wessel@windriver.com> wrote:
> Francis Moreau wrote:
>> On Thu, Jul 24, 2008 at 3:24 PM, Francis Moreau <francis.moro@gmail.com> wrote:
>>> So the first thing I did is to enable kgdb support and also the
>>> kgdb self tests:
>>>
>>> CONFIG_HAVE_ARCH_KGDB=y
>>> CONFIG_KGDB=y
>>> CONFIG_KGDB_SERIAL_CONSOLE=y
>>> CONFIG_KGDB_TESTS=y
>>> # CONFIG_KGDB_TESTS_ON_BOOT is not set
>>>
>>> Once compiled I booted this kernel through qemu and got the following:
>>>
>> and unfortunately it seems this issue is related to qemu: if I did boot the
>> kernel without qemu and the self tests passed...
>>
>>
>>
>
> It is because the qemu you are using does not support hardware
> breakpoints.  The tests will warn, but the kernel will continue to boot
> and tell you that hw breakpoint support doesn't work on your simulated
> hardware.
>
> Also, if you plan to use software breakpoints, please make sure to turn
> off CONFIG_DEBUG_RODATA, else they will not work.   This is a regression
> which will is on my list of things to take a look at, as time permits.

I had a couple of kernels hang during single-stepping self-tests (I
think), where it reached 500 and 900 tests respectively before it hung
hard (NMI watchdog enabled, but not triggering). Is this related to
the RODATA thing?

This was with a recent (post-v2.6.26) kernel on a real P4.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
