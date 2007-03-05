Return-Path: <linux-kernel-owner+w=401wt.eu-S933666AbXCEVxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666AbXCEVxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933664AbXCEVxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:53:19 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:47528 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933666AbXCEVxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:53:19 -0500
Message-ID: <45EC9129.7050903@cosmosbay.com>
Date: Mon, 05 Mar 2007 22:52:41 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] epoll use a single inode ...
References: <Pine.LNX.4.64.0703051311380.4907@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0703051311380.4907@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Mon, 05 Mar 2007 22:52:48 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi a écrit :
>  	 * using the inode number.
>  	 */
>  	error = -ENOMEM;
> -	sprintf(name, "[%lu]", inode->i_ino);
> +	sprintf(name, "[%p]", ep);
>  	this.name = name;
>  	this.len = strlen(name);

Small remark : you can avoid strlen(), since sprintf gives you the value :)

this.len = sprintf(name, "[%p]", ep);

Also, your patch description is not complete : you forgot to say that epoll 
dentries are not anymore hashed into global dcache hashtable :)

