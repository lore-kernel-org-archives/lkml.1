Return-Path: <linux-kernel-owner+w=401wt.eu-S1759578AbYCDWTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578AbYCDWTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 17:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757962AbYCDWTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 17:19:35 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47310 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758272AbYCDWTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 17:19:34 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Ian Kent <raven@themaw.net>, Jeff Moyer <jmoyer@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH 3/4] autofs4 - track uid and gid of last mount requestor
References: <1204179747.3501.21.camel@raven.themaw.net>
	<20080227223734.caab0165.akpm@linux-foundation.org>
	<1204182500.3501.49.camel@raven.themaw.net>
	<20080227232339.af6e904a.akpm@linux-foundation.org>
	<1204185623.3501.84.camel@raven.themaw.net>
	<x494pbtxaup.fsf@segfault.boston.devel.redhat.com>
	<20080228195118.GA16634@sergelap.austin.ibm.com>
	<1204255932.3969.86.camel@raven.themaw.net>
	<20080229160921.GA24296@sergelap.ibm.com>
	<m1bq5y3p2o.fsf@ebiederm.dsl.xmission.com>
	<20080303152855.GB25643@sergelap.austin.ibm.com>
Date: Tue, 04 Mar 2008 15:16:34 -0700
In-Reply-To: <20080303152855.GB25643@sergelap.austin.ibm.com> (Serge
	E. Hallyn's message of "Mon, 3 Mar 2008 09:28:55 -0600")
Message-ID: <m1od9u2kzh.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Earlier I had thought this could just be done using a special keyring,
> but atm I'm thinking that would be far uglier than just having a
> struct pid-like credential proxy in the kernel to pass around in place
> of uids.

I have not looked at many of the implementation possibilities so unfortunately
I don't know what makes for a good implementation.

What I do know is that uids are serialized in filesystems, and their
mapping between namespaces is defined by system administrators.

Both of those properties are different from struct pid.  Which means
a generalized struct user in the kernel can at best hold a cache of the
mappings.

My preliminary investigations suggested that for the kernel filesystem
boundary generating a struct user or a struct group just to use for a
permission check and then to throw it away was wasteful.

However for inkernel entities a struct user sounds practical.

All of which is to say that we can learn lessons from the
implementation of struct pid but that we also have different
requirements so we can only use those lessons in a limited fashion.

Eric
