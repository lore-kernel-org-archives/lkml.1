Return-Path: <linux-kernel-owner+w=401wt.eu-S946587AbXHMOpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946587AbXHMOpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S943239AbXHML4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:56:01 -0400
Received: from hu-out-0506.google.com ([72.14.214.224]:50597 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S943381AbXHMLz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:55:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=MpzyW6XeA3V9/XaaWQRQb4XA+8B7KYDJhbULiCziyYbfzuc+4FwCd9um+0Onhm8QJ9QI1R3mracnR0lvYNpkFEuRRrDKLMVBMLCQnsLBF7RKYNvg7l65IWIdxYvRBxzYPSZxbVU42feDqrfVxPh1DhozKAB1TcmyhklL+wD/sOs=
Date: Mon, 13 Aug 2007 15:55:40 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Paul Moore <paul.moore@hp.com>, Stephen Smalley <sds@epoch.ncsc.mil>,
       Chris Vance <cvance@nai.com>, Wayne Salamon <wsalamon@nai.com>,
       James Morris <jmorris@redhat.com>, dgoeddel@trustedcs.com,
       Fengguang Wu <fengguang.wu@gmail.com>
Subject: Re: [BUGFIX] NULL pointer dereference in __vm_enough_memory()
Message-ID: <20070813115540.GB7239@cvg>
References: <20070812141905.4ee423b9@the-village.bc.nu> <386927758.14086@ustc.edu.cn> <20070812161744.200d4252@the-village.bc.nu> <20070812162143.GA7202@cvg> <20070813002342.GA6908@mail.ustc.edu.cn> <20070813095302.GA7239@cvg> <20070813122224.6b9d90fd@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070813122224.6b9d90fd@the-village.bc.nu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Alan Cox - Mon, Aug 13, 2007 at 12:22:24PM +0100]
| > Well, as I see, it seems the Alan's patch is correct. We pass
| > newly created mm to security_vm_enough_memory_mm() and get no errors
| > here even for overcommit = 2. But my question was that mm->total_vm
| > = 0 for this case and that is probably valid too I think. What about
| > the thing you pointed about? Well I think security_vm_enough_memory
| > should never be called from kernel thread (we have secrurity_vm_enough_memory_mm
| > for this). But I will check it more closely. Dont get me wrong - I'm not
| > VMM expert and may do errors ;)
| 
| A vma has to inserted into an mm struct so we are fine in terms of kernel
| threads. init_bprm showed up a new case where we add vma's to an mm that
| isn't current->mm. The rest of the vm subsystem supports this and there
| are cases for the future (eg the usermode linux mm switching patch) where
| it might matter that we do it right.
| 
| Alan
| 

ok, thanks for explanation, Alan.

		Cyrill

