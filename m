Return-Path: <linux-kernel-owner+w=401wt.eu-S1762652AbXKHT41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762652AbXKHT41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 14:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759541AbXKHT4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 14:56:20 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40207 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757013AbXKHT4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 14:56:19 -0500
Subject: 2.6.23 git current compile error on UP
From: Dave Hansen <haveblue@us.ibm.com>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: Avi Kivity <avi@qumranet.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       aliguori <aliguori@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 08 Nov 2007 11:55:49 -0800
Message-Id: <1194551749.7078.78.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/kvm/kvm_main.c: In function `kvm_flush_remote_tlbs':
drivers/kvm/kvm_main.c:220: error: implicit declaration of function `smp_call_function_mask'
make[2]: *** [drivers/kvm/kvm_main.o] Error 1
make[1]: *** [drivers/kvm] Error 2

http://sr71.net/~dave/linux/config-kvm-up

Looks like that function calls smp_call_function_mask() which is never
defined for UP.  Nobody else uses it that way, so I'm not sure what the
right fix is.  I'm not even sure kvm_flush_remote_tlbs() is safe with
its raw_smp_processor_id() use.  Is there a reason it can't get
preempted?

-- Dave

