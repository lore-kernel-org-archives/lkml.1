Return-Path: <linux-kernel-owner+w=401wt.eu-S1751582AbXJ1FmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbXJ1FmA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 01:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbXJ1Flw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 01:41:52 -0400
Received: from web36612.mail.mud.yahoo.com ([209.191.85.29]:39821 "HELO
	web36612.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750705AbXJ1Flu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 01:41:50 -0400
X-YMail-OSG: ZzKx8cgVM1nloEZb8xsHSSAJhFJwVA4py9AgnloLTxlZTFk4OuwgInYAMlZqReQ5ASloeVKw3w--
X-RocketYMMF: rancidfat
Date: Sat, 27 Oct 2007 22:41:49 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 2/2] Version 9 (2.6.24-rc1) Smack: Simplified Mandatory Access Control Kernel
To: Al Viro <viro@ftp.linux.org.uk>, "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: casey@schaufler-ca.com, akpm@osdl.org, torvalds@osdl.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071027234719.GU8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <833827.6337.qm@web36612.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Al Viro <viro@ftp.linux.org.uk> wrote:

> On Sat, Oct 27, 2007 at 11:01:12AM +0200, Ahmed S. Darwish wrote:
> > The problem here (As discussed in private mails) is that the for loop 
> > assumes that the beginning of given user-space buffer is the beginning
> > of a rule. This leads to situations where the rule becomes "ecret 20",
> > or "cret 20" instead of "Secret 20". Big input buffers/files leads 
> > smack to recieve a rule like "Secret 20" in fragmented chunks like:
> > 
> > write("<lots of rules before ours>\nSec", ..)
> > write("r", 1, ..)
> > write("et 20\n<remaing rules after ours>", ..)
> > 
> > Parsing a rule in such tough conditions in _kernel space_ is very
> > hard. I began to feel that it will be much easier if we do the parsing 
> > in a userspace utility and let smack accept only small buffers (80 char). 
> 
> For crying out louf, all it takes is a finite state machine...  BTW, folks,
> your parser *and* input language suck.  Really.  Silently allowing noise
> is Dumb(tm).

I was planning to patient Dumb, but if you've already got a copywrite
on it I'll have to go a different route. Carp.

> Please, write the grammar down and _follow_ _it_.

Good idea. I'll do it.

>  ...
> 
> Come on, people, this is ridiculous - why bother reinventing the wheels for
> the stuff that belongs to exercises halfway through any self-respecting
> introductory textbook?  Scary parser, my arse...

That code is in need of cleansing. With bleach. Yes, it's on my list.
I managed to get my virtual disk back, found how I messed up on v9,
and now have a (long) list of improvements and fixes.

No rest for the wicked.


Casey Schaufler
casey@schaufler-ca.com
