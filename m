Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbYH1CWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbYH1CWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 22:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbYH1CWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 22:22:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35602 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbYH1CWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 22:22:39 -0400
Date: Thu, 28 Aug 2008 03:22:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: dhowells@redhat.com, harvey.harrison@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] afs: fsclient.c sparse endian annotations of
	operation_ID
Message-ID: <20080828022230.GF28946@ZenIV.linux.org.uk>
References: <1219788326.6069.40.camel@brick> <28254.1219835544@redhat.com> <20080827.041705.160546703.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827.041705.160546703.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 04:17:05AM -0700, David Miller wrote:
> From: David Howells <dhowells@redhat.com>
> Date: Wed, 27 Aug 2008 12:12:24 +0100
> 
> > Harvey Harrison <harvey.harrison@gmail.com> wrote:
> > 
> > > +		if (call->operation_ID != __constant_htonl(FSFETCHDATA64)) {
> > 
> > Doesn't htonl() resolve to this for a constant argument?  Following through
> > the definitions, it certainly looks like it ought to:
> 
> Yes it does.
> 
> The __constant_*() interfaces should only be uses for things that
> must be evaluated at compile time (static data initializations,
> switch statement case values etc.).

It's not just "must be evaluated at compile time"; it's "must be C constant
expressions", which is much stricter.  And no, in the case quoted above
__constant_ form is not needed.  Just use htonl()...
