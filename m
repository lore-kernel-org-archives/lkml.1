Return-Path: <linux-kernel-owner+w=401wt.eu-S932076AbXH2VHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076AbXH2VHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 17:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbXH2VHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 17:07:43 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42207 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbXH2VHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 17:07:43 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@in.ibm.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       containers@lists.osdl.org
Subject: Re: [PATCH] Send quota messages via netlink
References: <20070828141318.GC5869@duck.suse.cz>
	<20070828211335.37fce4c9.akpm@linux-foundation.org>
	<20070829122647.GB7814@duck.suse.cz>
	<m1mywa42g7.fsf@ebiederm.dsl.xmission.com>
	<20070829192653.GD7814@duck.suse.cz>
Date: Wed, 29 Aug 2007 15:06:43 -0600
In-Reply-To: <20070829192653.GD7814@duck.suse.cz> (Jan Kara's message of "Wed,
	29 Aug 2007 21:26:53 +0200")
Message-ID: <m1wsve2gpo.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>
>> However I'm still confused about the use of current->user.  If that
>> is what we really want and not the user who's quota will be charged
>> it gets to be a really trick business, because potentially the uid
>> we want to deliver varies depending on who opened the netlink socket.
>   I see it's a complicated matter :). What I need to somehow pass to
> userspace is something (and I don't really care whether it will be number,
> string or whatever) that userspace can read and e.g. find a terminal
> window or desktop the affected user has open and also translate the
> identity to some user-understandable name (average user Joe has to
> understand that he should quickly cleanup his home directory ;).
>   Thinking more about it, we could probably pass a string to userspace in
> the format:
>   <namespace type>:<user identification>
>
> So for example we can have something like:
>   unix:1000 (traditional unix UIDs)
>   nfs4:joe@machine
>
> The problem is: Are we able to find out in which "namespace type" we are
> and send enough identifying information from a context of unpriviledged
> user?

Ok.  This provides enough context to understand what you are trying to do.
You do want the unix user id, not the filesystem notion.  Because you
are looking for the user.

So we have to figure out how to do the hard thing which is look at
who opened our netlink broadcast see if they are in the same user
namespace as current->user.  Which is a pain and we don't currently
have the infrastructure for.

Eric
