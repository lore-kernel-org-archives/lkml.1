Return-Path: <linux-kernel-owner+w=401wt.eu-S1031328AbXHMNXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031328AbXHMNXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S971647AbXHMJTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 05:19:15 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:37182 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S971624AbXHMJTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 05:19:12 -0400
Date: Mon, 13 Aug 2007 13:18:56 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Daniel Phillips <phillips@phunq.net>
Cc: Jens Axboe <jens.axboe@oracle.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Distributed storage.
Message-ID: <20070813091856.GA5503@2ka.mipt.ru>
References: <20070731171347.GA14267@2ka.mipt.ru> <20070813072848.GC23758@kernel.dk> <20070813074530.GE23758@kernel.dk> <200708130208.57542.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708130208.57542.phillips@phunq.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 02:08:57AM -0700, Daniel Phillips (phillips@phunq.net) wrote:
> > But that idea fails as well, since reference counts and IO completion
> > are two completely seperate entities. So unless end IO just happens
> > to be the last user holding a reference to the bio, you cannot free
> > it.
> 
> That is not a problem.  When bio_put hits zero it calls ->endio instead 
> of the destructor.  The ->endio sees that the count is zero and 
> destroys the bio.

This is not a very good solution, since it requires all users of the
bios to know how to free it. Right now it is hidden.
And adds additional atomic check (although reading is quite fast) in the
end_io. And for what purpose? To eat 8 bytes on 64bit platform? This
will not reduce its size noticebly, so the same number of bios will be
in the cache's page, so what is a gain? All this cleanups and logic
complicatins should be performed only if after size shring increased
number of bios can fit into cache's page, will it be done after such
cleanups?

-- 
	Evgeniy Polyakov
