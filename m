Return-Path: <linux-kernel-owner+w=401wt.eu-S1762533AbZAHUBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762533AbZAHUBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756358AbZAHUBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:01:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37070
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755597AbZAHUA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:00:59 -0500
Date: Thu, 08 Jan 2009 12:01:01 -0800 (PST)
Message-Id: <20090108.120101.182003946.davem@davemloft.net>
To: jack@suse.cz
Cc: torvalds@linux-foundation.org, chris.mason@oracle.com,
       akpm@linux-foundation.org, peterz@infradead.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, npiggin@suse.de
Subject: Re: Increase dirty_ratio and dirty_background_ratio?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090108195728.GC14560@duck.suse.cz>
References: <1231433701.14304.24.camel@think.oraclecorp.com>
	<alpine.LFD.2.00.0901080858500.3283@localhost.localdomain>
	<20090108195728.GC14560@duck.suse.cz>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>
Date: Thu, 8 Jan 2009 20:57:28 +0100

>   But I think there are workloads for which this is suboptimal to say the
> least. Imagine you do some crazy LDAP database crunching or other similar load
> which randomly writes to a big file (big means it's size is rougly
> comparable to your available memory). Kernel finds pdflush isn't able to
> flush the data fast enough so we decrease dirty limits. This results in
> even more agressive flushing but that makes things even worse (in a sence
> that your application runs slower and the disk is busy all the time anyway).
> This is the kind of load where we observe problems currently.

I'm pretty sure this is what I see as well.

If you just barely fit your working GIT state into memory, and you are
not using "noatime" on that partition, doing a bunch of git operations
is just going to trigger all of this forced and blocking writeback on
the atime dirtying of the inodes, and this will subsequently grind
your machine to a halt if your disk is slow.
