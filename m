Return-Path: <linux-kernel-owner+w=401wt.eu-S1762970AbYBLKgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762970AbYBLKgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 05:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761957AbYBLKg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 05:36:29 -0500
Received: from twin.jikos.cz ([213.151.79.26]:44238 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761938AbYBLKg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 05:36:28 -0500
Date: Tue, 12 Feb 2008 11:35:02 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] Avoid buffer overflows in get_user_pages()
In-Reply-To: <20080211234628.b5533b87.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0802121133090.7699@twin.jikos.cz>
References: <5758.1202771853@vena.lwn.net> <20080211234628.b5533b87.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008, Andrew Morton wrote:

> > +	if (len <= 0)
> > +		return 0;
> >  	/* 
> >  	 * Require read or write permissions.
> >  	 * If 'force' is set, we only require the "MAY" flags.
> Can we just convert
> 	do {
> 		...
> 	} while (len);
> into
> 	while (len) {
> 		...
> 	}

How would that help?

Rather

	while (len > 0) {
		...
	}

would do the trick.

-- 
Jiri Kosina
