Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbZBPUCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbZBPUCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 15:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbZBPUCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 15:02:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751018AbZBPUCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 15:02:14 -0500
Date: Mon, 16 Feb 2009 12:02:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: Re: [patch 7/8] ecryptfs: use kzfree()
Message-Id: <20090216120204.44f78aa2.akpm@linux-foundation.org>
In-Reply-To: <20090216144726.088020837@cmpxchg.org>
References: <20090216142926.440561506@cmpxchg.org>
	<20090216144726.088020837@cmpxchg.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009 15:29:33 +0100 Johannes Weiner <hannes@cmpxchg.org> wrote:

> --- a/fs/ecryptfs/keystore.c
> +++ b/fs/ecryptfs/keystore.c
> @@ -740,8 +740,7 @@ ecryptfs_write_tag_70_packet(char *dest,
>  out_release_free_unlock:
>  	crypto_free_hash(s->hash_desc.tfm);
>  out_free_unlock:
> -	memset(s->block_aligned_filename, 0, s->block_aligned_filename_size);
> -	kfree(s->block_aligned_filename);
> +	kzfree(s->block_aligned_filename);
>  out_unlock:
>  	mutex_unlock(s->tfm_mutex);
>  out:
> --- a/fs/ecryptfs/messaging.c
> +++ b/fs/ecryptfs/messaging.c
> @@ -291,8 +291,7 @@ int ecryptfs_exorcise_daemon(struct ecry
>  	if (daemon->user_ns)
>  		put_user_ns(daemon->user_ns);
>  	mutex_unlock(&daemon->mux);
> -	memset(daemon, 0, sizeof(*daemon));
> -	kfree(daemon);
> +	kzfree(daemon);
>  out:
>  	return rc;
>  }

Except for this one and the crypto one, which might have been done for
security reasons.

Even though both of them forgot to add a comment explaining this, which
is bad, wrong, stupid and irritating.  Sigh.
