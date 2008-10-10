Return-Path: <linux-kernel-owner+w=401wt.eu-S1760076AbYJJQaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076AbYJJQaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759472AbYJJQaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:30:03 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:59248 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759930AbYJJQaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:30:00 -0400
Date: Fri, 10 Oct 2008 17:29:59 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Typo in x86 apic.c with DIVISOR setup
In-Reply-To: <7E82351C108FA840AB1866AC776AEC4637823667@orsmsx505.amr.corp.intel.com>
Message-ID: <alpine.LFD.1.10.0810101723290.19747@ftp.linux-mips.org>
References: <20081010002203.GA23238@linux-os.sc.intel.com>  <aa79d98a0810092138q1f27a94bhd544ca3637c02c4f@mail.gmail.com>  <7E82351C108FA840AB1866AC776AEC463782339F@orsmsx505.amr.corp.intel.com> <aa79d98a0810092239p32153776qd0cda47e54929545@mail.gmail.com>
 <7E82351C108FA840AB1866AC776AEC4637823667@orsmsx505.amr.corp.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008, Pallipadi, Venkatesh wrote:

> I understand that using 1 instead of 16 makes APIC timer count 16 times faster.
> I did that change as I thought that was the intention of making APIC_DIVISOR as 1.
> Otherwise, there is no real impact of APIC_DIVISOR #define from being there. It
> Is just changing the value of calibration_result across 32 bit and 64 bit kernels.

 To use the value of 1 for the predivisor, special arrangements would have 
to be made for the discrete 82489DX APIC.  And we want to keep code 
variations as little as possible, especially when uncommon configurations 
are considered.  The value of 16 is supported universally with no special 
cases.

> For example, "host bus clock speed" message will print different values across
> 32 bit and 64 bit kernels on the same system, if we just make APIC_DIVISOR
> 16 for 32 bit and 1 for 64 bit kernel.

 All places have to agree on the value of the predivisor of course -- if 
you can see a problem somewhere, then please do send a patch.

  Maciej
