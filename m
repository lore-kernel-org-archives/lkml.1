Return-Path: <linux-kernel-owner+w=401wt.eu-S965823AbXCPS2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965823AbXCPS2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 14:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965826AbXCPS2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 14:28:35 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37007 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965823AbXCPS2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 14:28:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, containers@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + remove-the-likelypid-check-in-copy_process.patch added to -mm tree
References: <20070316170255.GA194@tv-sign.ru>
Date: Fri, 16 Mar 2007 12:27:15 -0600
In-Reply-To: <20070316170255.GA194@tv-sign.ru> (Oleg Nesterov's message of
	"Fri, 16 Mar 2007 20:02:55 +0300")
Message-ID: <m1y7lxm4cc.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> Sukadev Bhattiprolu wrote:
>
> This means that idle threads (except "swapper") are visible to
> for_each_process()
> and do_each_thread(). Looks dangerous and somewhat strange to me.
>
> Could you explain this change?

Good catch.  I've been so busy pounding reviewing this patches into
something that made sense that I missed the fact that we care about
this for more than just the NULL pointer that would occur if we didn't
do this.

Still it would be good if we could find a way to remove this rare
special case.

Any chance we can undo what we don't want done for_idle, or create
a factor of copy_process that only does as much as fork_idle should do,
and make copy_process a wrapper that does the rest.

I doubt it is significant anywhere but it would be nice to remove a
branch that except at boot up never happens.

Eric
