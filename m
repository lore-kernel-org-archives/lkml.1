Return-Path: <linux-kernel-owner+w=401wt.eu-S1753204AbYHMEYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbYHMEYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 00:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbYHMEX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 00:23:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:15361 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbYHMEX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 00:23:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Pt+vVsNT5f6hzJTEnh9zyrFAA4AeWtpJ58fv+WklwOHy64C+DQmUiVB1eP+0vfzUVn
         uj1sbrQjcFo+adCYm197QazgxK+nCF09v+jpy99+DJebgWfY2J/vL+51+UfkQT6QLhXK
         YSkUHaD9iDk8aiVYAZQySIh7VzbIWkyD7Pw+s=
Subject: Re: [PATCH] tipc: Use the appropriate swab helper rather than an
	internal helper
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       per.liden@ericsson.com, jon.maloy@ericsson.com,
       allan.stephens@windriver.com
In-Reply-To: <20080812212017.febf1392.akpm@linux-foundation.org>
References: <1218587234.30194.93.camel@brick>
	 <20080812205422.4273d598.akpm@linux-foundation.org>
	 <1218600348.30194.105.camel@brick>
	 <20080812212017.febf1392.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 21:23:59 -0700
Message-Id: <1218601440.30194.108.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-12 at 21:20 -0700, Andrew Morton wrote:
> On Tue, 12 Aug 2008 21:05:47 -0700 Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > ___generally means I am an internal implementation detail, don't use
> > me.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> > Sorry for breaking the build Andrew, my testing has been with all the __constant
> > versions in-tree removed.
> > 
> >  net/tipc/subscr.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/net/tipc/subscr.c b/net/tipc/subscr.c
> > index 0326d30..f5da05d 100644
> > --- a/net/tipc/subscr.c
> > +++ b/net/tipc/subscr.c
> > @@ -85,7 +85,7 @@ static struct top_srv topsrv = { 0 };
> >  
> >  static u32 htohl(u32 in, int swap)
> >  {
> > -	return swap ? (u32)___constant_swab32(in) : in;
> > +	return swap ? (u32)swab32(in) : in;
> >  }
> 
> yes, that's what I did too, only I dropped the
> seems-to-me-to-be-unneeded (u32) cast.

I made the mistake of folding this bit into the series that removes all
users of the __constant_ helpers as I forgot it was a build breaker.
That's why I wasn't seeing it here.

Harvey

