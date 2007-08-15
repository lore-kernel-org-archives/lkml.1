Return-Path: <linux-kernel-owner+w=401wt.eu-S933586AbXHOQgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586AbXHOQgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 12:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761559AbXHOQgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 12:36:41 -0400
Received: from web52503.mail.re2.yahoo.com ([206.190.48.186]:31969 "HELO
	web52503.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761538AbXHOQgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 12:36:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ycNaP8cCJyO3xNTDuqjcLMbDQW3VpabU5vGD1N4jcmmZQ+u60/iW3G9wnKOzVpfp8a+BBOqRNu3OJWZTpbelF+nQkpBwec2aUVZuRtKzUnRCzSiovqO+42aTyB6RkzIubB/5Zd63ShiVN7x52lCMOeWiRz7bK2j0d+TO433Z0RI=;
X-YMail-OSG: GFd3R1cVM1lkkLqYK.Ayzddo5U5dVyidoLRZA3fjbcfxDAem65KhsNtWt.balgCwMKv95Y0jawsrpk3SK3X0pSEdW9esnl_KSVelyjh1WNlB8hbp.1M-
Date: Wed, 15 Aug 2007 09:36:38 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Thinking outside the box on file systems
To: Michael Tharp <gxti@partiallystapled.com>,
       Kyle Moffett <mrmacman_g4@mac.com>
Cc: alan <alan@clueserver.org>, Marc Perkel <mperkel@yahoo.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
In-Reply-To: <46C31859.6030306@partiallystapled.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <184413.25590.qm@web52503.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Michael Tharp <gxti@partiallystapled.com> wrote:

> Kyle Moffett wrote:
> > Basically any newly-created item in such a
> directory will get the
> > permissions described by the "default:" entries in
> the ACL, and
> > subdirectories will get a copy of said "default:"
> entries.
> 
> This would work well, although I would give write
> permissions to a group
> so the entire dir wouldn't need to be re-ACLed when
> a user is added. I
> may give this a shot; I've been avoiding ACLs
> because they have always
> sounded incomplete/not useful, but the inheritance
> aspect sounds rather
> nice.

Michael, my idea in this model is that there will be
no permissions stored in files. So you would not have
to re-ACL anything. 

What I'm thinking is there would be a new permission
system that is completely different.

It might be something like this. I am loged in as
mperkel. I get all the rights of mperkel and all other
objects like groups or management lists that I am a
member of. Once the system has a full list of my
rights it starts to compare the file name I'm trying
to access to the rights I have by testing each section
of the name. So if the file is
/home/mperkel/files/myfile then the test would be:

/home/mperkel/files/myfile - nothing
/home/mperkel/files - nothing
/home/mperkel - match - mperkel granted tree
permission

Rights tests would be based on trees so if you hit a
tree permission they you can access anything in the
tree unless you have hit a deny in the branches. All
of this is based on the text strings in the file name
with the "/" separator for the tests. 

The correct way of thinking of this is applying
permissions to name strings. Directories will become
artificial constructs. For example, one might grant
permissions for files:

/etc/*.conf - read only
/etc - deny

In this example the user would be able to read any
file in the /etc directory that ended in *.conf but no
other files. If the object listed the /etc directory
it would only show the *.conf files and no other file
would appear to exist.

The important point here is that directories don't
really exist. Imagine that every file has an internal
number that is linked to the blocks that contain that
file. Then there are file names that link to that
number directly. Then there is a permission system
that compares the name you are requesting to a
permission algorithm that determines what you are
allowed to do to the name that you are requesting.

For example, you want to list all file names /etc/*.
Each name is fetched and your permissions are compared
to each item and you get a list of names that you have
some permission to access. If you have no permission
to a name that exists then you don't see the name.
Thus, suppose you have this permission

/etc/pass* - deny

Then you will not only be denied access to the
/etc/passwd file, you wouldn't even be able to tell if
it exists.

The root user for compatibility would have permissions
to everything. It would be like a super manager.
Managers would be objects that have limited ability to
alter the permissions for other users or objects that
they manage.

I'm also thinking there would be a "kernel" user which
would be a level above the root user where the kernel
would have access to files that even the root user
can't see (unless debug modes are set) so that some
files can be system only or readable by root but
writable by kernel.


Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


      ____________________________________________________________________________________
Park yourself in front of a world of choices in alternative vehicles. Visit the Yahoo! Auto Green Center.
http://autos.yahoo.com/green_center/ 
