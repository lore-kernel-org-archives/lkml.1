Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbXJHOln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbXJHOln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 10:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbXJHOlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 10:41:36 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:55863 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbXJHOle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 10:41:34 -0400
Date: Mon, 8 Oct 2007 10:41:02 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] [RFC] RT: Optionally allow IRQF_NODELAY on serial
 console
In-Reply-To: <1191853361.4281.5.camel@ghaskins-t60p.haskins.net>
Message-ID: <Pine.LNX.4.58.0710081037420.5290@gandalf.stny.rr.com>
References: <20071005153517.24349.62653.stgit@ghaskins-t60p.haskins.net> 
 <alpine.LRH.0.999.0710051831000.10191@www.tglx.de> 
 <Pine.LNX.4.58.0710081005320.4846@gandalf.stny.rr.com>
 <1191853361.4281.5.camel@ghaskins-t60p.haskins.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Mon, 8 Oct 2007, Gregory Haskins wrote:
>
> Hi Steve,
>   What you describe is exactly what I did.  The IRQF_NODELAY handler
> just minimally checks to see if the character is a sysrq related one (or
> KDB, if you have the KDB patches applied).  If it is not, it puts the
> character into a ring-buffer and wakes a (kthread-based) tasklet to do
> the normal serial/tty rx path by processing the ring.

Ah, that was in the second patch (I didn't look at that. My fault). I
didn't see this description in the comments. But you are right, it is very
close to what I did too. But before we add this to -rt, it will need to
probably need to be tested quite a bit more. Especially since this is more
to help us developers than to help end users.

I would like to see something like this eventually make it into RT.  Just
because there has been too many times that this would be useful. For now I
just use the NMI watchdog and soft lockup detect. But those are very
limiting.

>
> Hope that helps to clarify.

Yes, thanks!

-- Steve

