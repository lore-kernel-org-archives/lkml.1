Return-Path: <linux-kernel-owner+w=401wt.eu-S1759116AbYAQW36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759116AbYAQW36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbYAQW3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:29:48 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:1271 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYAQW3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:29:47 -0500
From: "David Schwartz" <davids@webmaster.com>
To: <torvalds@linux-foundation.org>
Cc: "Johannes Weiner" <hannes@saeurebad.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <clameter@sgi.com>, <penberg@cs.helsinki.fi>
Subject: RE: Why is the kfree() argument const?
Date: Thu, 17 Jan 2008 14:28:43 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEHDJJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-reply-to: <alpine.LFD.1.00.0801171316390.14959@woody.linux-foundation.org>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 17 Jan 2008 14:29:59 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 17 Jan 2008 14:29:59 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On Thu, 17 Jan 2008, David Schwartz wrote:

> > Which does change the thing the pointer points to. It goes from being a
> > valid object to not existing.

> No. It's the *pointer* that is no longer valid.

The pointer is no longer valid because the object it pointed to no longer
exists. The pointer is also no longer valid, but that is not the end of the
story.

> There's definitely a difference between "exists and is changed" and
> "doesn't exist any more".

> > How is ceasing to exist not a change?

> It's not a change to the data behind it, it's a change to the *metadata*.
> Which is somethign that "const" doesn't talk about at all.

It doesn't matter what has changed. All that matters is whether this is
something we normally want to happen to a const pointer or whether doing
this to a const pointer is not normal.

> > >    Why? Because we want the types to be as tight as possible,
> > > and normal
> > >    code should need as few casts as possible.
> >
> > Right, and that's why you are wrong.
>
> No, it's why I'm right.

> "kmalloc/kfree" (or any memory manager) by definition has to play games
> with pointers and do things like cast them. But the users shouldn't need
> to, not for something like this.

If you don't like having to cast, don't use 'const'. But if you use 'const',
you have to cast when you mean to do something that you would like to be
warned about if you do it by accident.

> > No, it's both correct and useful. This code is the exception to
> a rule. The
> > rule is that the object remain unchanged and this violates that rule.

> No.
>
> You are continuing to make the mistake that you think that "const" means
> that the memory behind the pointer is not going to change.

No, that's not what it means. It has nothing to do with memory. It has to do
with logical state.

> Why do you make that mistake, when it is PROVABLY NOT TRUE!

I don't. You do, because you argue 'kfree' can be const because it doesn't
change the memory. The change in the memory is meaningless, the change in
the logical state of the object is what matters.

> Try this trivial program:
>
> 	int main(int argc, char **argv)
> 	{
> 	        int i;
> 	        const int *c;
>
> 	        i = 5;
> 	        c = &i;
> 	        i = 10;
> 	        return *c;
> 	}
>
> and realize that according to the C rules, if it returns anything but 10,
> the compiler is *buggy*.
>
> The fact is, that in spite of us having a "const int *", the data behind
> that pointer may change.

I don't know what you think this example proves. Nobody is arguing that so
long as one const pointer to an object exists, no code anywhere should ever
be able to change it.

All I'm saying is that changing the logical state of an object *through* a
const pointer is unusual. You should need a cast to do this because that's
the only way to get a warning if you do it by mistake.

> So it doesn't matter ONE WHIT if you pass in a "const *" to "kfree()": it
> does not guarantee that the data doesn't change, because the object you
> point to has other pointers pointing to it.

Right, nobody said this was about guaranteeing that data doesn't change.

> This isn't worth discussing. It's really simple: a conforming program
> CANNOT POSSIBLY TELL whether "kfree()" modified the data or not.

But that's exactly what doesn't matter. As you've said at least twice now,
it has nothing to do with changing the data. It has to do with changing the
logical state of the object. That's what you're not supposed to do through a
'const' pointer.

> As such,
> AS FAR AS THE PROGRAM IS CONCERNED, kfree() takes a const
> pointer, and the
> rule that "if it can be considered const, it should be marked
> const" comes
> and says that kfree() should take a const pointer.

That's crazy.

> In other words - anythign that could ever disagree with "const *" is BY
> DEFINITION buggy.
>
> It really is that simple.

I think you may be the only person in the world who thinks so.

DS


