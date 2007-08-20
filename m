Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbXHTHF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbXHTHF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 03:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbXHTHFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 03:05:49 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:38836 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbXHTHFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 03:05:48 -0400
To: Marc Perkel <mperkel@yahoo.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, Kyle Moffett <mrmacman_g4@mac.com>,
       Phillip Susi <psusi@cfl.rr.com>, Valdis.Kletnieks@vt.edu,
       Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Thinking outside the box on file systems
References: <900404.40407.qm@web52501.mail.re2.yahoo.com>
From: Nix <nix@esperi.org.uk>
Emacs: featuring the world's first municipal garbage collector!
Date: Mon, 20 Aug 2007 08:05:09 +0100
In-Reply-To: <900404.40407.qm@web52501.mail.re2.yahoo.com> (Marc Perkel's message of "19 Aug 2007 05:08:03 +0100")
Message-ID: <877inqofdm.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-dcc.uncw.edu-Metrics: hades 1201; Body=10 Fuz1=10 Fuz2=10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Lurker delurking here: I've seen Marc pull this sort of trick on
 multiple mailing lists now and I've had enough. Coming up with
 wild ideas, thinking they must be ideas nobody else has ever
 considered, and never thinking them through for five minutes is
 sort of Marc's hallmark, I'm afraid.]

On 19 Aug 2007, Marc Perkel uttered the following:

> No Al, there isn't any shortage of arrogance here.

Actually Al's being unusually nice to you. A regular would have had a
few lines of `you must be kidding' but he's trying to get you to see
*why* you are wrong.

(It's not working.)

> Let me try to repeat what I'm talking about as simply
> as I can.

Precision is better.

> First - I'm describing a kind of functionality and
> suggesting Linux should have it. I know a lot of it
> can be done because much of what I'm suggesting is
> already working in Windows and Netware.

Windows and Netware don't have multiple namespaces to cope with
(e.g. chroot()); nor do they have the ability to detach parts of their
filesystem tree completely from other parts (so they're not even
connected at the root).

Their VFSes are much less capable than Linux's.

ACLs provide some of the inheritability you want anyway.


In regards to the general idea of doing permission checking in
userspace: that works to some extent --- see FUSE --- but you really
*cannot* allow the entity who specifies permissions check semantics on
the filesystem to have less privileges than the entity who mounted the
filesystem in the first place. It's safe for that entity to specify such
things because it can read the device the filesystem is mounted from
anyway, thus overriding all permissions if it wants to: but any entity
of lesser privilege could use this as a really cheap privilege
escalation attack. (This is fundamental and unavoidable and no amount
of thinking outside any sort of box will fix it.)

> I'm not the one who's going to code it. I'm just

Might I suggest then that coming here and bloviating is not the right
approach? In the Linux world there are two ways to proceed: doing the
work yourself or paying someone to. You can sometimes get lucky and find
that someone else has already done what you were thinking of, but it is
vanishingly rare to have an idea so cool that someone else catches fire
and does all the work for you. In fact I can't recall ever seeing it
happen, although I suppose it might among longtime collaborators some of
whom are very overloaded with other things.

So you could make this a mount option, I suppose, but nothing more
pluggable than that.

(I don't see how your userspace permissions layer will avoid calling
back into the VFS, either: take care to avoid infloops when you code
it.)

> saying that it would be nice if Linux had the
> functionality of other operating systems - and - take
> it to the next level - match it and do even better.

`The next level'? What `next level'?

> As to thinking outside the box, what I'm proposing is
> outside the box relative to Linux. It's not as
> original as compared to Windows or Netware which is
> even better.

Actually neither of those OSes provide regex-based permissions checking
that I know of. It's not a fundamentally silly idea but if you'd been
paying even the slightest attention to this list or one of its summaries
(like LWN's) over the last, oh, three years you'd have noticed the
difficulty winning people over that security modules that do depend on
name matching are experiencing. And AppArmor has clear semantics,
working code and actual users, none of which your idea has got.

(And in regard to your idea being so startlingly original in the Linux
world, well, you're not quite a decade behind the times.)

> The idea is that Linux is lacking features that other
> OSs have. What I'm suggesting is that Linux not only
> match it but to create an even more powerful rights
> layer that is more powerful than the rest and I'm

I see no sign of significant extra power in what you've mentioned so
far: only extra ways to create security holes and/or infinite
regressions.

> outlining a concept in the hopes that people would get
> excited about the concept and want to build on the
> idea.

It's not working.

> I'm just telling you what I'd like to see. I'm not
> going to code it. So I'm only going to talk about what
> is possible.

Anyone on this list is capable enough to have thought of this one
themselves, and generally to have seen the holes as well. You don't even
seem to have *looked* for holes, which is strange given that this is
pretty much the most important job of anyone who's just thought of a new
idea.

> one is inspired the Linux will continue to be in last
> place when it comes to file system features relating
> to fine grain permissions.

Yay, very crude moral blackmail (well, it would be moral blackmail if
what you were saying was in any way persuasive). Way to inspire people!

> In Linux, for example, users are allowed to delete
> files that they are prohibited from reading or
> writing. In Netware if a user can't read or write to
> the file they won't even be able to see that the file
> exists, let alone delete it.

This implies that you're allowed to have multiple files of the same name
in the same directory. I don't think so. i.e. you *can* see that the
file exists by trying to create one of the same name and watching it
inexplicably fail. i.e. this measure does not actually provide increased
security against a determined attacker. i.e., this measure is largely
useless.

> In Netware I can move a directory tree into another
> tree and the objects that have rights in the other
> tree will have rights to all the new files without
> having to run utilities on the command line to
> recursively change the permission afterwards. 

That works until you have chroot() or detachable namespaces: and saying
`oh, nobody uses those' is irrelevant: *at any time* any chunk of the
namespace might get detached and go haring off on its own (as it were),
and permissions checks under the detached piece had better not change
semantics should that happen.

> The point - Linux isn't going to move forward and
> catch up unless there is a fundamental change in the
> thinking  behind Linux permissions. There is a

All fundamental changes in this area require *very* careful thinking
about the security implications. Complexity increases are also something
to avoid if possible because they make the model harder to think about:
and even slight increases can have large effects. (Witness all the pain
that the addition of two-or-is-it-three extra permissions sets brought
with POSIX capabilities: multiple security holes until they got
effectively disabled back in 2.2.x. They're still not back on although
with luck that may be changing.)

> cultural lack of innovation here. I discussed this

There is entirely justified *paranoia* about changing security
semantics, combined with a lack of desire to do all your working *and*
thinking for you.

> with Andrew Morton and he made some suggestions but
> there's real hostility towards new concepts here.

There's rather less hostility when there's working code (but still quite
a bit, witness AppArmor).

> Something I don't understand. At some point Linux
> needs to grow beyond just being an evolved Unix clone
> and that's not going to happen if you don't think
> differently.

Sorry, Linux *is* a Unix clone. If you want an experimental OS, well, git
makes it easy to fork. However that will mean doing the work yourself.

> I still believe that the VI editor causes brain
> damage. :)

I hasten to add that using Emacs doesn't *always* cause an inability to
analyze one's ideas.
