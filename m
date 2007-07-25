Return-Path: <linux-kernel-owner+w=401wt.eu-S1763354AbXGYW7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763354AbXGYW7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 18:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759442AbXGYW7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 18:59:33 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:51653 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757040AbXGYW7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 18:59:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lL9lmuvHR0vy7kQLkBWSK37kpHlbv6thzc1mPaicw713bgw/u5+PpTk4kIotJ6wEyigXY7coX4JZLM1TPddCoW+T5hU1KCKo+2q8ZffF4+oS0Y3s+X7WxXS7CFX8awodoxVKTn/MAFNxVSL3dg7u2cd6i33csHoGEtsBZTy1XTI=
Message-ID: <a781481a0707251559n1fc8bb1y343e980deb25377b@mail.gmail.com>
Date: Thu, 26 Jul 2007 04:29:31 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Michael Halcrow" <mhalcrow@us.ibm.com>
Subject: Re: [PATCH 4/7] eCryptfs: Comments for some structs
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, toml@us.ibm.com
In-Reply-To: <20070725205135.GU14091@halcrow.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070725204855.GQ14091@halcrow.austin.ibm.com>
	 <20070725205135.GU14091@halcrow.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial nits ...

On 7/26/07, Michael Halcrow <mhalcrow@us.ibm.com> wrote:
> [...]
> +/**
> + * ecryptfs_global_auth_tok structs refer to authentication token keys
> + * in the user keyring that apply to newly created files. A list of
> + * these objects hangs off of the mount_crypt_stat struct for any
> + * given eCryptfs mount. This struct maintains a reference to both the
> + * key contents and the key itself so that the key can be put on
> + * unmount.
> + */

/** is used to annotate kernel-doc style comments, which this
one isn't -- IIRC, kernel-doc doesn't like this (?)

>  struct ecryptfs_global_auth_tok {
>  #define ECRYPTFS_AUTH_TOK_INVALID 0x00000001
>         u32 flags;
> -       struct list_head mount_crypt_stat_list;
> -       struct key *global_auth_tok_key;
> -       struct ecryptfs_auth_tok *global_auth_tok;
> -       unsigned char sig[ECRYPTFS_SIG_SIZE_HEX + 1];

> +       struct list_head mount_crypt_stat_list; /* Default auth_tok list for
> +                                                * the mount_crypt_stat */
> +       struct key *global_auth_tok_key; /* The key from the user's keyring for
> +                                         * the sig */

Tsk. You could consider using kernel-doc style itself to comment the
structure -- this stuff goes up there and doesn't look icky.

> +       struct ecryptfs_auth_tok *global_auth_tok; /* The key contents */
> +       unsigned char sig[ECRYPTFS_SIG_SIZE_HEX + 1]; /* The key identifier */
>  };
>
> +/**
> + * Typically, eCryptfs will use the same ciphers repeatedly throughout
> + * the course of its operations. In order to avoid unnecessarily
> + * destroying and initializing the same cipher repeatedly, eCryptfs
> + * keeps a list of crypto API contexts around to use when needed.
> + */

Again, you could consider using kernel-doc style comments here.

>  struct ecryptfs_key_tfm {
>         struct crypto_blkcipher *key_tfm;
>         size_t key_size;
>         struct mutex key_tfm_mutex;
> -       struct list_head key_tfm_list;
> +       struct list_head key_tfm_list; /* The module's tfm list */
>         unsigned char cipher_name[ECRYPTFS_MAX_CIPHER_NAME_SIZE + 1];
>  };


Satyam
