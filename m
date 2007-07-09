Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbXGIATb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbXGIATb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 20:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbXGIATX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 20:19:23 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:6215 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbXGIATW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 20:19:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kNtSCzgamffZUk6FvXdwb0kLzFjdLrrMlfJr4mt20EN53bPMu0Y1LYTLXuPSjCNXiRN5tHVBC1BThmvuR8Z1Z/aeKi6BY1MIe2hUL4pCQfivxd/n+L5+CyGg8Jct9QCEI0vsmb2ghJpt+yF2ch939e9SH97t7MUYu1+YgpwvMMM=
Message-ID: <9a8748490707081719je93d900pd349c8dfef83021e@mail.gmail.com>
Date: Mon, 9 Jul 2007 02:19:20 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.22 released
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
[snip]
> The shortlog (appended) is fairly self-explanatory and the diffstat (at
> the very end) also gives a fairly good picture of where the changes are.
>
I've always felt that these "shortlog since last -rc for a full
release" were a bit pointless.
Whoever is reading the release notes for a final 2.6.x release is not
going to be really interrested in what changed since the last -rc,
they want to know what changed since the last 2.6.(x-1) kernel. And
the people who are interrested in the changes since last -rc have
obviously been keeping track of what happened between the previous
-rc's (or else reading the last one doesn't make much sense).


> The full changelog since 2.6.21 also got uploaded, but quite frankly, I
> wonder if anybody uses those things? I've been uploading them for non-git
> users, but I have a suspicion that any people who want that kind of
> detail have long since learnt to use git, or are following the commit
> mailing lists or equivalent.
>
I believe you are right, but it's still a nice thing to have for
archeology purposes. To be able to download kernel 2.6.(some old x)
along with its Changelog makes for a nice combined package where
people can see where this kernel is different from the previous one...
it's just a nice thing to have in the FTP archives.
I won't cry much if it dies, but on the other hand I think it's a good
thing to have archived in a plain-text form for posterity.

> So this is also a heads-up that I'm considering skipping the ChangeLog
> files in the future - the full release ones are so big as to not be very
> easily readable (the full ChangeLog from 2.6.21 is ove ra hundred thousand
> lines, and weighs in at 3.8MB for example), and you really can get much
> better per-subsystem logs from git.
>
> Anybody? Should I make just the shortlogs available instead (I don't save
> those, but I post those for the later -rc's - usually the -rc1 and -rc2's
> are too big for the mailing list, but they are still a lot smaller and
> more readable than the *full* logs are)?
>

This is just my oppinion. The shortlogs are nice and readable,
archiving the shortlog-between-rc's would be nice, as for the full
logs see above.

I think what would be even better than posting full-/short-logs after
each -rc/full release, would be to post a list of who was involved in
that specific kernel release. I think that you are right that the
people who want the full details know how to use git (or else they can
get to parse the full Changelog), but what's really more interresting
is giving credit where it is due.
I'd suggest that whenever you release a new kernel you should upload
the full Changelog since last version, just so it's available. But, in
your release notes you should just list who contributed to that new
release, something like this :

juhl@dragon:~/kernel/linux-2.6$ git log v2.6.21..v2.6.22 | egrep
"^Author: " | sort | uniq -c | sort -n -r
    283 Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
    174 Author: David S. Miller <davem@sunset.davemloft.net>
    106 Author: Kristian Høgsberg <krh@redhat.com>
     88 Author: Stephen Hemminger <shemminger@linux-foundation.org>
     84 Author: Christoph Lameter <clameter@sgi.com>
     82 Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
     79 Author: Arnaldo Carvalho de Melo <acme@redhat.com>
     78 Author: Tejun Heo <htejun@gmail.com>
     78 Author: Patrick McHardy <kaber@trash.net>
     78 Author: Dmitry Torokhov <dtor@insightbb.com>
...

The details are in git / the Changelog, but this lets the worls easily
see who contributed - I suspect that's a lot more interresting to the
people reading your release-mails. I could be wrong (and I probably
am) ;-)


> Or do people really want the full logs, and don't use git?
>
git rules. It's a fantastic tool - anyone wanting the full details
should use it.

> Let me know how you feel. And test the actual release out too, of course!
>
Running 2.6.22-rc7-g4e99325b atm :)


-- 
Jesper Juhl <jesper.juhl@gmail.com>
