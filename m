Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbYI2PFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbYI2PFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 11:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYI2PFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 11:05:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46056 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbYI2PFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 11:05:43 -0400
Date: Mon, 29 Sep 2008 11:05:39 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v9] Unified trace buffer
In-Reply-To: <20080927200028.GA28937@elte.hu>
Message-ID: <alpine.DEB.1.10.0809291048180.2625@gandalf.stny.rr.com>
References: <48DC406D.1050508@redhat.com> <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809261631420.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809262148070.30105@gandalf.stny.rr.com>
 <alpine.DEB.1.10.0809270203270.1628@gandalf.stny.rr.com> <20080927183912.GA13685@elte.hu> <alpine.DEB.1.10.0809271444460.11865@gandalf.stny.rr.com> <20080927194105.GF18619@elte.hu> <alpine.DEB.1.10.0809271549160.16572@gandalf.stny.rr.com>
 <20080927200028.GA28937@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 27 Sep 2008, Ingo Molnar wrote:
> 
> > > no, it is not readable. My point was that you should do:
> > > > 
> > > >    RB_ENUM_TYPE,	/*
> > > > 			 * Comment
> > > > 			 */
> > > > 
> > > > The comment is not at the same line as the enum, which also looks 
> > > > unpleasing.
> > > 
> > > but you did:
> > > 
> > > >    RB_ENUM_TYPE,	/* Comment
> > > > 			 */
> > > 

OK, I did a quick survey of what others did in include/linux to handle 
multi line comments for enums. I ignored the single line comments since 
that is pretty standard. Here's what I found:

Those that do:

enum myenum {
	ENUM_PING_PONG,		/* Bounce a ball back and forth
				   till you have a winner. */
	ENUM_HONEY_CONE,	/* Soft and sweet a yummy for
				   the tummy. */
};

include/linux/atmdev.h
include/linux/fd.h
include/linux/hil.h
include/linux/if_pppol2tp.h
include/linux/ivtv.h
include/linux/libata.h
include/linux/mmzone.h
include/linux/reiserfs_fs.h
include/linux/reiserfs_fs_sb.h
include/linux/rtnetlink.h
include/linux/scc.h
include/linux/videodev2.h

Those that do:

enum myenum {
        ENUM_PING_PONG,         /* Bounce a ball back and forth */
                                /* till you have a winner.      */
        ENUM_HONEY_CONE,        /* Soft and sweet a yummy for   */
                                /* the tummy.                   */
};

include/linux/atmsvc.h
include/linux/pktcdvd.h


Those that do (what I did):

enum myenum {
        ENUM_PING_PONG,         /* Bounce a ball back and forth
                                 * till you have a winner.
				 */
        ENUM_HONEY_CONE,        /* Soft and sweet a yummy for
                                 * the tummy.
				 */
};

include/linux/buffer_head.h (with space between the two enums)
include/linux/personality.h


Those that do:

enum myenum {
	/*
	 * Bounce a ball back and forth
	 * till you have a winner.
	 */
        ENUM_PING_PONG,
	/*
	 * Soft and sweet a yummy for
	 * the tummy.
	 */
        ENUM_HONEY_CONE,
};

include/linux/cgroup.h
include/linux/cn_proc.h
include/linux/exportfs.h
include/linux/fb.h
include/linux/hil_mlc.h
include/linux/pci.h
include/linux/reiserfs_fs_i.h


And finally Doc book style:

/**
 * enum myenum
 * @ENUM_PING_PONG: Bounce a ball back and forth
 *                  till you have a winner.
 * @ENUM_HONEY_CONE: Soft and sweet a yummy for
 *                   the tummy.
 */
enum myenum {
	ENUM_PING_PONG,
	ENUM_HONEY_CONE,
};

Note I did not see any enum users that did what you asked:

enum myenum {
        ENUM_PING_PONG,		/*
				 * Bounce a ball back and forth
				 * till you have a winner.
				 */
        ENUM_HONEY_CONE,	/*
				 * Soft and sweet a yummy for
				 * the tummy.
				 */
};

So by adding that, I will be adding yet another format.

Actually I think the docbook style is the most appropriate for me. I'll go 
with that one.

Thanks,

-- Steve

