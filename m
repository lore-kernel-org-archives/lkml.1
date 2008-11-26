Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYKZVtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYKZVtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 16:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbYKZVtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 16:49:09 -0500
Received: from rn-out-0910.google.com ([64.233.170.191]:6613 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbYKZVtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 16:49:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WBAnLPPzXlivNAr4+ipIU54aL4ccJFxb3si8TI2IdMH7rWjbEdrVyYSgMRP9DoG3G2
         Wdaj3b1Fc7vCCmX9iWzsdn+5hCKgl6qLaXoBeBD+WPJejbx1nSNIab6PndduuLilWCdY
         0dbDXVcYTRdtZlQy8GEJuVVjS9gGNUE6K5feU=
Subject: Re: [PATCH-mm 8/8] decnet: remove private wrappers of endian
 helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: steve@chygwyn.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       linux-netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081126213359.GA20782@fogou.chygwyn.com>
References: <1227733974.5511.130.camel@brick>
	 <20081126213359.GA20782@fogou.chygwyn.com>
Content-Type: text/plain
Date: Wed, 26 Nov 2008 13:49:04 -0800
Message-Id: <1227736144.5511.131.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-26 at 21:33 +0000, steve@chygwyn.com wrote:
> Hi,
> 
> On Wed, Nov 26, 2008 at 01:12:54PM -0800, Harvey Harrison wrote:
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> [snip]
> > diff --git a/include/net/dn_fib.h b/include/net/dn_fib.h
> > index 3012511..c378be7 100644
> > --- a/include/net/dn_fib.h
> > +++ b/include/net/dn_fib.h
> > @@ -181,9 +181,9 @@ static inline void dn_fib_res_put(struct dn_fib_res *res)
> >  
> >  static inline __le16 dnet_make_mask(int n)
> >  {
> > -        if (n)
> > -                return dn_htons(~((1<<(16-n))-1));
> > -        return 0;
> > +	if (n)
> > +		return cpu_to_le16(~((1 << (16 - n)) - 1));
> > +	return cpu_to_le16(0);
> >  }
> You don't need to convert 0.

Tell that to sparse ;-)

> 
> [snip]
> >  
> > @@ -327,7 +327,7 @@ int dn_username2sockaddr(unsigned char *data, int len, struct sockaddr_dn *sdn,
> >  	int namel = 12;
> >  
> >  	sdn->sdn_objnum = 0;
> > -	sdn->sdn_objnamel = dn_htons(0);
> > +	sdn->sdn_objnamel = cpu_to_le16(0);
> Again, no need to convert 0 even though I did :-)

Again, sparse appreciates it.

> 
> Otherwise the patch looks good.
> 
> Reviewed-by: Steven Whitehouse <swhiteho@redhat.com>
> 

Thanks.

Harvey

