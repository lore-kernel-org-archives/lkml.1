Return-Path: <linux-kernel-owner+w=401wt.eu-S1751516AbYJSFBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbYJSFBH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 01:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbYJSFAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 01:00:55 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:52929 "EHLO
	QMTA10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750698AbYJSFAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 01:00:54 -0400
X-Authority-Analysis: v=1.0 c=1 a=D6x46cGcf2AA:10 a=iCY7fnX7vt0A:10
 a=UCmEzY_7EAr7ZirZUpcA:9 a=NPoMHY1VRqJrFUbnt8r1iLBr6SoA:4 a=50e4U0PicR4A:10
Subject: Re: [RFC PATCH 1/21] relay - Clean up relay_switch_subbuf() and
	make waking up consumers optional.
From: Tom Zanussi <zanussi@comcast.net>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, Jens Axboe <jens.axboe@oracle.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
In-Reply-To: <48F9A441.3030400@cs.helsinki.fi>
References: <1224137126.16328.220.camel@charm-linux>
	 <48F9A441.3030400@cs.helsinki.fi>
Content-Type: text/plain
Date: Sun, 19 Oct 2008 00:00:48 -0500
Message-Id: <1224392448.7234.16.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Sat, 2008-10-18 at 11:54 +0300, Pekka Enberg wrote:
> Hi Tom,
> 
> Tom Zanussi wrote:
> > +static inline void relay_update_filesize(struct rchan_buf *buf, size_t length)
> > +{
> > +	if (buf->dentry)
> > +		buf->dentry->d_inode->i_size +=	length;
> > +	else
> > +		buf->early_bytes += length;
> > +
> > +	smp_mb();
> > +}
> 
> A minor nit: you should probably add a comment for that memory barrier. 
> That is, explain why it is needed. It makes a world of a difference to 
> anyone trying to understand what's going on here.

You're right, but it actually goes away in one of the following patches.

I'm wondering whether it even makes sense to post the individual patches
or instead just the full squashed patch and/or the end-result files,
which are really the things it would useful to review.

I've made some new changes following more testing and actually plan to
post another round sometime soon - I'll probably skip posting the
individual patches then unless it makes sense to.

Thanks for the comments.

Tom

