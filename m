Return-Path: <linux-kernel-owner+w=401wt.eu-S1763714AbXHVQQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763714AbXHVQQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761196AbXHVQQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:16:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:11823 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760227AbXHVQQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:16:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=rCekpY181nuaDkM6UTTWPlzAPAdvVCSBzpLumL0KICm7E1QYdR8MilziDmLN2bmT7MjyAVLCA2J/AjvS07i6AFdCcV+yY/C8eaaVgQOFtJtONPyjSKN5GLSEoZFjnPyphMUoPojZgs++0Wn/93fTw9GUoZBcb7kTtfqK3b8BjIM=
Message-ID: <46CC6112.9030705@googlemail.com>
Date: Wed, 22 Aug 2007 18:15:14 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       linux-scsi@vger.kernel.org
Subject: drivers/scsi/advansys.c - ld error ( Re: 2.6.23-rc3-mm1 )
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_SCSI_ADVANSYS=y && CONFIG_ISA=n results in :

...

drivers/built-in.o: In function `advansys_init':
advansys.c:(.init.text+0x38ea): undefined reference to `isa_register_driver'
advansys.c:(.init.text+0x38ff): undefined reference to `isa_register_driver'
advansys.c:(.init.text+0x3926): undefined reference to `isa_unregister_driver'
advansys.c:(.init.text+0x3930): undefined reference to `isa_unregister_driver'
drivers/built-in.o: In function `advansys_exit':
advansys.c:(.exit.text+0x340): undefined reference to `isa_unregister_driver'
advansys.c:(.exit.text+0x34a): undefined reference to `isa_unregister_driver'
make: *** [.tmp_vmlinux1] Error 1

...


I guess advansys_{init,exit} is missing some #ifdef's ..


config : http://194.231.229.228/kernel/mm/2.6.23-rc3-mm1/r/randconfig-9


Gabriel

