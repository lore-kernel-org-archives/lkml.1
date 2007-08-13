Return-Path: <linux-kernel-owner+w=401wt.eu-S946464AbXHMOPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946464AbXHMOPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S944285AbXHMLQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:16:14 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44225 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S944276AbXHMLQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:16:12 -0400
Date: Mon, 13 Aug 2007 12:22:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Paul Moore <paul.moore@hp.com>, Stephen Smalley <sds@epoch.ncsc.mil>,
       Chris Vance <cvance@nai.com>, Wayne Salamon <wsalamon@nai.com>,
       James Morris <jmorris@redhat.com>, dgoeddel@trustedcs.com,
       Fengguang Wu <fengguang.wu@gmail.com>
Subject: Re: [BUGFIX] NULL pointer dereference in __vm_enough_memory()
Message-ID: <20070813122224.6b9d90fd@the-village.bc.nu>
In-Reply-To: <20070813095302.GA7239@cvg>
References: <20070812141905.4ee423b9@the-village.bc.nu>
	<386927758.14086@ustc.edu.cn>
	<20070812161744.200d4252@the-village.bc.nu>
	<20070812162143.GA7202@cvg>
	<20070813002342.GA6908@mail.ustc.edu.cn>
	<20070813095302.GA7239@cvg>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, as I see, it seems the Alan's patch is correct. We pass
> newly created mm to security_vm_enough_memory_mm() and get no errors
> here even for overcommit = 2. But my question was that mm->total_vm
> = 0 for this case and that is probably valid too I think. What about
> the thing you pointed about? Well I think security_vm_enough_memory
> should never be called from kernel thread (we have secrurity_vm_enough_memory_mm
> for this). But I will check it more closely. Dont get me wrong - I'm not
> VMM expert and may do errors ;)

A vma has to inserted into an mm struct so we are fine in terms of kernel
threads. init_bprm showed up a new case where we add vma's to an mm that
isn't current->mm. The rest of the vm subsystem supports this and there
are cases for the future (eg the usermode linux mm switching patch) where
it might matter that we do it right.

Alan
