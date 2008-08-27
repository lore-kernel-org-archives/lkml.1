Return-Path: <linux-kernel-owner+w=401wt.eu-S1759127AbYH0Q6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127AbYH0Q6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbYH0Q54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:57:56 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42068 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247AbYH0Q5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:57:55 -0400
Date: Wed, 27 Aug 2008 12:57:53 -0400 (EDT)
From: Jan Engelhardt <jengelh@medozas.de>
To: jdike@linux.intel.com
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Is SKAS still required for UML
Message-ID: <alpine.LNX.1.10.0808271251170.1378@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


the UML page at http://user-mode-linux.sourceforge.net/old/skas.html 
mentions that "The UML kernel is present in the address space of each of 
its processes, and, by default, is writeable".

I tried to put this to a test, and actually failed to modify the 
UML kernel/memory image from within it. I had a simple kernel module 
with 'int val = 2;' and upon loading this, done printk("Val is at %p\n", 
&val); to get to know the address. A userspace program inside the UML 
then tried to dereference that address and read the value, but that 
ended in a segfault. /proc/xxx/maps also does not show the UML kernel 
being mapped in any process inside the UML. Note that I was running in 
SKAS0 mode, both host and guest are all 64-bit. Is the NX bit of the 
64-bit platform securing things off, or has SKAS3 become sort of 
obsolete?


Jan
