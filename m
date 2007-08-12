Return-Path: <linux-kernel-owner+w=401wt.eu-S936730AbXHLRQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936730AbXHLRQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 13:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762987AbXHLRQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 13:16:50 -0400
Received: from web36607.mail.mud.yahoo.com ([209.191.85.24]:43197 "HELO
	web36607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757996AbXHLRQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 13:16:49 -0400
X-YMail-OSG: uId3ob0VM1kKXY32G4aTSJn3icr1ixu7nEx_A.7sbLia.jIUd.C6ak1rX4esVhXY.mXRgS7y.g--
X-RocketYMMF: rancidfat
Date: Sun, 12 Aug 2007 10:16:48 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel 
To: Keith Owens <kaos@ocs.com.au>, casey@schaufler-ca.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@osdl.org, torvalds@osdl.org
In-Reply-To: <3351.1186890318@ocs10w.ocs.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <318317.50626.qm@web36607.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Keith Owens <kaos@ocs.com.au> wrote:

> Casey Schaufler (on Sat, 11 Aug 2007 10:57:31 -0700) wrote:
> >Smack is the Simplified Mandatory Access Control Kernel.
> >
> > [snip]
> >
> >Smack defines and uses these labels:
> >
> >    "*" - pronounced "star"
> >    "_" - pronounced "floor"
> >    "^" - pronounced "hat"
> >    "?" - pronounced "huh"
> >
> >The access rules enforced by Smack are, in order:
> >
> >1. Any access requested by a task labeled "*" is denied.
> >2. A read or execute access requested by a task labeled "^"
> >   is permitted.
> >3. A read or execute access requested on an object labeled "_"
> >   is permitted.
> >4. Any access requested on an object labeled "*" is permitted.
> >5. Any access requested by a task on an object with the same
> >   label is permitted.
> >6. Any access requested that is explicitly defined in the loaded
> >   rule set is permitted.
> >7. Any other access is denied.
> 
> Some security systems that have the concept of "no default access"
> (task labeled "*") also allow access by those tasks but only if there
> is an explicit rule giving access to the task.  IOW, rule 6 is applied
> before rule 1.  In my experience this simplifies special cases where a
> task should only have access to a very small set of resources.  I'm
> curious why smack goes the other way?

A task labeled star would create files labeled star, which would be
readable and writable by everyone (rule 4). This would be bad.

Over the past three decade I've seen a lot of secure installations
but I have never seen one where they really wanted to deny any
real application access to "/". That's a major reason for chrooted
environments.

Remember also that a process labeled Coffee would have read access
to floor files, all access to star files (e.g. /dev/null), read and
write access to Coffee objects, and no others unless specified. If
you are serious about reducing the programs a Coffee process can run
you can do so by moving them off the floor, that is, giving them
a different label, say "Tea". There is a cost to doing this, which
is that you now have to give other labels explicit access to Tea
objects. This is how you would implement a Biba integrity policy.

So, can you give me an example where you don't want access to any
file system objects (no read or execute access on floor) and are still
doing something useful? Remember that you can't exec a program if
you can't access it.

I think that access to the file system namespace is universally
required. I'm open to education.


Casey Schaufler
casey@schaufler-ca.com
