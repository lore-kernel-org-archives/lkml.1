Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbXKTIjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbXKTIjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 03:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbXKTIjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 03:39:02 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53336 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302AbXKTIjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 03:39:01 -0500
Date: Tue, 20 Nov 2007 00:38:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-cifs-client@lists.samba.org,
       samba-technical@lists.samba.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.24-rc2-mm1 - smbd write fails
Message-Id: <20071120003817.94cce1d9.akpm@linux-foundation.org>
In-Reply-To: <47429A7B.6040802@linux.vnet.ibm.com>
References: <47429A7B.6040802@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 13:57:39 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Andrew,
> 
> Following calltrace is seen server, while running filesystem stress on smb mounted partition on the client machine.
> 
> Nov 19 18:45:52 p55lp6 smbd[3304]: [2007/11/19 18:45:52, 0] lib/util_sock.c:write_data(562)
> Nov 19 18:45:52 p55lp6 smbd[3304]:   write_data: write failure in writing to client 9.124.111.212. Error Broken pipe
> Nov 19 18:45:52 p55lp6 smbd[3304]: [2007/11/19 18:45:52, 0] lib/util_sock.c:send_smb(769)
> Nov 19 18:45:52 p55lp6 smbd[3304]:   Error writing 39 bytes to client. -1. (Broken pipe)
> Nov 19 18:47:42 p55lp6 smbd[3650]: [2007/11/19 18:47:42, 0] smbd/oplock.c:oplock_timeout_handler(351)
> Nov 19 18:47:42 p55lp6 smbd[3650]:   Oplock break failed for file p0/d3XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
> XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/deX/d3cX/d6eXXX/f8d -- replying anyway
> Nov 19 18:47:42 p55lp6 kernel: [ 6960.261068] warning: process `smbd' gets w/ old libcap
> Nov 19 18:47:42 p55lp6 smbd[3650]: [2007/11/19 18:47:42, 0] smbd/oplock_linux.c:linux_release_kernel_oplock(193)
> Nov 19 18:47:43 p55lp6 smbd[3650]:   linux_release_kernel_oplock: Error when removing kernel oplock on file p0/d3XXXXXXXXXXXXXXXXXXXXXXX
> XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/deX/d3cX/d6eXXX/f8d, dev = 807, inode = 30983, file
> _id = 501. Error w
> Nov 19 18:48:04 p55lp6 smbd[3650]: [2007/11/19 18:48:04, 0] lib/util_sock.c:write_data(562)
> Nov 19 18:48:04 p55lp6 smbd[3650]:   write_data: write failure in writing to client 9.124.111.212. Error Connection reset by peer
> 

So you have samba running on a 2.6.24-rc2-mm1 machine and samba is failing
with the above messages?

