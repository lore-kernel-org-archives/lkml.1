Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbXCWOSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbXCWOSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbXCWOSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:18:45 -0400
Received: from twin.jikos.cz ([213.151.79.26]:56376 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbXCWOSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:18:45 -0400
Date: Fri, 23 Mar 2007 15:18:33 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Tomas M <tomas@slax.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] [bugfix] loop.c
In-Reply-To: <4603DE86.1090009@slax.org>
Message-ID: <Pine.LNX.4.64.0703231514000.5030@twin.jikos.cz>
References: <4603DE86.1090009@slax.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007, Tomas M wrote:

> This is a bugfix for loop.c block driver, as it currently allocates more 
> memory then it needs, without any further use.
> If 'max_loop=255' parameter is given, the loop.c driver allocates this 
> amount of memory:
>   kmalloc(max_loop * sizeof(struct loop_device))
> But in this case, (max_loop * sizeof) is greater than 65536, and thus kmalloc
> must allocate the next bigger size (which is 128KB of RAM).

Which is very unlikely to work after some time of uptime, as the memory 
will be too fragmented to successfully kmalloc(128k). I guess that the 
code should be rather rewritten not to allocate such large contignuous 
chunks of memory through kmalloc().

-- 
Jiri Kosina
