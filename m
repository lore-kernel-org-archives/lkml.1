Return-Path: <linux-kernel-owner+w=401wt.eu-S1762743AbYBLXwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762743AbYBLXwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbYBLXwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:52:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43196 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484AbYBLXwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:52:15 -0500
Date: Tue, 12 Feb 2008 15:51:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
Subject: Re: [PATCH 4/4] KEYS: Add keyctl function to get a security label
Message-Id: <20080212155137.d07f80b7.akpm@linux-foundation.org>
In-Reply-To: <20080208160440.14436.60408.stgit@warthog.procyon.org.uk>
References: <20080208160424.14436.6965.stgit@warthog.procyon.org.uk>
	<20080208160440.14436.60408.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Feb 2008 16:04:40 +0000
David Howells <dhowells@redhat.com> wrote:

> +	key_ref = lookup_user_key(NULL, keyid, 0, 1, KEY_VIEW);
> +	if (IS_ERR(key_ref)) {
> +		if (PTR_ERR(key_ref) != -EACCES)
> +			return PTR_ERR(key_ref);
> +
> +		/* viewing a key under construction is also permitted if we
> +		 * have the authorisation token handy */
> +		instkey = key_get_instantiation_authkey(keyid);
> +		if (IS_ERR(instkey))
> +			return PTR_ERR(key_ref);
> +		key_put(instkey);

This check looks a wee bit racy?
