Return-Path: <linux-kernel-owner+w=401wt.eu-S1761460AbYAHQ0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761460AbYAHQ0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761313AbYAHQ0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:26:10 -0500
Received: from smtp28.orange.fr ([80.12.242.99]:6574 "EHLO smtp28.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761279AbYAHQ0J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:26:09 -0500
X-ME-UUID: 20080108162607564.015B880000BE@mwinf2802.orange.fr
Message-ID: <4783A41B.1090100@cosmosbay.com>
Date: Tue, 08 Jan 2008 17:26:03 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Changli Gao <xiaosuo@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Improve scalability of epoll_ctl
References: <478397F7.1030005@gmail.com>
In-Reply-To: <478397F7.1030005@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changli Gao a ¨¦crit :
> Replace the epitem rbtree with a dynamic array to get the constant insertion/deletion/modification time of the file descriptors. Reuse the size argument of epoll_create, however the size must be smaller than the max file descriptor number: ether the resource limitation or the compiling time limitation.
>
>   
Hum, you should read this :

http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.7-rc3/2.6.7-rc3-mm2/broken-out/epoll-uses-rbtrees.patch


Your patch is a revert of this change, it probably wont be accepted.

epoll_ctl() is scalable, since it's O(log2(N)) : With 1 millions files
descriptors, that means less than 20 nodes to lookup in the tree.

In what situation do you think epoll_ctl() performance is bad ?





