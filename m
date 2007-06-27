Return-Path: <linux-kernel-owner+w=401wt.eu-S1761942AbXF0O7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761942AbXF0O7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 10:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759710AbXF0O7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 10:59:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57247 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759633AbXF0O7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 10:59:13 -0400
Date: Wed, 27 Jun 2007 15:59:10 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Josh Triplett <josht@linux.vnet.ibm.com>
Cc: Neil Booth <neil@daikokuya.co.uk>, Josh Triplett <josh@freedesktop.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Message-ID: <20070627145910.GU21478@ftp.linux.org.uk>
References: <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org> <20070624203837.GE21478@ftp.linux.org.uk> <467F531A.3030702@freedesktop.org> <20070626221040.GI21478@ftp.linux.org.uk> <20070626221134.GA21350@ftp.linux.org.uk> <20070627121021.GQ7590@daikokuya.co.uk> <20070627123031.GO21478@ftp.linux.org.uk> <20070627125958.GA16758@daikokuya.co.uk> <20070627131823.GR21478@ftp.linux.org.uk> <1182955818.8970.28.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182955818.8970.28.camel@josh-work.beaverton.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 07:50:18AM -0700, Josh Triplett wrote:
> On Wed, 2007-06-27 at 14:18 +0100, Al Viro wrote:
> > --- a/expand.c
> > +++ b/expand.c
> [...]
> > @@ -488,12 +490,15 @@ static int expand_conditional(struct expression *expr)
> > 
> >  	cond_cost = expand_expression(cond);
> >  	if (cond->type == EXPR_VALUE) {
> > +		unsigned flags = expr->flags;
> >  		if (!cond->value)
> >  			true = false;
> >  		if (!true)
> >  			true = cond;
> > +		cost = expand_expression(*true);
> >  		*expr = *true;
> > -		return expand_expression(expr);
> > +		expr->flags = flags;
> > +		return cost;
> 
> This passes an incorrect type to expand_expression; it wants a struct
> expression *, but *true has type struct expression; did you want to pass
> true rather than *true?

Gah...  Yes, of course.  Sorry about that...
