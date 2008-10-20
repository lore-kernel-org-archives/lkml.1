Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbYJTSvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbYJTSvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 14:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbYJTSvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 14:51:44 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:58702 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbYJTSvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 14:51:44 -0400
Date: Mon, 20 Oct 2008 13:51:30 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Halcrow <mhalcrow@us.ibm.com>
Subject: Re: [PATCH] User namespaces: set of cleanups (eventually for
	linux-next?)
Message-ID: <20081020185130.GA21054@us.ibm.com>
References: <20081016224641.GA17413@us.ibm.com> <758.1224201299@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <758.1224201299@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> 
> Serge E. Hallyn <serue@us.ibm.com> wrote:
> 
> > David, since this consumes your patch, I wasn't sure whether it was
> > appropriate to put your signed-off-by on here or not.  I decided
> > doing so was the worse of the potential offenses...
> 
> The way I think I'd've done it is to include my patch description and
> signed-off-by then list your additional changes (just keep on incrementing the
> point numbers) and your signed-off-by.
> 
> > -	new_user = alloc_uid(current->nsproxy->user_ns, new->uid);
> > +	new_user = alloc_uid(current_user()->user_ns, new->uid);
> 
> That should be current_user_ns() rather than current_user()->user_ns.  I made
> this change before adding the macro.

Ok, will change.

> > +	key_put(new->thread_keyring);
> > +	new->thread_keyring = NULL;
> 
> Superfluous.  copy_creds() does this immediately upon return.

Oops, will drop.

> Also, in copy_creds(), should the session and process keyrings be discarded if
> CLONE_NEWUSER is set?  Actually, I think that should be dealt with by a patch
> to deal with namespacing keyrings as the user-default keyrings need to be
> namespaced rather than here.
> 
> David

Oh, yeah, that's going to have to be a separate patch I guess...

thanks,
-serge
