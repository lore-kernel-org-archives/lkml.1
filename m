Return-Path: <linux-kernel-owner+w=401wt.eu-S933239AbZHDSWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239AbZHDSWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 14:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933192AbZHDSWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 14:22:54 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35604 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933160AbZHDSWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 14:22:53 -0400
Date: Tue, 4 Aug 2009 13:22:54 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 3/6] KEYS: Flag dead keys to induce EKEYREVOKED
Message-ID: <20090804182254.GB8442@us.ibm.com>
References: <20090804145530.17676.24656.stgit@warthog.procyon.org.uk> <20090804145541.17676.99745.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804145541.17676.99745.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Set the KEY_FLAG_DEAD flag on keys for which the type has been removed.  This
> causes the key_permission() function to return EKEYREVOKED in response to
> various commands.  It does not, however, prevent unlinking or clearing of
> keyrings from detaching the key.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
> 
>  security/keys/key.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/security/keys/key.c b/security/keys/key.c
> index 3762d5b..bd9d267 100644
> --- a/security/keys/key.c
> +++ b/security/keys/key.c
> @@ -956,8 +956,10 @@ void unregister_key_type(struct key_type *ktype)
>  	for (_n = rb_first(&key_serial_tree); _n; _n = rb_next(_n)) {
>  		key = rb_entry(_n, struct key, serial_node);
> 
> -		if (key->type == ktype)
> +		if (key->type == ktype) {
>  			key->type = &key_type_dead;
> +			set_bit(KEY_FLAG_DEAD, &key->flags);
> +		}
>  	}
> 
>  	spin_unlock(&key_serial_lock);
