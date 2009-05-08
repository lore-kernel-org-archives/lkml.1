Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbZEHQQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbZEHQQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 12:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbZEHQPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 12:15:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:56675 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbZEHQPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 12:15:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=S1Wp5JLeSP0EAQChJnwyaQy9kjWirjMpXO6sE8WKYWT2FmWpPCrtlHdCT4hZEezV91
         +rnrHL1nRjsppUK3XO7RvR9nQOBIfm5zyHE+TAwUSho1iOOGfm+YlaSIm90j5FvES2jf
         QYP6AcfRqruYhYynSsaeEeYWkk6rTyQvOlh8I=
Date: Fri, 8 May 2009 20:15:53 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, rientjes@google.com
Subject: Re: [PATCH 2/2] SLUB: Use GFP_PANIC for early-boot allocations
Message-ID: <20090508161553.GL6132@lenovo>
References: <1241795429.28600.61.camel@penberg-laptop> <alpine.DEB.1.10.0905081127240.26361@qirst.com> <1241797017.28600.63.camel@penberg-laptop> <1241797364.6311.2914.camel@laptop> <1241797558.28600.68.camel@penberg-laptop> <1241797858.6311.2925.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241797858.6311.2925.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Peter Zijlstra - Fri, May 08, 2009 at 05:50:58PM +0200]
| On Fri, 2009-05-08 at 18:45 +0300, Pekka Enberg wrote:
| 
| > On Fri, 2009-05-08 at 17:42 +0200, Peter Zijlstra wrote:
| > > BUG_ON((gfp & __GFP_PANIC) && (system_state != STATE_BOOTING));
| > 
| > There's no technical reason not to use GFP_PANIC when system_state !=
| > STATE_BOOTING so I don't think it's needed. It's just that GFP_PANIC
| > (and BUG_ON) is IMHO too harsh for create_unique_id().
| 
| Shouldn't we handle every allocation failure after booting?

Definitely

| 
| I think it _is_ a bug to panic on allocation failures once we're
| running.
|

But Peter I believe there was no suggestion to use GFP_PANIC everywhere
to get rid of error handling. But rather to use it in case if kmalloc is
followed by BUG_ON.

| 
| I'm really not very fond of __GFP_PANIC as it stands, it seems to
| suggest its OK to ignore allocation failures, which would bring us back
| to the original UNIX error handling :/
| 
	-- Cyrill
