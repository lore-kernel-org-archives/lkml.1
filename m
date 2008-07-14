Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbYGNSYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbYGNSYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 14:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbYGNSYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 14:24:47 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64194 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751692AbYGNSYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 14:24:47 -0400
Date: Mon, 14 Jul 2008 19:24:15 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: let 32bit use apic_ops too
In-Reply-To: <20080714180908.GB6986@asus>
Message-ID: <Pine.LNX.4.55.0807141919540.17431@cliff.in.clinika.pl>
References: <200807102038.26591.yhlu.kernel@gmail.com>
 <200807111841.55403.yhlu.kernel@gmail.com> <20080713010843.GD1678@linux-os.sc.intel.com>
 <86802c440807121904m1516b47am22a384a1e5868f68@mail.gmail.com>
 <20080713162804.GI1678@linux-os.sc.intel.com> <Pine.LNX.4.55.0807131737240.10630@cliff.in.clinika.pl>
 <20080713171634.GD7459@asus> <Pine.LNX.4.55.0807140016140.10630@cliff.in.clinika.pl>
 <20080714164809.GA6986@asus> <Pine.LNX.4.55.0807141805500.16334@cliff.in.clinika.pl>
 <20080714180908.GB6986@asus>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008, Cyrill Gorcunov wrote:

>   Maciej, check me please (it's a bit shame but I don't understand the problem
> that deep) - we have only two errata here 3AP and 11AP. 3AP says - "Writes to
> error register clears register" so we don't care about locking there since
> our mostly task is to read error number or clear it (well we're recommened
> to write before read - but that is different and not related to the hw
> error).
> 
>   The second problem - 11AP says the following: "Back to back assertions of
> HOLD or BOFF# may cause lost APIC write cycle". For this case we use LOCK#
> since - HOLD is not recognized during LOCK cycles (as Intel docs says).
> 
>   Did I miss something? Or maybe it's completely out-of-topic? :)

 Check the text of the 11AP erratum -- we simply use one of the Intel's
recommended workarounds, which says that an APIC read instruction before
every APIC write instruction will avoid the problem.

  Maciej
