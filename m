Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbZJ0Jsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbZJ0Jsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 05:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbZJ0Jsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 05:48:42 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43617 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751639AbZJ0Jsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 05:48:41 -0400
To: David Miller <davem@davemloft.net>
Cc: rostedt@goodmis.org, sam@ravnborg.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, nico@fluxnic.net, tony.luck@intel.com,
       sfr@canb.auug.org.au, mcgrof@gmail.com, jeff@garzik.org,
       robert.richter@amd.com, dmitry.torokhov@gmail.com, khali@linux-fr.org,
       torvalds@linux-foundation.org
Subject: Re: [RFC] to rebase or not to rebase on linux-next
References: <1256599588.26028.340.camel@gandalf.stny.rr.com>
	<20091026.163050.156983266.davem@davemloft.net>
	<1256601061.26028.350.camel@gandalf.stny.rr.com>
	<20091026.171539.06989895.davem@davemloft.net>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Tue, 27 Oct 2009 09:48:36 +0000
In-Reply-To: <20091026.171539.06989895.davem@davemloft.net> (David Miller's message of "Mon\, 26 Oct 2009 17\:15\:39 -0700 \(PDT\)")
Message-ID: <tnx4opl5frf.fsf@pc1117.cambridge.arm.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Oct 2009 09:48:43.0746 (UTC) FILETIME=[ABC26420:01CA56EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Mon, 26 Oct 2009 19:51:01 -0400
>> I get something working and then commit it. Then I do more changes
>> and commit that. I don't use quilt anymore for this.
>
> And you can do this all day long if you like.
>
> What you can't do is _PUBLISH_ this anywhere to a tree that people
> also do development against _UNTIL_ you get those acks and tested-by
> tags back from people.
>
> Once your acks etc. come in, you can pop all of those pending patches
> out of your tree, add the ack tags to the commit messages, then
> reapply them.
>
> Then you can push to your public tree, but no sooner.

I use stacked git for my patches and I may rewind the series (fixes
following reviews/testing, acked-by lines etc.) before patches are
pushed into mainline (nothing new here). But to make it easier for
others to test or develop on top of such branch, I added a "stg
publish" command which creates a separate merge-friendly branch that
is never rebased nor rewound (for some implementation details, see
http://procode.org/stgit/doc/stg-publish.html). The top commit sha1
(and history) of the published and series branches differ but they
always have the same tree so that people using the published branch
always get the same source. You even get to add a comment about what
was modified in the series when publishing the change.

There is currently no way to publish commit message changes like
adding Acked-by (unless the "publish" command would do a revert of the
original commit, though not sure it's worth as it makes the history
more unreadable).

For mainline merging you can send a pull request on the series
(rewound) branch once you are happy with it and don't foresee further
changes (when rebasing a series on the latest mainline, the "publish"
command generates a "merge" with mainline so that people pulling both
the published branch and mainline don't need to resolve the possible
conflicts with your series).

A similar script could be easily done for plain git (Stefan Richter
mentioned something like this as well).

-- 
Catalin
