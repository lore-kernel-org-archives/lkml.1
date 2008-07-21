Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbYGUEU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbYGUEU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 00:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbYGUEUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 00:20:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbYGUEUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 00:20:16 -0400
Subject: request for comment: generic kernel interface for malware vendors
From: Eric Paris <eparis@redhat.com>
To: malware-list@lists.printk.net
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 21 Jul 2008 00:18:07 -0400
Message-Id: <1216613887.2960.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First I'd like to thank Sophos who stepped up and originally wrote a lot
of this code.  They might not recognize it since I've gotten my hands on
it, but they were nice enough to get the ball rolling by giving me some
GPL code which addressed near every request people on the malware list
had.

At the moment all of the code (over)uses the name talpa.  I expect this
group of people to come up with a new name for this interface, but since
that's how the patches started and I couldn't come up with anything I
love the patches still say talpa.  So if nothing else, lets come up with
suggestions.  For a little bit I plan to carry these as purely out of
tree patches but can move development somewhere like a git tree as they
settle down.  Feel free to send me comments/patches in an manner you see
fit.  I'm here to help.

This is a request for comment.  This is a first stab and I'm here to
address all of the concerns that people have.  Please don't hold back,
I've got thick skin.  BUT, I don't want to hear 'this is how we have
been doing it, do it that way.'  I want to hear how this won't work for
your needs (and WHY) or how we can do it better.

you can find the patches at:
http://people.redhat.com/~eparis/talpa

(1, 3, and 9 are by FAR the most interesting)

FOR NOW it comes with no documentation.  This is just a code dump since
I'm just in a rush.  I fly out for OLS in 5 hours.  Speaking of OLS, I'm
going to be there.  If you are going to be there and want to talk about
these patches, other patches, your needs, or really anything let me
know.

So what's at that web site?  There are 10 patches against Linus's git
tree.

1 - ****hooks, basics, infrastructure
2 - configuration generic stuff for the other patches
3 - ****results caching
4 - exclusions based on the operation or filetype
5 - per process exclusions
6 - filesystem type exclusions
7 - patch exclusions, don't scan when accessed through certain path
8 - patch inclusions, only scanning selected things
9 - ****userspace vetting, the big stuff
10 - operating when userspace is broken

patch 8 i'm not a fan of.  I really don't like path name security and
while path exclusions means we might scan more than we should
considering how unreliable and useless path names are path inclusions
means we might miss things.  I always find missing things to be rather
unacceptable.  Unless someone feels strongly I plan to drop patch 8
altogether (I also haven't reviewed it at all since I got it from
Sophos)

After (or maybe during) this next week I'll try to explain how all of
this works but for now this is just a code dump.  1, 3 and 9 are by FAR
the most interesting patches.  Patch 9 includes an example userspace
client that denies access to the file /root/denyme if it contains
exactly the string "bad."

I am trying to get something (that works) out there as soon as I can, so
please, don't take what you see as set in stone.  Give me comments.
What should I have done better?  Both in terms of what I'm doing and
what you need?

-Eric

 Documentation/talpa/allow_most.c         |  135 ++++++++
 Documentation/talpa/tecat.c              |   50 +++
 Documentation/talpa/test_deny.c          |  356 ++++++++++++++++++++
 fs/fcntl.c                               |    2 +-
 fs/inode.c                               |    6 +
 fs/namei.c                               |    2 +
 fs/open.c                                |   10 +
 include/linux/fs.h                       |    8 +
 include/linux/sched.h                    |    1 +
 include/linux/talpa.h                    |  184 ++++++++++
 security/Kconfig                         |    1 +
 security/Makefile                        |    2 +
 security/talpa/Kconfig                   |  124 +++++++
 security/talpa/Makefile                  |   18 +
 security/talpa/talpa.h                   |  181 ++++++++++
 security/talpa/talpa_allow_calls.h       |   18 +
 security/talpa/talpa_cache.c             |  207 ++++++++++++
 security/talpa/talpa_cache.h             |   22 ++
 security/talpa/talpa_client.c            |  542 ++++++++++++++++++++++++++++++
 security/talpa/talpa_common.c            |  223 ++++++++++++
 security/talpa/talpa_configuration.c     |  157 +++++++++
 security/talpa/talpa_degraded.c          |  120 +++++++
 security/talpa/talpa_deny_calls.h        |   18 +
 security/talpa/talpa_evaluation_calls.h  |   73 ++++
 security/talpa/talpa_fs_exclude.c        |  104 ++++++
 security/talpa/talpa_interceptor.c       |  122 +++++++
 security/talpa/talpa_operation_exclude.c |  151 +++++++++
 security/talpa/talpa_path_exclude.c      |  108 ++++++
 security/talpa/talpa_path_include.c      |  100 ++++++
 security/talpa/talpa_thread_exclude.c    |   63 ++++
 30 files changed, 3107 insertions(+), 1 deletions(-)

