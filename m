Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbYFVSiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbYFVSiJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 14:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbYFVSh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 14:37:58 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:62792 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbYFVSh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 14:37:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kSNQLSssCZo/T+tohEwjlSuzeywY+IuWNF7w6/dZKzZtFd5kQZ3qsR831aGYr3LoGZ
         IuK3HYrY0PP4n7znELhYugf9oKqIh7V9LkDF221SYpGL7fB8r/D6Ro6ERy0cePBcxGS3
         PkU1F9tr9m1NQovlEQVcQPEhlriy4SlpNcbrM=
Message-ID: <524f69650806221137u79aee360xb70aea7f9ccefc4b@mail.gmail.com>
Date: Sun, 22 Jun 2008 13:37:55 -0500
From: "Steve French" <smfrench@gmail.com>
To: chrisw@sous-sol.org
Subject: Re: [PATCH]: Supress a `comparison is always false' warning in fs/cifs/asn1.c
Cc: "Suresh Jayaraman" <sjayaraman@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <484F7B80.2030306@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <484F7B80.2030306@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,
Although this check seems harmless, shrinking the range to uint from
ulong makes sense as Suresh suggested and I was planning on adding
this to the cifs-2.6.git tree - but was not sure if you would prefer
to change both locations at once.

On Wed, Jun 11, 2008 at 2:15 AM, Suresh Jayaraman <sjayaraman@suse.de> wrote:
> On x86_64, I get this warning:
>
> fs/cifs/asn1.c: In function `asn1_oid_decode':
> fs/cifs/asn1.c:403: warning: comparison is always false due to limited
> range of data type
>
> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
> ---
>
> diff --git a/fs/cifs/asn1.c b/fs/cifs/asn1.c
> index f58e41d..4bdf809 100644
> --- a/fs/cifs/asn1.c
> +++ b/fs/cifs/asn1.c
> @@ -400,7 +400,7 @@ asn1_oid_decode(struct asn1_ctx *ctx,
>        size = eoc - ctx->pointer + 1;
>
>        /* first subid actually encodes first two subids */
> -       if (size < 2 || size > ULONG_MAX/sizeof(unsigned long))
> +       if (size < 2 || size > UINT_MAX/sizeof(unsigned int))
>                return 0;
>
>        *oid = kmalloc(size * sizeof(unsigned long), GFP_ATOMIC);
>
>



-- 
Thanks,

Steve
