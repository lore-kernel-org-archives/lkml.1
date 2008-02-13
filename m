Return-Path: <linux-kernel-owner+w=401wt.eu-S1759372AbYBMMiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372AbYBMMiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 07:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbYBMMio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 07:38:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbYBMMin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 07:38:43 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080212155137.d07f80b7.akpm@linux-foundation.org>
References: <20080212155137.d07f80b7.akpm@linux-foundation.org> <20080208160424.14436.6965.stgit@warthog.procyon.org.uk> <20080208160440.14436.60408.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] KEYS: Add keyctl function to get a security label
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 13 Feb 2008 12:38:39 +0000
Message-ID: <8165.1202906319@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> > +	key_ref = lookup_user_key(NULL, keyid, 0, 1, KEY_VIEW);
> > +	if (IS_ERR(key_ref)) {
> > +		if (PTR_ERR(key_ref) != -EACCES)
> > +			return PTR_ERR(key_ref);
> > +
> > +		/* viewing a key under construction is also permitted if we
> > +		 * have the authorisation token handy */
> > +		instkey = key_get_instantiation_authkey(keyid);
> > +		if (IS_ERR(instkey))
> > +			return PTR_ERR(key_ref);
> > +		key_put(instkey);
> 
> This check looks a wee bit racy?

It's not particularly racy.  Admittedly there's a tiny window in which we can
retrieve the security label of a key for which we had an authorisation token
that got revoked just as we completed our access checks on it.  Does this
matter?

David
