Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbYBPGAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbYBPGAY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 01:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYBPGAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 01:00:11 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59220 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751612AbYBPGAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 01:00:09 -0500
Date: Fri, 15 Feb 2008 21:59:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nadia.Derbey@bull.net
Cc: linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com, linux-mm@kvack.org,
       containers@lists.linux-foundation.org, matthltc@us.ibm.com,
       cmm@us.ibm.com
Subject: Re: [PATCH 1/8] Scaling msgmni to the amount of lowmem
Message-Id: <20080215215916.8566d337.akpm@linux-foundation.org>
In-Reply-To: <20080211141813.354484000@bull.net>
References: <20080211141646.948191000@bull.net>
	<20080211141813.354484000@bull.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 15:16:47 +0100 Nadia.Derbey@bull.net wrote:

> [PATCH 01/08]
> 
> This patch computes msg_ctlmni to make it scale with the amount of lowmem.
> msg_ctlmni is now set to make the message queues occupy 1/32 of the available
> lowmem.
> 
> Some cleaning has also been done for the MSGPOOL constant: the msgctl man page
> says it's not used, but it also defines it as a size in bytes (the code
> expresses it in Kbytes).
> 

Something's wrong here.  Running LTP's msgctl08 (specifically:
ltp-full-20070228) cripples the machine.  It's a 4-way 4GB x86_64.

http://userweb.kernel.org/~akpm/config-x.txt
http://userweb.kernel.org/~akpm/dmesg-x.txt

Normally msgctl08 will complete in a second or two.  With this patch I
don't know how long it will take to complete, and the machine is horridly
bogged down.  It does recover if you manage to kill msgctl08.  Feels like
a terrible memory shortage, but there's plenty of memory free and it isn't
swapping.

