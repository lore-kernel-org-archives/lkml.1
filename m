Return-Path: <linux-kernel-owner+w=401wt.eu-S1760537AbXJZWKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760537AbXJZWKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 18:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbXJZWKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 18:10:36 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38082 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbXJZWKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 18:10:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Kir Kolyshkin" <kir@openvz.org>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <oleg@tv-sign.ru>, <torvalds@linux-foundation.org>,
       <containers@linux-foundation.org>
Subject: Re: [Devel] [PATCH] pidns: Limit kill -1 and cap_set_all
References: <CBC546DD07068244AEC110EFEDA58B72358940@excite.int.sw-soft.com>
Date: Fri, 26 Oct 2007 16:10:04 -0600
In-Reply-To: <CBC546DD07068244AEC110EFEDA58B72358940@excite.int.sw-soft.com>
	(Kir Kolyshkin's message of "Fri, 26 Oct 2007 17:06:54 -0400")
Message-ID: <m1myu5y1c3.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Kir Kolyshkin" <kir@swsoft.com> writes:

> Eric, this problem is a known one. Currently Pavel and Sukadev are working on a
> appropriate signal management for namespaces.

I'm fairly certain that the signal issue you they are dealing with
is how to keep children from killing the init of a pid namespace.
At least that is what Suka mentioned when I asked him earlier,
and that is the discussion I have at various times on the containers
list.

This is a totally different issue.  This is keeping
kill -1 in a child pid namespace from sending a signal to
every process in the system.

It is a bad bug and this patch is a complete fix for it.
To my knowledge Pavel and Suka just overlooked this case.

> If you'd first sent this patch for discussion/review to containers@, you'd know
> that the patch is very incomplete.

I explicitly asked Suka, Pavel, and Cedric how complete they thought 
the pid namespace was before I started sending patches.  With
Pavel at a conference it makes sense why he did not reply.

For the most part Suka and Cedric did not know about the issues
that I have been finding and fixing.

So since several of them have been fixable with trivial simple fixes
and because we have passed -rc1 and it is now time for bug fixes
and possibly a few cleanups.  I have been making bug fixes.

Kir I am happy from feedback from people who can understand the code
and patches.  But I am not going to hold up sending simple obviously
correct fixes for discussion.

Eric

