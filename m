Return-Path: <linux-kernel-owner+w=401wt.eu-S1753073AbXDMChp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbXDMChp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 22:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbXDMChp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 22:37:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24574 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbXDMCho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 22:37:44 -0400
Date: Thu, 12 Apr 2007 19:38:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Christopher S. Aker" <caker@theshore.net>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [Feature Request?] Inline compression of process core dumps
Message-Id: <20070412193838.ea98238b.randy.dunlap@oracle.com>
In-Reply-To: <461EE95A.3090600@theshore.net>
References: <461E55C6.1030905@theshore.net>
	<20070412172845.58bfeff5@the-village.bc.nu>
	<20070412164251.GC11736@ti88.telemetry-investments.com>
	<p73ps697agf.fsf@bingen.suse.de>
	<461EE95A.3090600@theshore.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007 22:22:18 -0400 Christopher S. Aker wrote:

> Alan Cox wrote:
>  > Indeed. So useful that in current kernels you can set the core dump
>  > path to be
>  >
>  > 	"|application"
> 
> Cool stuff!  However, it's not working (2.6.20.6):
> 
> 	Core dump to |/home/caker/bin/dumper.pl.4442 pipe failed
> 
> even though...
> 
> 	# cat /proc/sys/kernel/core_uses_pid
> 	0
> 	# cat /proc/sys/kernel/core_pattern
> 	|/home/caker/bin/dumper.pl
> 
> Looking at the code, it seems to me that format_corename() is appending 
> .pid, regardless if !core_uses_pid and corename[0]=='|', in which case 
> it creates an invalid path for call_usermodehelper_pipe().
> 
> Bug in the code, or bug in my methods?

What are you trying to dump?  is it a multi-thread group app,
not a "simple" app?  I ask because of this (I'm looking at 2.6.21-rc6)
<mm_users> reference (not that I know what that is):

	if (!pid_in_pattern
            && (core_uses_pid || atomic_read(&current->mm->mm_users) != 1)) {
		rc = snprintf(out_ptr, out_end - out_ptr,
			      ".%d", current->tgid);
		if (rc > out_end - out_ptr)
			goto out;
		out_ptr += rc;
	}

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
