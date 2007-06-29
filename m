Return-Path: <linux-kernel-owner+w=401wt.eu-S932773AbXF2C5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773AbXF2C5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 22:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765187AbXF2C5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 22:57:09 -0400
Received: from smtpout.mac.com ([17.250.248.175]:57775 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765091AbXF2C5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 22:57:08 -0400
In-Reply-To: <send-serie.davidel@xmailserver.org.5792.1183056564.0>
References: <send-serie.davidel@xmailserver.org.5792.1183056564.0>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <EC4CE052-5514-465E-92D2-9D50DA970DDC@mac.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>, Andy Isaacson <adi@hexapodia.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [patch 0/4] MAP_NOZERO v2 - VM_NOZERO/MAP_NOZERO early summer madness
Date: Thu, 28 Jun 2007 22:57:00 -0400
To: Davide Libenzi <davidel@xmailserver.org>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 28, 2007, at 14:49:24, Davide Libenzi wrote:
> I was using oprofile to sample some userspace code I am working on,  
> and I was continuosly noticing  clear_page  in the top three  
> entries of the oprofile logs.
>
> Also, a simple kernel build, in my Dual Opteron with 8GB of RAM,  
> shows  clear_page  as the first kernel entry, second only to the  
> userspace the  cc1  and  as. Most of the userspace code uses malloc 
> () (and anonymous  mappings) in such a way that the memory returned  
> via kernel->glibc is immediately written soon after. The POSIX  
> malloc() definition itself also, does not require the returned  
> memory to be zeroed (as calloc() does).
>
> So I implemented a rather quick hack that introduces a new mmap()  
> flag MAP_NOZERO (only valid for anonymous mappings) and the  vma   
> counter-part VM_NOZERO. Also, a new sys_brk2() has been introduced  
> to accept a new flags  parameter. A brief description of the  
> patches follows in the next emails.

Hmm, sounds like this would also need a "MAP_NOREUSE" flag of some  
kind for security sensitive applications.  Basically, I wouldn't want  
my ssh-agent pages holding private SSH keys to be reused by my web  
browser which then gets exploited :-D.  It would also be a massive  
information leak under SELinux.  To fix it properly according to the  
SELinux model you would need to tag each page with a label  
immediately after it's freed and then do an access-vector-check  
against the old page and the new process before allowing reuse.  On  
the other hand, that would probably be at least as expensive as  
zeroing the page.

Cheers,
Kyle Moffett



