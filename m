Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbZHHLUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbZHHLUn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 07:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbZHHLUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 07:20:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35333 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbZHHLUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 07:20:42 -0400
Date: Sat, 8 Aug 2009 07:20:31 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hch@infradead.org, rlove@google.com,
       msb@google.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 2/4] vfs: explicitly cast s_maxbytes in
 fiemap_check_ranges
Message-ID: <20090808072031.2c01a2aa@tlielax.poochiereds.net>
In-Reply-To: <20090807221252.GA28019@cmpxchg.org>
References: <1249671461-9071-1-git-send-email-jlayton@redhat.com>
	<1249671461-9071-3-git-send-email-jlayton@redhat.com>
	<20090807221252.GA28019@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Aug 2009 00:12:52 +0200
Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Fri, Aug 07, 2009 at 02:57:39PM -0400, Jeff Layton wrote:
> > If fiemap_check_ranges is passed a large enough value, then it's
> > possible that the value would be cast to a signed value for comparison
> > against s_maxbytes when we change it to loff_t. Make sure that doesn't
> > happen by explicitly casting s_maxbytes to an unsigned value for the
> > purposes of comparison.
> 
> I think this is unneeded, C garuantees that in this case the signed
> value will get promoted to an unsigned value, not the other way round.
> 

After looking at this again, I think you're correct. do_sendfile was
actually casting s_maxbytes to a signed value which is why it was
broken there.

I can drop this patch if the consensus is to do so. I still think
however that it doesn't hurt to do explict casts when comparing signed
and unsigned values to remove any potential for ambiguity.

-- 
Jeff Layton <jlayton@redhat.com>
