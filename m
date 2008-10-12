Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbYJLLtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbYJLLtU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 07:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYJLLtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 07:49:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36421 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbYJLLtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 07:49:11 -0400
Date: Sun, 12 Oct 2008 07:48:22 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve French <sfrench@us.ibm.com>, linux-cifs-client@lists.samba.org
Subject: Re: [2.6 patch] add key_revoke() dummy for KEYS=n
Message-ID: <20081012074822.5caf32c5@tleilax.poochiereds.net>
In-Reply-To: <20081012041050.GB31153@cs181140183.pp.htv.fi>
References: <20081012041050.GB31153@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Oct 2008 07:10:50 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> This patch fixes the following build error with CONFIG_KEYS=n, caused by
> commit dfd15c46a6c2cafb006183c0c14f07e59eee4ac0
> (cifs: explicitly revoke SPNEGO key after session setup):
> 
> <--  snip  -->
> 
> ...
>   CC [M]  fs/cifs/sess.o
> fs/cifs/sess.c: In function 'CIFS_SessSetup':
> fs/cifs/sess.c:628: error: implicit declaration of function 'key_revoke'
> make[3]: *** [fs/cifs/sess.o] Error 1
> 
> <--  snip  -->
> 
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
> diff --git a/include/linux/key.h b/include/linux/key.h
> index c45c962..1b70e35 100644
> --- a/include/linux/key.h
> +++ b/include/linux/key.h
> @@ -299,6 +299,7 @@ extern void key_init(void);
>  #define key_validate(k)			0
>  #define key_serial(k)			0
>  #define key_get(k) 			({ NULL; })
> +#define key_revoke(k)			do { } while(0)
>  #define key_put(k)			do { } while(0)
>  #define key_ref_put(k)			do { } while(0)
>  #define make_key_ref(k, p)			({ NULL; })
> 

Acked-by: Jeff Layton <jlayton@redhat.com>
