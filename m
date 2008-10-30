Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbYJ3FlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbYJ3FlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 01:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYJ3Fk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 01:40:59 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:64339 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbYJ3Fk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 01:40:59 -0400
Date: Thu, 30 Oct 2008 11:02:44 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zan Lynx <zlynx@acm.org>, linux-kernel@vger.kernel.org, jack@suse.cz
Subject: Re: 2.6.28-rc2-mm1: Build failure on fs/quota.o
Message-ID: <20081030053244.GA4870@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20081028233836.8b1ff9ae.akpm@linux-foundation.org> <4908EA82.8090308@acm.org> <20081029161626.1fa5acb0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081029161626.1fa5acb0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2008-10-29 16:16:26]:

> On Wed, 29 Oct 2008 16:58:10 -0600
> Zan Lynx <zlynx@acm.org> wrote:
> 
> > Andrew Morton wrote:
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.28-rc2/2.6.28-rc2-mm1/
> > > 
> > > - Various architectures don't compile very well.  ia64, alpha, s390,
> > >   arm.  ftrace seems to be a particular culprit.
> > > 
> > > - But it seems to work OK on the six machines I ran it on.
> > > 
> > 
> > Here is the error:
> > 
> >   CC      fs/quota.o
> > fs/quota.c: In function ___generic_quotactl_valid___:
> > fs/quota.c:76: error: implicit declaration of function ___sb_has_quota_active___
> > make[1]: *** [fs/quota.o] Error 1
> > make: *** [fs] Error 2
> 
> Thanks.

Thanks, the patch fixes the build failure.

> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> fs/quota.c: In function `generic_quotactl_valid':
> fs/quota.c:76: error: implicit declaration of function `sb_has_quota_active'
> 
> Cc: Jan Kara <jack@suse.cz>
> Reported-by: Zan Lynx <zlynx@acm.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
  Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> ---
> 
>  include/linux/quotaops.h |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff -puN include/linux/quotaops.h~quota-permit-separately-enabling-quota-accounting-and-enforcing-limits-fix include/linux/quotaops.h
> --- a/include/linux/quotaops.h~quota-permit-separately-enabling-quota-accounting-and-enforcing-limits-fix
> +++ a/include/linux/quotaops.h
> @@ -257,6 +257,11 @@ static inline int sb_any_quota_loaded(st
>  	return 0;
>  }
> 
> +static inline int sb_has_quota_active(struct super_block *sb, int type)
> +{
> +	return 0;
> +}
> +
>  static inline int sb_any_quota_active(struct super_block *sb)
>  {
>  	return 0;
> _
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
