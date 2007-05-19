Return-Path: <linux-kernel-owner+w=401wt.eu-S1759186AbXESJmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186AbXESJmK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 05:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755946AbXESJl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 05:41:56 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:56212 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094AbXESJly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 05:41:54 -0400
Date: Sat, 19 May 2007 11:24:21 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Rob Landley <rob@landley.net>
cc: Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?q?J=F6rn_Engel?= <joern@lazybastard.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
In-Reply-To: <200705190215.36334.rob@landley.net>
Message-ID: <Pine.LNX.4.61.0705191119330.9015@yvahk01.tjqt.qr>
References: <20070515151919.GA32510@lazybastard.org>
 <20070515133759.9ee434a2.akpm@linux-foundation.org> <200705190215.36334.rob@landley.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 19 2007 02:15, Rob Landley wrote:
>> > +
>> > +static inline struct logfs_inode *LOGFS_INODE(struct inode *inode)
>> > +{
>> > +	return container_of(inode, struct logfs_inode, vfs_inode);
>> > +}
>> 
>> Do these need to be uppercase?
>
>I'm trying to keep it clear in my head...
>
>When do you need to say __always_inline and when can you get away with 
>just saying "static inline"?

When using "static inline", the compiler may ignore the inline keyword 
(it's just a hint), and leave the function as a standalone function.

When CONFIG_FORCED_INLINING is active, and it is by default, inline is 
always substituted by __always_inline, to be on the safe side. Some code 
needs to be always inline; but not all code has been checked whether it 
is safe to go from __always_inline to inline.


	Jan
-- 
