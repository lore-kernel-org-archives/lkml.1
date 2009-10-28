Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZJ1WsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZJ1WsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 18:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZJ1WsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 18:48:07 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:39964 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbZJ1WsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 18:48:06 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: symlinks with permissions
Date: Wed, 28 Oct 2009 22:48:11 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hcahnb$mgp$1@taverner.cs.berkeley.edu>
References: <20091025062953.GC1391@ucw.cz> <m1zl7cb1c5.fsf@fess.ebiederm.org> <20091028081653.GA18290@elf.ucw.cz> <4AE87292.20802@schaufler-ca.com>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1256770091 23065 128.32.168.222 (28 Oct 2009 22:48:11 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Wed, 28 Oct 2009 22:48:11 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler  wrote:
> There is no security violation here. Consider the case where
> the file is unlinked after it is opened. What directory permissions
> would matter in that case?

Where are you going with this?

Suppose I open a file in read-only mode.  Suppose moreover I only
have permission to read the file but not write it (given the full
permissions on the path to the file).  Suppose that someone else deletes
the file.  Then the OS had darn well better prevent me from upgrading
my read-only file descriptor to a read-write file descriptor.  If some
OS feature created a backdoor that allowed me to upgrade my read-only
file descriptor to read-write access (even in cases where the file and
directory permissions would prevent me from directly opening the file in
read-write mode), then we'd darn well consider that a security violation.
That is roughly analogous to what is happening here.

I do think Pavel's attack is a security violation.  I don't understand
why there is any debate about this; it seems pretty clear-cut to me.
It may be an obscure corner-case, but it still seems like a cut-and-dry
security violation.  (Incidentally, I found the quality of some of the
discussion on bugtraq pretty disappointing as well.)

> The path name is
> an ethereal convenience and once traversed has no bearing on the
> security state of the object.

I think you've missed the point of Pavel's attack.  Pavel's attack allows
a malicious process to take an existing read-only file descriptor and
turn it into a read-write file descriptor, in cases where the filesystem
permission bits should not have allowed the malicious process to do that.
*That* is the security violation.  *That* should not be allowed.

Perhaps take a look at Pavel's post describing the attack again?
