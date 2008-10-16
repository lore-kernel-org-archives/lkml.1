Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbYJPXz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbYJPXz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYJPXzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:55:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38038 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbYJPXzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:55:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081016224641.GA17413@us.ibm.com>
References: <20081016224641.GA17413@us.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, James Morris <jmorris@namei.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Halcrow <mhalcrow@us.ibm.com>
Subject: Re: [PATCH] User namespaces: set of cleanups (eventually for linux-next?)
Date: Fri, 17 Oct 2008 00:54:59 +0100
Message-ID: <758.1224201299@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Serge E. Hallyn <serue@us.ibm.com> wrote:

> David, since this consumes your patch, I wasn't sure whether it was
> appropriate to put your signed-off-by on here or not.  I decided
> doing so was the worse of the potential offenses...

The way I think I'd've done it is to include my patch description and
signed-off-by then list your additional changes (just keep on incrementing the
point numbers) and your signed-off-by.

> -	new_user = alloc_uid(current->nsproxy->user_ns, new->uid);
> +	new_user = alloc_uid(current_user()->user_ns, new->uid);

That should be current_user_ns() rather than current_user()->user_ns.  I made
this change before adding the macro.

> +	key_put(new->thread_keyring);
> +	new->thread_keyring = NULL;

Superfluous.  copy_creds() does this immediately upon return.

Also, in copy_creds(), should the session and process keyrings be discarded if
CLONE_NEWUSER is set?  Actually, I think that should be dealt with by a patch
to deal with namespacing keyrings as the user-default keyrings need to be
namespaced rather than here.

David
