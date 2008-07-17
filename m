Return-Path: <linux-kernel-owner+w=401wt.eu-S932413AbYGQUBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbYGQUBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 16:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756666AbYGQUAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 16:00:54 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:34311 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbYGQUAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 16:00:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eobUXdfJsA3u9iEmdSwqnzGNlmMMJez61OLq6BLIZTKaXrdZZHei/hxmUIvHyAWtnM
         YlTQTSmSif5tucB0CAHPQaFck01O1DmjvZXjGPJvzFpRW32ZbkdowNwul6JfuY2GTOzp
         pF4o2unC5ntHgz8TVNuhLxRFlTVeQnmrGXcjo=
Subject: Re: [PATCH] dlm: sparse endian annotations
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Teigland <teigland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080716221201.GM28946@ZenIV.linux.org.uk>
References: <1216239367.28841.22.camel@brick>
	 <20080716213801.GK28946@ZenIV.linux.org.uk>
	 <1216244621.28841.35.camel@brick>
	 <20080716221201.GM28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 13:00:51 -0700
Message-Id: <1216324852.6029.13.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-16 at 23:12 +0100, Al Viro wrote:
> On Wed, Jul 16, 2008 at 02:43:41PM -0700, Harvey Harrison wrote:
> > On Wed, 2008-07-16 at 22:38 +0100, Al Viro wrote:
> > > On Wed, Jul 16, 2008 at 01:16:07PM -0700, Harvey Harrison wrote:
> > > 
> > > 
> > > NAK on ones below.  You are only hiding the warnings; ...s() is not making
> > > it any better.
> > > 
> > 
> > I'd suggest that any use of {endian}s() points to code that should be
> > looked at.  But if you'd also rather have the warnings, so be it.
> 
> Frankly, I would rather have the rest of byteswaps in dlm eliminated...

I am curious though, in the general case of taking stuff off the wire
and doing work on it in-place.  Would you suggest two structs for things
like this, one in cpu-order and one with the endian annotations, then
the one place where you receive can do appropriate endian conversion
using a pointer to a wire-endian struct and the rest of the code just
uses the cpu-endian struct everywhere?

Just a general design question.

In the DLM case, these util functions are only used in 1-2 places each
so it wouldn't be too bad to fold them into the receive/send paths, but
you still need to byteswap somewhere, just curious what you are
suggesting.

Harvey

