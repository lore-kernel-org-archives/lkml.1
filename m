Return-Path: <linux-kernel-owner+w=401wt.eu-S1762860AbYCDAUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762860AbYCDAUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 19:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbYCDAU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 19:20:26 -0500
Received: from ozlabs.org ([203.10.76.45]:43407 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbYCDAU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 19:20:26 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Eugene Teo <eugeneteo@kernel.sg>
Subject: Re: [PATCH] lguest: make sure cpu is initialized before accessing it
Date: Tue, 4 Mar 2008 11:19:44 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, lguest@ozlabs.org
References: <20080209155317.GA12841@kernel.sg> <200803041015.48290.rusty@rustcorp.com.au>
In-Reply-To: <200803041015.48290.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803041119.44283.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2008 10:15:47 Rusty Russell wrote:
> On Sunday 10 February 2008 02:53:17 Eugene Teo wrote:
> > If req is LHREQ_INITIALIZE, and the guest has been initialized before
> > (unlikely), it will attempt to access cpu->tsk even though cpu is not yet
> > initialized.
> >
> > Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>

Thanks Eugene, I've applied this with some wrapping of the comments and 
removal of the now-redundant lg != NULL tests:

> > +		/* Once the Guest is dead, all you can do is read() why it died. */
> > +		if (lg && lg->dead)
> > +			return -ENOENT;
> >
> > -	/* If you're not the task which owns the Guest, you can only break */
> > -	if (lg && current != cpu->tsk && req != LHREQ_BREAK)
> > -		return -EPERM;
> > +		/* If you're not the task which owns the Guest, you can only break */
> > +		if (lg && current != cpu->tsk && req != LHREQ_BREAK)
> > +			return -EPERM;
> > +	}

Cheers,
Rusty.
