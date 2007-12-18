Return-Path: <linux-kernel-owner+w=401wt.eu-S1759399AbXLRQhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399AbXLRQhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 11:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757259AbXLRQhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 11:37:46 -0500
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:44603 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757025AbXLRQhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 11:37:46 -0500
X-YMail-OSG: hxxwdcQVM1lTyAkTXi48pnbk7hfBHwFU39bHYSwestSrgUFEP.24SrW.ptj21XsxYjpXX9mMzg--
Date: Tue, 18 Dec 2007 10:28:54 -0600
From: Michael Halcrow <mike@halcrow.us>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Halcrow <mhalcrow@us.ibm.com>,
       Jarod Wilson <jwilson@redhat.com>
Subject: Re: [PATCH] ecryptfs: fix string overflow on long cipher names
Message-ID: <20071218162854.GN13486@halcrow.us>
Reply-To: Michael Halcrow <mike@halcrow.us>
References: <4767EC73.2030507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4767EC73.2030507@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 09:51:15AM -0600, Eric Sandeen wrote:
> Passing a cipher name > 32 chars on mount results in an overflow
> when the cipher name is printed, because the last character
> in the struct ecryptfs_key_tfm's cipher_name string was never 
> zeroed.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>

I don't think this causes any issues outside of a couple of printk's
on error paths, but this should definitely go into the next -rc.

> ---
> 
> Index: linux-2.6.24-rc3/fs/ecryptfs/crypto.c
> ===================================================================
> --- linux-2.6.24-rc3.orig/fs/ecryptfs/crypto.c
> +++ linux-2.6.24-rc3/fs/ecryptfs/crypto.c
> @@ -1847,6 +1847,7 @@ ecryptfs_add_new_key_tfm(struct ecryptfs
>  	mutex_init(&tmp_tfm->key_tfm_mutex);
>  	strncpy(tmp_tfm->cipher_name, cipher_name,
>  		ECRYPTFS_MAX_CIPHER_NAME_SIZE);
> +	tmp_tfm->cipher_name[ECRYPTFS_MAX_CIPHER_NAME_SIZE] = '\0';
>  	tmp_tfm->key_size = key_size;
>  	rc = ecryptfs_process_key_cipher(&tmp_tfm->key_tfm,
>  					 tmp_tfm->cipher_name,
> 
> 
> 
