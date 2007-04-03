Return-Path: <linux-kernel-owner+w=401wt.eu-S1422641AbXDCSwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422641AbXDCSwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 14:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422649AbXDCSwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 14:52:00 -0400
Received: from tayrelbas03.tay.hp.com ([161.114.80.246]:34049 "EHLO
	tayrelbas03.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422641AbXDCSv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 14:51:59 -0400
X-Greylist: delayed 682 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Apr 2007 14:51:59 EDT
Message-ID: <46129F83.3070505@hp.com>
Date: Tue, 03 Apr 2007 14:40:03 -0400
From: Kris Corwin <Kris.Corwin@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20050920
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] fix illogical behavior in balance_dirty_pages()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Apr 2007 18:40:17.0499 (UTC) FILETIME=[867162B0:01C7761F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think I'm seeing the same VM behavior with NFS/ext3 that was described 
with fuse.

I have a shared storage unit with 2 servers.  The local filesystem is 
ext3 and I'm failing
the ext3 mounting and NFS serving from one node to another.  I'm running 
I/O on the NFS
mount point to the active server.   If I failover to the server that is 
also executing the I/O,
I can hang the machine.  Looking at the stack traces, the NFS writes are 
stuck in
balance_dirty_pages().  NFS start up is causing rpc.mountd to write to 
the local
ext3 filesystem, but it gets blocked in balance_dirty_pages() too.  
Deadlock.  Without
the NFS server successfully started, the kernel can't write the dirty pages.

I'm running a 2.6.9-42 RH kernel.  Early in my debugging, I had tried 
several kernel
versions.  All 2.6 kernels saw this behavior and the 2.4 kernel I tried 
did not.

Kris Corwin
