Return-Path: <linux-kernel-owner+w=401wt.eu-S1759507AbXKGSbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507AbXKGSbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbXKGSbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:31:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51799 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753578AbXKGSbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:31:14 -0500
Date: Wed, 7 Nov 2007 10:30:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>
Subject: Re: 2.6.24-rc2=another train wreck with amanda
Message-Id: <20071107103028.f5166fd3.akpm@linux-foundation.org>
In-Reply-To: <200711070649.02136.gene.heskett@gmail.com>
References: <200711070649.02136.gene.heskett@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 07 Nov 2007 06:49:01 -0500 Gene Heskett <gene.heskett@gmail.com> wrote:
> Greetings;
> 
> I have this line in my /etc/modprobe.conf:
> options dm-mod major=238
> 
> And I had a fsckup while building 2.6.24-rc2 cuz I thought it needed to be 
> based on 2.6.23.1 that has made 2.6.24-rc2 the only kernel that will boot 
> without a panic, killing init message.
> 
> I can survive that, but amanda (tar) went bonkers last night and tried to do a 
> level 0 on everything, which is about 50GB, but its virtual tape size is only 
> 11GB.
> 
> The last time this happened that line above fixed the device mapper to a 
> stable address at a major of 238 which tar was happy with.
> 
> An ls -l of /dev/mapper:
> [root@coyote /]# ls -l /dev/mapper
> total 0
> crw------- 1 root root  10, 62 Nov  6 23:40 control
> brw-rw---- 1 root disk 238,  0 Nov  6 23:40 VolGroup00-LogVol00
> brw-rw---- 1 root disk 238,  1 Nov  6 23:40 VolGroup00-LogVol01
> 
> So that hasn't changed, so what did?  Amanda itself hasn't been changed in 
> several months, running the 20070727 snapshot of amanda-2.5.2p1 all this 
> time.  Tar was updated by smart or yumex 2 or 3 days back, so it worked 
> correctly after the update.  That leaves something in 2.6.24-rc2.  I didn't 
> build rc1.
> 
> Other than that, rc2 seems stable.  But auditd failed to start in the bootup 
> sequence. I think that's minor and may predate this particular kernel.  
> However, selinux did a relabel before it booted, could that be the cause?
> 

An selinux relabelling could well have caused a full backup by amanda.

There's a way of forcing a relabelling so that you can confirm this, but I
forget what it is (cc's added, please).

But we don't know why the relabelling happened, do we?
