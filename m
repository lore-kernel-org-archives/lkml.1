Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251AbZJ2IFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbZJ2IFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbZJ2IFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:05:38 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:37040 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbZJ2IFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:05:35 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: symlinks with permissions (fwd)
Date: Thu, 29 Oct 2009 08:05:39 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hcbicj$qm4$2@taverner.cs.berkeley.edu>
References: <20091028211040.GA4182@elf.ucw.cz> <4AE922F9.5020506@schaufler-ca.com>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1256803539 27332 128.32.168.222 (29 Oct 2009 08:05:39 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Thu, 29 Oct 2009 08:05:39 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler  wrote:
>Gawd, I hate to say this, but people have been improperly educated
>if they expect directory permissions to behave thusly. You can not
>count on the permissions on a directory to protect access on a file
>that the directory contains a reference to. Hard links. Mount points.

1) Pavel's script takes care of hard links.  I'm not familiar with
the mount points issue.  I don't see how passing file descriptors over
sockets or fork() is relevant.

Pavel shows how a process can create its own directory, create a file
in that directory, and set up file permissions in such a way that it can
have a reasonable expectation that others will not be able to gain write
access to that file.  As far as I can tell, that expectation was met,
up until the /proc mechanism under question was introduced.  But the
/proc mechanism violates this expectation.  Yes, Pavel's method does
protect against hard links.

2) If you think folks have been improperly educated, can you point to
the Linux documentation that says not to rely upon directory permissions
for security purposes?

There's plenty of stuff that relies upon directory permissions for
security, and it's important that they be able to do so.

Do you mean to suggest that having root do a massive "chmod a+rx" on
every directory on the filesystem can never introduce security holes?
That sounds to me like it would be an absurd statement, yet it seems to
follow logically from your claim about directory permissions.  If one's
premises lead to absurd conclusions, perhaps the flaw is in the premises.
