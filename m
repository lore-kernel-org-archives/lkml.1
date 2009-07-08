Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbZGHRDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbZGHRDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 13:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbZGHRDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 13:03:17 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:52704 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbZGHRDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 13:03:17 -0400
Message-ID: <4A54D14F.9090101@petalogix.com>
Date: Wed, 08 Jul 2009 19:03:11 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
       lkml <linux-arch@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arnd Bergmann <arnd@arndb.de>, Paul Mundt <lethal@linux-sh.org>,
       LTP <ltp-list@lists.sourceforge.net>
Subject: mmap hw behavior
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I wrote one email about my problem with mmap on Microblaze. (Especially
mmap01 ltp test)
I need to know how mmap should work with MMU or what the correct steps are.

When I open temp file in application is the kernel create file descriptor table and kernel take
care about setup tlb which are needed. Application get back just file descriptor.

When I call calloc it is called brk kernel syscall and is created one tlb for this place. 
Brk allocate more memory than is requested by calloc. Application got pointer to that memory place.


When I call mmap for that open file with pointer to calloc place (first parameter, + length zero)
it should be one tlb invalidation for calloc and new tlb which connect open file. 
We check it and we don't have any tlb invalidation that's why I think that kernel do different thigs.
Or is it there any copying? Or anything different?

Thanks for clarification,
Michal

-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

