Return-Path: <linux-kernel-owner+w=401wt.eu-S1752907AbZKIGuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbZKIGuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 01:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbZKIGue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 01:50:34 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:45003 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbZKIGue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 01:50:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=x/tocG+6TKVK/duJeAPnBsoVHnCElHgVuc/JSp0jFY9afAuXeItWA9gICCzIHNVFOY
         AaUpzhnBrTKLxlnWJt2eSkoCrhU/GY3wO9UhgsQf36dnYYaB4fAN/DfsgEcM4iRNkWJG
         fdwgMf31X6vwE6E1v9st7q2OHagUKgRS2fZLQ=
From: Mark Veltzer <mark.veltzer@gmail.com>
Organization: veltzer.net
To: linux-kernel@vger.kernel.org
Subject: get_user_pages question
Date: Mon, 9 Nov 2009 08:50:25 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.30-1-686; KDE/4.3.2; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911090850.26724.mark.veltzer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all!

I have searched the list for similar issues and have not found an answer so I 
am posting.

I am using 'get_user_pages' and friends to get a hold of user memory in kernel 
space. User space passes buffer to kernel, kernel does get_user_pages, holds 
them for some time while user space is doing something else, writes to the 
pages and then releases them (SetPageDirty and page_cache_release as per LDD 
3rd edition). So far so good. 

I am testing this kernel module with several buffers from user space allocated 
in several different ways. heap, data segment, static variable in function and 
stack. All scenarious work EXCEPT the stack one. When passing the stack buffer 
the kernel sees one thing while user space sees another.

My not so intelligent questions (they may well be off the mark):
- How can this be? (two views of the same page)
- Does not 'get_user_pages' pin the pages?
- Could this be due to stack protection of some sort?
- Do I need to do anything extra with the vm_area I receive for the stack 
pages EXCEPT 'get_user_pages' ?

I know this is not an orthodox method to write a driver and I better use mmap 
for these things but I have other constrains in this driver design that I do 
not want to bore you with. I am also awara that passing a buffer on stack and 
letting user space continue running is a very dangerous thing to do for user 
space (or kernel space) integrity. I wish I could do it another way...

The platform is x86 32 bit standad with standard kernels and headers 
distributed with ubuntu 9.04 and 9.10 which are 2.6.28 and 2.6.31.

Please reply to my email as well as I am not a subscriber.

Cheers,
	Mark
