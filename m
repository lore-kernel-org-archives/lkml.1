Return-Path: <linux-kernel-owner+w=401wt.eu-S1758362AbYCAQG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362AbYCAQG0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 11:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbYCAQGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 11:06:16 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:41114 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbYCAQGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 11:06:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TfOEFS3hVXn++DUbCD2J0YE7CSojR5nVydRftSEZCHjOkYlYvua1QQd939KIqjTs/U3dB2jgtLYWRHfilNDaCdoNrBDjBbLKEtv3r5UnfUJ7Pyb/OBa5WlgtSC8m1OQhvEFYDd3hZGLdgxqNngGlr3tO9Oqpc6pcQn/ZKQ9ROYI=
Message-ID: <524f69650803010806m1571df8fiff4b9587b7bf1cc7@mail.gmail.com>
Date: Sat, 1 Mar 2008 10:06:11 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [PATCH][fs/cifs/cifsfs.c] Make use of cifs_xquota_get
Cc: "Roel Kluin" <12o3l@tiscali.nl>, sfrench@samba.org,
       linux-cifs-client@lists.samba.org, samba-technical@lists.samba.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080301093712.GB25835@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47B08A0B.4020604@tiscali.nl>
	 <20080301093712.GB25835@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are quite a few fixes stuck in cifs-2.6.git that are fine to be
merged with mainline but didn't want to bug Linus with multiple merge
requests (there are a couple of more fixes that are not in
cifs-2.6.git pending review)

On Sat, Mar 1, 2008 at 3:37 AM, Adrian Bunk <bunk@kernel.org> wrote:
>
> On Mon, Feb 11, 2008 at 06:46:51PM +0100, Roel Kluin wrote:
>  > Functions cifs_xquota_set and cifs_xquota_get at respectively
>  > fs/cifs/cifsfs.c:367 and 392 are entirely similar - except for
>  > whitespace
>  >
>  > struct quotactl_ops contains function pointers .set_xquota and
>  > .get_xquota that both get the address of cifs_xquota_set.
>  > cifs_xquota_get isn't called anywhere else in the kernel.
>  >
>  > The patch below makes use of the function cifs_xquota_get, As
>  > an alternative the entire function cifs_xquota_get could be
>  > removed.
>  > ---
>  > Make use of cifs_xquota_get
>  >
>  > Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
>  > ---
>  > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>  > index fcc4342..339b829 100644
>  > --- a/fs/cifs/cifsfs.c
>  > +++ b/fs/cifs/cifsfs.c
>  > @@ -461,7 +461,7 @@ int cifs_xstate_get(struct super_block *sb, struct fs_quota_stat *qstats)
>  >
>  >  static struct quotactl_ops cifs_quotactl_ops = {
>  >       .set_xquota     = cifs_xquota_set,
>  > -     .get_xquota     = cifs_xquota_set,
>  > +     .get_xquota     = cifs_xquota_get,
>  >       .set_xstate     = cifs_xstate_set,
>  >       .get_xstate     = cifs_xstate_get,
>  >  };
>
>  Steve, this obvious bugfix seems to be stuck in cifs-2.6.git.
>
>  Can you forward this fix (and other fixes if you have any) to Linus soon?
>
>  TIA
>  Adrian
>
>  --
>
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
>
>
>



-- 
Thanks,

Steve
