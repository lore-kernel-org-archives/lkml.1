Return-Path: <linux-kernel-owner+w=401wt.eu-S934824AbXHAPSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934824AbXHAPSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934616AbXHAPR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:17:59 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:43414 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934567AbXHAPR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:17:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=sqHNaiwiO/eNCJKT0XUkIJ1zw6YbTSIpB31GSH1dblXFBz+JYeOFBRNP/H5Jy2fzDnulbLKOOpTII1QImrL7xg+7erpSYkMIO071G9xKUZLPWd/eC2o0BVFrCBsZov+9qbpdaUsO5lAbsQazCXvp7EOqGJAwaiE+F/ILAMBG03E=
Message-ID: <46B0A41E.50707@gmail.com>
Date: Thu, 02 Aug 2007 00:17:50 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 007 of 35] Drop 'size' argument from bio_endio and bi_end_io.
References: <20070731112539.22428.patches@notabene> <1070731021622.25177@suse.de>
In-Reply-To: <1070731021622.25177@suse.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

NeilBrown wrote:
> As bi_end_io is only called once when the reqeust is compelte,
> the 'size' argument is now redundant.  Remove it.
> 
> Now there is no need for bio_endio to subtract the size completed
> from bi_size.  So don't do that either.
> 
> While we are at it, change bi_end_io to return void.
> 
> Signed-off-by: Neil Brown <neilb@suse.de>
> 
> @@ -538,14 +538,10 @@ static int flush_dry_bio_endio(struct bi
>  
>  	/* Reset bio */
>  	set_bit(BIO_UPTODATE, &bio->bi_flags);
> -	bio->bi_size = bytes;
> -	bio->bi_sector -= (bytes >> 9);
> -
> -	return 0;
>  }

Please adjust comment together.  Just keeping /* Reset bio */ and
killing the comment above it should be enough.  Other than that, nice
clean up!

Thanks.

-- 
tejun
