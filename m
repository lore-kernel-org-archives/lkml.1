Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbYKMWTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbYKMWTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 17:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbYKMWTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 17:19:25 -0500
Received: from ozlabs.org ([203.10.76.45]:54306 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbYKMWTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 17:19:24 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18716.42977.127816.205211@cargo.ozlabs.ibm.com>
Date: Fri, 14 Nov 2008 09:19:13 +1100
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
In-Reply-To: <20081113131850.d94fb229.akpm@linux-foundation.org>
References: <491434FB.2050904@kernel.org>
	<20081107124957.GA21709@elte.hu>
	<49168BD3.5010204@kernel.org>
	<20081109073813.GA17180@elte.hu>
	<86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com>
	<20081110094033.GL22392@elte.hu>
	<20081110015511.453a801e.akpm@linux-foundation.org>
	<4918065A.6050402@kernel.org>
	<20081110100329.GA19970@elte.hu>
	<491A9F87.8040403@kernel.org>
	<20081112120814.GG11352@elte.hu>
	<491C8B38.9060901@kernel.org>
	<20081113131850.d94fb229.akpm@linux-foundation.org>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> Other architectures want (or have) sparse interrupts.  Are those guys
> paying attention here?

On powerpc we have a mapping from virtual irq numbers (in the range 0
to NR_IRQS-1) to physical irq numbers (which can be anything) and back
again.  I think our approach is simpler than what's being proposed
here, though we don't try to keep the irqdescs node-local as this
patch seems to (fortunately our big systems aren't so NUMA-ish as to
make that necessary).

Paul.
