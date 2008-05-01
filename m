Return-Path: <linux-kernel-owner+w=401wt.eu-S932419AbYEAWP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbYEAWP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761524AbYEAWPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:15:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761515AbYEAWPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:15:22 -0400
Date: Thu, 1 May 2008 15:15:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: adobriyan@gmail.com, linux-kernel@vger.kernel.org, lucho@ionkov.net,
       ericvh@gmail.com, mingo@elte.hu
Subject: Re: [PATCH] fix flags length in net 9p
Message-Id: <20080501151500.1afbd227.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.58.0805011748270.12785@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0805011706070.12785@gandalf.stny.rr.com>
	<20080501141919.78b7dc4f.akpm@linux-foundation.org>
	<20080501222950.GA16470@martell.zuzino.mipt.ru>
	<Pine.LNX.4.58.0805011748270.12785@gandalf.stny.rr.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 17:50:38 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> 
> 
> > +		typecheck(unsigned long, flags);

ooh, I'd forgotten about typecheck.

Just use typecheck.  The BUILD_BUG_ON is overkill.

> We can simply have all users of flags use the new irqflags_t type, and
> just do a one time big patch (grant you, that would break all pending
> patches before that). But we can also write up a script that can convert
> patches as well.

y:/usr/src/linux-2.6.25> grep -rl 'unsigned long flags' . | wc -l
2311

eargh.  I agree with me.
