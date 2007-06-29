Return-Path: <linux-kernel-owner+w=401wt.eu-S1754386AbXF2Tye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbXF2Tye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 15:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbXF2Ty1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 15:54:27 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:40128 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbXF2Ty0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 15:54:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=J4jzX6k6KpP0rEYRp5l9/+n7XKw1lcSo8hKG4jI2ypumiCut1uYL38YwMpOXyrfCibHeXDZ2SoZUIv3bhWkIW0tIcHQFGXTYvBZi4cj5Z7x4TvY93mOVZRaYcXOSnE0o+94Zg18WUIDJhmecdB0GT8WwR8zHEy94U8kv/yQVkqA=
Message-ID: <468562F6.4010604@gmail.com>
Date: Fri, 29 Jun 2007 14:52:22 -0500
From: William Tambe <tambewilliam@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Concerning a post that you made about expandable anonymous shared
 mappings
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I read a post that you made about not being able to expand anonymous 
shared mapping with mremap(). And I am actually having that issue now.

You made the post in 2004 and we are now in 2007. I would like to know 
if that feature was added because the code below always fail with bus 
error on my machine. I use glibc 2.5

Thank you for helping.

#define _GNU_SOURCE
#include <sys/mman.h>
#include <unistd.h>

#include <stdio.h>

main() {
         void *ptr;
         if ((ptr=mmap(0, 4096, PROT_READ|PROT_WRITE,
                 MAP_ANONYMOUS|MAP_SHARED|MAP_GROWSDOWN, 0, 0)) == -1) {
                 printf("failed to mmap\n");
                 return;
         }

         if ((ptr=mremap(ptr, 4096, 8192, MREMAP_MAYMOVE)) == -1) {
                 printf("failed to mremap\n");
                 return;
         }

         //why does this failed. I am well in the interval [4096, 8192]
         *(unsigned int *)(ptr + 4096 + 8)= 10;
}
