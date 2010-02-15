Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab0BOV3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 16:29:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147Ab0BOV3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:29:37 -0500
Subject: Re: [GIT] Security subsystem changes for 2.6.33
From: Eric Paris <eparis@redhat.com>
To: Dave Airlie <airlied@gmail.com>
Cc: James Morris <jmorris@namei.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, sds@tycho.nsa.gov
In-Reply-To: <21d7e9971002142046p2a3af2bak1a01bb7117db7841@mail.gmail.com>
References: <alpine.LRH.2.00.0912040030400.16314@tundra.namei.org>
	 <21d7e9971002142046p2a3af2bak1a01bb7117db7841@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Feb 2010 16:29:22 -0500
Message-ID: <1266269362.24665.8.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-15 at 14:46 +1000, Dave Airlie wrote: 
> > Eric Paris (5):
> 
> >      SELinux: add .gitignore files for dynamic classes
> 
> This isn't such a good idea I've discovered after wasting half my day
> wondering why 2.6.33-rc8 oops in selinux
> code when vbetool runs.
> 
> The problem (not sure what we or git can do, hence Linus cc'ed) is:
> 
> a) git tree contains 2.6.32 + with old non-generated versions of
> flash.h and av_permissions.h
> b) git pull 2.6.33-rc8, nothing removes these old files, git status
> doesn't show them as they are now in .gitignore
> c) build 2.6.33, it picks up the include files from the old location
> not from the generated ones in the new tree.
> d) bad juju.
> 
> I'm also doing out of tree builds btw.

I'm not sure I understand why the old ones didn't get cleaned up.  They
did for me.

$ git checkout -b testing v2.6.32
$ find security/selinux/ -name flask\*
security/selinux/include/flask.h
[here I made a commit on MAINTAINERS just to make sure pull did
something]
$ git pull linus master
$ find security/selinux/ -name flask\*
[nothing]
$

I don't have those two old header files laying around.  I understand why
your old ones are still there.

I build selinux which generates the new files (in slightly new places)

$ make security/selinux/
$ find security/selinux/ -name flask\*
security/selinux/flask.h

They moved from
security/selinux/include
  to
security/selinux

I have a security/selinux/.gitignore which lists

$ cat security/selinux/.gitignore 
av_permissions.h
flask.h

Which I believe means they match the old locations as well.  Is there
some better way to ignore the new autogenereated files such that they
won't match include/flask.h?  I don't understand why the old files
weren't cleaned up?  Am I doing something wrong in my testing?  Should I
be doing something better in the code?

-Eric

