Return-Path: <linux-kernel-owner+w=401wt.eu-S1760977AbXEJUkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760977AbXEJUkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbXEJUkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:40:37 -0400
Received: from merkurneu.hrz.uni-giessen.de ([134.176.2.3]:58811 "EHLO
	merkurneu.hrz.uni-giessen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755528AbXEJUkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:40:36 -0400
From: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-mm2
Date: Thu, 10 May 2007 22:40:12 +0200
User-Agent: KMail/1.9.5
References: <20070509012322.199f292b.akpm@linux-foundation.org> <200705101811.43635.marc.dietrich@ap.physik.uni-giessen.de> <20070510122241.0b28c18a.akpm@linux-foundation.org>
In-Reply-To: <20070510122241.0b28c18a.akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705102240.12661.marc.dietrich@ap.physik.uni-giessen.de>
X-HRZ-JLUG-MailScanner-Information: Passed JLUG virus check
X-HRZ-JLUG-MailScanner: No virus found
X-MailScanner-From: marc.dietrich@ap.physik.uni-giessen.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Am Donnerstag, 10. Mai 2007 21:22 schrieben Sie:
> On Thu, 10 May 2007 18:11:35 +0200 Marc Dietrich 
<Marc.Dietrich@ap.physik.uni-giessen.de> wrote:
> > Hi,
> >
> > since -mm1 I cannot create files on nfs4 shares.
> >
> > #me@localhost:/home: touch t
> > touch: setting times of `t': Input/output error
> > #me@localhost:/home: dmesg|tail -n1
> > decode_attr_group: reply buffer overflowed in line 2676.
> >
> > This problem was reported before in a different thread, but no
> > reaction....
> >
> > http://marc.info/?l=linux-kernel&m=117837974628893&w=2
>
> We had one regression there which was fixed by the below patch.
>
> That fix is now in Linus's git tree but it was not present in 2.6.21-mm2.
>
> So can you please retest either current -linus, or 2.6.21-mm2 with this
> patch?
>
> commit 6ce7dc940701cf3fde3c6e826a696b333092cbb1
> Author: Chuck Lever <chuck.lever@oracle.com>
> Date:   Tue May 8 18:23:28 2007 -0400
>
>     NFS: NFS client underestimates how large an NFSv4 SETATTR reply can be
>
>     The maximum size of an NFSv4 SETATTR compound reply should include the
>     GETATTR operation that we send.
>
>     Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>     Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
>
> diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
> index b8c28f2..f1e2b8c 100644
> --- a/fs/nfs/nfs4xdr.c
> +++ b/fs/nfs/nfs4xdr.c
> @@ -224,7 +224,8 @@ #define NFS4_enc_setattr_sz     (compoun
>                                  encode_getattr_maxsz)
>  #define NFS4_dec_setattr_sz     (compound_decode_hdr_maxsz + \
>                                  decode_putfh_maxsz + \
> -                                op_decode_hdr_maxsz + 3)
> +                                op_decode_hdr_maxsz + 3 + \
> +                                nfs4_fattr_maxsz)
>  #define NFS4_enc_fsinfo_sz	(compound_encode_hdr_maxsz + \
>  				encode_putfh_maxsz + \
>  				encode_fsinfo_maxsz)
>

works! Seems I have missed that.

Marc

