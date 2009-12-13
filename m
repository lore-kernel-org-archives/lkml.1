Return-Path: <linux-kernel-owner+w=401wt.eu-S1751437AbZLMFp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbZLMFp1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 00:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbZLMFp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 00:45:26 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.153.193]:36218 "HELO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750900AbZLMFp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 00:45:26 -0500
X-Greylist: delayed 1529 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Dec 2009 00:45:26 EST
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: EUID != root + EGID = root, and CAP_SETGID
Date: Sun, 13 Dec 2009 05:19:56 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hg1ths$g05$1@taverner.cs.berkeley.edu>
References: <4B222C3D.2070807@icdsoft.com>
Reply-To: daw-news@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1260681596 16389 128.32.153.193 (13 Dec 2009 05:19:56 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Sun, 13 Dec 2009 05:19:56 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Zahariev  wrote:
>Is this an intended behavior?

Yes.  Setuid/setgid are a mess.  For more details, you might
find the following research papers interesting:

http://www.cs.berkeley.edu/~daw/papers/setuid-usenix02.pdf 
http://www.cs.berkeley.edu/~daw/papers/setuid-login08b.pdf 

See, e.g., Section 5.2 of the former paper, which says:

  "an effective group ID of zero does not accord any
  special privileges to change groups. This is a potential
  source of confusion: it is tempting to assume incorrectly
  that since appropriate privileges are carried by the euid
  in the setuid-like calls, they will be carried by the
  egid in the setgid-like calls, but this is not how it
  actually works. This misconception caused a mistake in
  the manual page of setgid in Redhat Linux 7.2 (Section
  6.4.1)."
