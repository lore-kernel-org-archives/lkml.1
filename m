Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbXA3QcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbXA3QcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 11:32:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbXA3QcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 11:32:04 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:57333 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbXA3QcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 11:32:01 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH 2/2] make pipefs do lazy i_ino assignment and hashing
To: Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com, dev@openvz.org
Reply-To: 7eggert@gmx.de
Date: Tue, 30 Jan 2007 17:31:16 +0100
References: <7J3fA-Tk-11@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1HBvt7-00018P-1c@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9b3b2cc444a07783f194c895a09f1de9
X-Provags-ID2: V01U2FsdGVkX1+kKhhSzAG9pYTfEYhqgwD9X8xNgHyBiZXgo++CVxoRXoZYd3CQbpNM+j6Jq/vuqCZUucZa+7uJKyRh2aWHGTh/PZwulcPm289W4T5+0Hxo0Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton <jlayton@redhat.com> wrote:

> This patch updates pipefs to do defer assigning an i_ino value to its inodes
> until someone actually tries to stat it. This allows us to have unique i_ino
> values for the inodes here, without the performance impact for anyone who
> doesn't actually care about it.
> 
> Since we don't have an i_ino value at pipe creation time, we need something
> else to stuff into the dentry name. Here, I'm using the pointer address of
> the inode xor'ed with a random value. There are certainly better hashing
> schemes, so if someone wants to propose a better way to do this, then I'm
> open to looking at it (maybe halfmd4?).

Why XOR? To pretend a non-existent level of security?
Either you can't use the address, or you can read the obfusicator value, too.

OTOH, if sizeof(void*) <= sieof(ino_t), using the address will result in a
unique inode number without need for expensive hashing algorithms.
-- 
Why did the hacker cross the road? To get to the other side.
Why did the cracker cross the road? To get what was on the other side.
The difference is small, but important.
        -- Gandalf Parker
