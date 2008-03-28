Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbYC1MQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbYC1MQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbYC1MQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:16:50 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:22374 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbYC1MQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:16:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=WYNwChi+hkSho5rYvJEF1vNL1wVzorY3QjqUwv0w2RKjxpEnn07AASCADFoMRh+caPpkmO4lzHaYjbTT/xBElIBx40FcX3Dks6kDJyNx1oJC4dMgrO1lB6wQSwEbIQAyQIPNijK8Hz+N98Tkd2dXhPdis73l9CZ3CcSNdx3fJ+A=
Date: Fri, 28 Mar 2008 13:16:43 +0100
To: Russell King <linux@arm.linux.org.uk>
Cc: Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: ARM (sa1110) Bootloader woes (BLOB) - stops after extraction
Message-Id: <20080328131643.c8dcba72.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Flashed blob(after some patching) onto the newly developed j7xx flashrom, it works resonably well. However when loading kernel produces nothing more than the extraction finishing (then nada).

As you can see it loads the kernel onto 0xc0300000 (just wanted to get it out of way) and it jumps there at bootup.

The call to the linux kernel is done through declaration.
void (*thekernel) (int zero, int arch, u32 params) = (void (*)(int, int u32))blob_status.kernel.addr;

I've read all the ARM boot documentation and I believe I should turn off mmu and put proper values into
r0, r1, r2. But My question is rather if anyone else can spot anything else I need doing and what bootloader "demands" changed between 2.4 and 2.6 (since this bootloader "should" boot 2.4 without issues)?

zreladdr is set to 0xc0008000, but that is where the kernel should extract to, right?

bootlog:
--------
Starting kernel ...                                                             
                                                      
Uncompressing Linux.............................................................

Various Blob outputs:
---------------------
Memory map:                                                                     
  0x04000000 @ 0xc0000000 (64 MB)                                               
ELF sections layout:                                                            
  0xc0200800 - 0xc02136c0  .text                                                
  0xc02136c0 - 0xc0215b70  .rodata                                              
  0xc0215b70 - 0xc021646c  .data                                                
  0xc021646c - 0xc021646c  .got                                                 
  0xc021646c - 0xc02165c0  .commandlist                                         
  0xc02165c0 - 0xc0216680  .initlist                                            
  0xc0216680 - 0xc021668c  .exitlist                                            
  0xc021668c - 0xc02166bc  .ptaglist                                            
  0xc02166bc - 0xc021bbac  .bss                                                 
  0xc0219bac - 0xc021bbac  .stack (in .bss)                                     
Current stack pointer: 0xc021ba84

Partition table for 65344 kB flash @ 0x00000000:                                
  0x00020000 @ 0x00000000 (128 kB): 'blob'                                      
    load at 0xc0100000                                                          
  0x00020000 @ 0x00020000 (128 kB): 'param'                                     
    contains parameter blocks                                                   
  0x00300000 @ 0x00040000 (3072 kB): 'kernel'
  load at 0xc0300000                                                          
  entry point at 0xc0300000, automatically execute                            
  0x03c90000 @ 0x00340000 (62016 kB): 'ramdisk'         

