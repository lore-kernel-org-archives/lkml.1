Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYHHIpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYHHIpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 04:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbYHHIpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 04:45:45 -0400
Received: from burp.tkv.asdf.org ([212.16.99.49]:50558 "EHLO
	cs181073102.pp.htv.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752022AbYHHIpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 04:45:44 -0400
X-Greylist: delayed 824 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Aug 2008 04:45:44 EDT
To: linux-kernel@vger.kernel.org
Subject: Access to credentials of a process from another?
References: <aAZcn-22h-21@gated-at.bofh.it> <aAZcn-22h-19@gated-at.bofh.it>
From: Markku Savela <msa@moth.iki.fi>
Date: Fri, 08 Aug 2008 11:31:56 +0300
In-Reply-To: <aAZcn-22h-19@gated-at.bofh.it> (Markku Savela's message of "Wed\, 04 Jun 2008 13\:20\:19 +0200")
Message-ID: <87bq03vrer.fsf_-_@burp.tkv.asdf.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I looked with some interest the big credentials patch.

I have a desire to do following in user space

  - have PID of another process

  - want to check some aspect of credentials of this process from
    another process (for example, currently whether the other process
    has a specific group in its context).

In current Ubuntu release, to achieve this, I had to patch kernel
sys.c and write own kernel module which offered the API for this
function.

I notice that credentials (http://lwn.net/Articles/287091/) document
has some wording about accessing credentials from another
process. What is not clear yet (in document),

 - is this possible from loadable module (e.g. are the required
   symbols exported)?

 - are there any plans to define some API for a user space application
   to access this information?

I assume that in some cases, like Unix socket, the peers should
have same direct vay of reading each others credentials blobs from the
socket?

However, for example, in case of DBus this is murky, as the server and
client do not have direct connection to each other, and DBus would
need to pass some information. Currently, with some work, it is
possible for DBus server to get the clients PID. Thus, a function in
user space to get the credentials by PID would be sufficient.

Also, it is not acceptable to say that DBus should use it's "root"
powers and fake clients credentials on forwarded messages.

 - First, not all DBus are root,

 - second, server might want to see both credentials (DBus servers and
   the originating client).

Finally, I don't like any text based /proc file solutions, for example
parsing output of "/proc/<pid>/status" is horrible (especially was not
option for me, because it does not give all groups anyway).
