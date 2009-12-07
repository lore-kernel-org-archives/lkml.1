Return-Path: <linux-kernel-owner+w=401wt.eu-S964810AbZLGUQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbZLGUQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933589AbZLGUQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:16:53 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34354 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932856AbZLGUQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:16:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l4Qt0LGQwLHPquQx0OEMATQNJXU5MMEdxSUY3qBR7KryC+Lw2RpRegz2ht9VomzVL4
         EwNdWUzyGRMJET3K7JspeLnrFf/41oMSMxzzlp7fv9NQ5J3wRDnXtzHekWsZmHtmi7kS
         mqcN/9eI1Pds5QoTJzijwsfMzNYna28FDiVKw=
Date: Mon, 7 Dec 2009 21:16:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       paulus@samba.org, tzanussi@gmail.com, srostedt@redhat.com
Subject: Re: [PATCH 2/2] perf lock: New subcommand "lock" to perf for
	analyzing lock statistics
Message-ID: <20091207201652.GD5049@nowhere>
References: <20091115022135.GA5427@nowhere> <1260156884-8474-2-git-send-email-mitake@dcl.info.waseda.ac.jp> <20091207044125.GB5262@nowhere> <20091207.235123.186008685.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207.235123.186008685.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 11:51:23PM +0900, Hitoshi Mitake wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> > Indeed. I think every lock instance has its own lockdep_map.
> > And this lockdep_map is passed in every lock event but is
> > only used to retrieve the name of the lock.
> > 
> > Why not adding the address of the lockdep_map in the event?
> 
> It's good idea. Address cannot be used as index of array directly,
> but dealing with it is far easier than string and low cost.


Yeah, dealing with lock strings as identifier is like dealing
with the lock class instead of the lock instance. It would
require a very tricky state machine to sort it out.

The address of the lockdep map would be useful as an identifier.
Probably a hashlist based on it would be a good way: we can use
the hashlist from the kernel headers (list.h) in perf tools
already.


 
> > I think that the lock events are much more sensible than the sched events,
> > and that by nature: these are very high frequency events class, probably the
> > highest among every event classes we have (the worst beeing function tracing :)
> > 
> > But still, you're right, there are certainly various things we need to
> > optimize in this area.
> > 
> > More than 8 times slower is high.
> 
> It seems that lockdep contains some O(n) codes.
> Of course lockdep is important, but analyzing statistics of lock usage
> is another problem.
> I think separating lockdep and lock event for stats can be solution.


Indeed.

Thanks!

