Return-Path: <linux-kernel-owner+w=401wt.eu-S1759363AbYGRMah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363AbYGRMah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756866AbYGRMaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:30:13 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:54914 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715AbYGRMaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:30:12 -0400
Message-ID: <48808E14.8050801@suse.de>
Date: Fri, 18 Jul 2008 18:05:32 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: sfrench@samba.org, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: fix compiler warning on 64-bit arch-s
References: <4880A5A9.76E4.0078.0@novell.com>
In-Reply-To: <4880A5A9.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  fs/cifs/asn1.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.26/fs/cifs/asn1.c	2008-07-13 23:51:29.000000000 +0200
> +++ 2.6.26-cifs-warning/fs/cifs/asn1.c	2008-07-17 15:23:11.000000000 +0200
> @@ -400,7 +400,7 @@ asn1_oid_decode(struct asn1_ctx *ctx,
>  	size = eoc - ctx->pointer + 1;
>  
>  	/* first subid actually encodes first two subids */
> -	if (size < 2 || size > ULONG_MAX/sizeof(unsigned long))
> +	if (size < 2 || size > UINT_MAX/sizeof(unsigned long))
>  		return 0;
>  
>  	*oid = kmalloc(size * sizeof(unsigned long), GFP_ATOMIC);
> 
> 

I did see the following patch from David Howells attempting to fix the 
same warning posted a little earlier.

Fix the CIFS range check to always use a big enough size variable that 
the compiler won't moan about comparing it to ULONG_MAX/8 on a 64-bit 
platform.

Signed-off-by: David Howells <dhowells@redhat.com>
---

  fs/cifs/asn1.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/fs/cifs/asn1.c b/fs/cifs/asn1.c
index f58e41d..512587d 100644
--- a/fs/cifs/asn1.c
+++ b/fs/cifs/asn1.c
@@ -394,8 +394,8 @@ asn1_oid_decode(struct asn1_ctx *ctx,
  		unsigned char *eoc, unsigned long **oid, unsigned int *len)
  {
  	unsigned long subid;
-	unsigned int size;
  	unsigned long *optr;
+	size_t size;

  	size = eoc - ctx->pointer + 1;


Thanks,

-- 
Suresh Jayaraman
