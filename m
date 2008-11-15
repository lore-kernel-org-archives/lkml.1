Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbYKODXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbYKODXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 22:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbYKODXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 22:23:15 -0500
Received: from main.gmane.org ([80.91.229.2]:57451 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbYKODXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 22:23:14 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.27.6 question: ata_sff_hsm_move: ata15 (why always ata15)?
Date: Fri, 14 Nov 2008 21:22:58 -0600
Message-ID: <491E4092.5030804@shaw.ca>
References: <alpine.DEB.1.10.0811141850590.6217@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
In-Reply-To: <alpine.DEB.1.10.0811141850590.6217@p34.internal.lan>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> I am trying to find out what the root cause of this error/problem is:
> https://bugzilla.redhat.com/show_bug.cgi?id=462425

The problem is that people assume that timeouts with DRDY like that bug 
refers to must be the same problem when it is often not, and so bug 
reports like this end up conflated with all manner of different issues. 
It's one of the most generic errors imaginable. Also, as one of the 
posters mentions, "I think this problem tends to get ignored because 
there are so many things that can cause it (bad drives, cables, power 
supplies, or any combination thereof).."  Just because older kernels did 
work doesn't necessarily prove anything, if they didn't do NCQ (which in 
the Marvell case, I think older kernels didn't) or are pushing the disk 
subsystem harder this may expose hardware issues that didn't show up on 
older kernels.

One really needs to isolate individual problems and try some hardware 
debugging before looking into the kernel for such problems..

> 
> It seems like every week or other week someone else reports this on the 
> linux-raid mailing list.
> 
> I have enabled debugging in the libata.h file and I find that ata15 is 
> constantly being accessed for some reason, why is this?

Presumably ata15 is the port the DVD-RW is connected to, likely HAL is 
polling for media or something..

