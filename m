Return-Path: <linux-kernel-owner+w=401wt.eu-S1030603AbXDJUom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030603AbXDJUom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 16:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030614AbXDJUom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 16:44:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:10515 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030603AbXDJUol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 16:44:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Sjf7atc/U7KTABzObiQDE4LDLjynEhM5QECghnW1+ddaTNisgevWHVdJVM1Hb67uAllXic+e4f43tf9GvCcJ/cGf1hTtLILZoSbJ21YiRy6Kar6dYrNDdXbw8heEvgHb5wUvpvIhGPHLFBMEohszFEUbMtczF8WtX3S+oa18SVA=
Date: Wed, 11 Apr 2007 00:45:27 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add spaces on either side of case "..." operator.
Message-ID: <20070410204527.GB5840@martell.zuzino.mipt.ru>
References: <Pine.LNX.4.64.0704100721050.13729@CPE00045a9c397f-CM001225dbafb6> <20070410090555.d847d466.akpm@linux-foundation.org> <461BCDA9.2060206@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461BCDA9.2060206@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 10:47:21AM -0700, Jeremy Fitzhardinge wrote:
> Andrew Morton wrote:
> > #define AUDIT_FIRST_USER_MSG    1100    /* Userspace messages mostly uninteresting to kernel */
> > #define AUDIT_USER_AVC          1107    /* We filter this differently */
> > #define AUDIT_LAST_USER_MSG     1199
> >
> > and CPP turns that into
> >
> >  case 1100 ...1199:
> >  case 2100 ...2999:
> >
> > and it does the same when the comments are stripped from the #defines.
> >
> > So we were saved by the trailing space which cpp added to the expanded
> > macro.  I wonder why cpp did that, and to what extent one can rely cpp
> > doing that.
>
> I think its required to.  If it didn't, it would be effectively pasting
> two tokens together without the ## operator.

Internally, there are lists of tokens and no ambiguities. What gcc docs
warn about is that

	case 1...2:

will be parsed as

	case
	[space]
	1.
	.
	.2
	:

which won't fly.

> But putting spaces in is safer - or putting () around the numbers.

