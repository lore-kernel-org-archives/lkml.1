Return-Path: <linux-kernel-owner+w=401wt.eu-S1761309AbXLRR2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761309AbXLRR2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 12:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbXLRR2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 12:28:43 -0500
Received: from main.gmane.org ([80.91.229.2]:45948 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174AbXLRR2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 12:28:42 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matthew Bloch <matthew@bytemark.co.uk>
Subject: Testing RAM from userspace / question about memmap= arguments
Date: Tue, 18 Dec 2007 17:06:24 +0000
Message-ID: <fk8umh$n7o$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: desk2.office.bytemark.co.uk
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi - I'm trying to come up with a way of thoroughly testing every byte
of RAM from within Linux on amd64 (so that it can be automated better
than using memtest86+), and came up with an idea which I'm not sure is
supported or practical.

The obvious problem with testing memory from user space is that you
can't mlock all of it, so the best you can do is about three quarters,
and hope that the rest of the memory is okay.

In order to test all of the memory, I'd like to run the user-space
memtester over two boots of the kernel.

Say we have a 1024MB machine, the first boot I'd not specify any
arguments and assume the kernel would start at the bottom of physical
memory and work its way up, so that the kernel & working userspace would
live at the bottom, and the rest would be testable from space.

On the second boot, could I then specify:

memmap=exact memmap=512M@512M memmap=512M@0

i.e. such that the kernel's idea of the usable memory started in the
middle of physical RAM, and that's where it would locate itself?  That
way, on the second boot, the same test in userspace would definitely
grab the previously inaccessible RAM at the start for testing.

I can see a few potential problems, but since my understanding of the
low-level memory mapping is muddy at best, I won't speculate; I'd just
appreciate any more expert views on whether this does work, or could be
made to work.

Thanks,

-- 
Matthew

