Return-Path: <linux-kernel-owner+w=401wt.eu-S1764021AbXESR2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764021AbXESR2k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 13:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762441AbXESR23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 13:28:29 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:40597
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763899AbXESR22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 13:28:28 -0400
From: Rob Landley <rob@landley.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] LogFS take three
Date: Sat, 19 May 2007 13:26:30 -0400
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?q?J=F6rn_Engel?= <joern@lazybastard.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
References: <20070515151919.GA32510@lazybastard.org> <200705190215.36334.rob@landley.net> <Pine.LNX.4.61.0705191119330.9015@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705191119330.9015@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705191326.31932.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 May 2007 5:24 am, Jan Engelhardt wrote:
> 
> On May 19 2007 02:15, Rob Landley wrote:
> >> > +
> >> > +static inline struct logfs_inode *LOGFS_INODE(struct inode *inode)
> >> > +{
> >> > +	return container_of(inode, struct logfs_inode, vfs_inode);
> >> > +}
> >> 
> >> Do these need to be uppercase?
> >
> >I'm trying to keep it clear in my head...
> >
> >When do you need to say __always_inline and when can you get away with 
> >just saying "static inline"?
> 
> When using "static inline", the compiler may ignore the inline keyword 
> (it's just a hint), and leave the function as a standalone function.
> 
> When CONFIG_FORCED_INLINING is active, and it is by default, inline is 
> always substituted by __always_inline, to be on the safe side. Some code 
> needs to be always inline; but not all code has been checked whether it 
> is safe to go from __always_inline to inline.

I've seen patches go by using __always_inline directly.  Is there some 
janitorial effort to examine each instance of the the inline keyword and 
either replace it with "__always_inline" or remove it?

Right now "inline" seems to be about as useful as the "register" keyword.  You 
don't feed hints to a compiler like gcc, you hit it with a two-by-four and 
thumbscrews if you want to get its' attention.

Rob
