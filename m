Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbXJINDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbXJINDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 09:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbXJIND2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 09:03:28 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:30175 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbXJIND1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 09:03:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=E9CGeHLM9M2t5R54H7zbLtULrQLG8VXMA/iU9VPGGlVvDN7dDaIQ8J24AYhXslQvkhJyIcVWgozcIwzZIO8RQKgpJZ6n4IHyY827vdkkhyi/GOKaW/RD4Zj0Q6cTx7mjmXwvTb3gdhrgFV29RN4PzOn8cxjOPk7aqV1rP2IdhcU=
Date: Tue, 9 Oct 2007 15:03:15 +0200
To: Rob Landley <rob@landley.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       rdunlap@xenotime.net
Subject: Re: [PATCH] Stop docproc segfaulting when SRCTREE isn't set.
Message-ID: <20071009130315.GB4245@Ahmed>
References: <200710090125.19089.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710090125.19089.rob@landley.net>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Tue, Oct 09, 2007 at 01:25:18AM -0500, Rob Landley wrote:
[...]
>  	FILE * infile;
> +
> +	srctree = getenv("SRCTREE");
> +	if (!srctree) srctree = getcwd(NULL,0);
>  	if (argc != 3) {
>  		usage();
>  		exit(1);

$ man getcwd

 char *getcwd(char *buf, size_t size);
      
 As an extension to the POSIX.1 standard, Linux (libc4, libc5, glibc) getcwd() 
 allocates the buffer dynamically using malloc() if buf is NULL on call.

Shouldn't "srctree" be free()ed in case getenv("SRCTREE") failed ?

Regards,

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
