Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbZCDW5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbZCDW5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 17:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbZCDW5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 17:57:38 -0500
Received: from gw.goop.org ([64.81.55.164]:49371 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980AbZCDW5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 17:57:38 -0500
Message-ID: <49AF075D.9070607@goop.org>
Date: Wed, 04 Mar 2009 14:57:33 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: __virt_addr_valid vs virtual percpu areas
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On i386, __virt_addr_valid() has the test:

	if (system_state != SYSTEM_BOOTING && is_vmalloc_addr((void *) x))
		return false;


Why is the vmalloc area a valid virtual address while the system is 
booting?  This is biting me because I need to translate percpu addresses 
to pfns, but I only bother doing the full pagetable walk if 
virt_addr_valid() is false (otherwise I just use __pa()).

Removing this test doesn't seem to harm anything at first glance.  Is 
this OK to do in general (and can we quietly set fire to system_state 
while we're about it)?

Thanks,
    J

