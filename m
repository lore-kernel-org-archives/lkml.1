Return-Path: <linux-kernel-owner+w=401wt.eu-S1758924AbYJIMKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbYJIMKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 08:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbYJIMKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 08:10:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:29100 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbYJIMKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 08:10:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition;
        b=ulXS3CsDbE/ecEvOXOhSk34VYI7wf4ZOIXX+EwhmfezT26JQpi2N+tPoyTwi0cPEtP
         YSxV/8yxOX5RwJMwicrLqP24iSY57Dxv0eJDEWSMRP2n3g0s33lhJUtFz350x69rCOQD
         Pgs5PFZWHIuAml7jWJGXAML2qMBmgC14GJ0hI=
Message-ID: <cfd18e0f0810090510i87f088fi9eeea829ae2b58c1@mail.gmail.com>
Date: Thu, 9 Oct 2008 14:10:08 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: dup2() vs dup3() inconsistency when
Cc: "Ulrich Drepper" <drepper@redhat.com>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

your 2008-07-26 commit 6c5d0512a091480c9f981162227fdb1c9d70e555 for
fs/fcntl.c:sys_dup3 contains

+       if (unlikely(oldfd == newfd))
+               return -EINVAL;

This makes dup2() and dup3() differ with respect to the oldfd==newfd
case (dup2() becomes a no-op, just returning oldfd, dup3() gives the
EINVAL error.

Your commit log doesn't explain the rationale for this change.  What
is it?  (I could guess that it is to error on a case that may be a
user programming error, but I want to check this with you, so that I
add the right text to the man page.)

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
