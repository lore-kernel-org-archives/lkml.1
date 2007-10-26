Return-Path: <linux-kernel-owner+w=401wt.eu-S1762182AbXJZBZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762182AbXJZBZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 21:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbXJZBZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 21:25:06 -0400
Received: from smtp-out.google.com ([216.239.33.17]:15458 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbXJZBZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 21:25:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=a4vFqaTiK8gvwuxmb8EWYm5nCUK0ehoT1lOYFDmBYppOQ65qVnzW7ZEStff00s7ls
	yOoSv40/iaS2ppE2pgsgg==
Message-ID: <6599ad830710251824w1e4a2720p90785e148b32f9c2@mail.gmail.com>
Date: Thu, 25 Oct 2007 18:24:55 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@linux.vnet.ibm.com
Subject: Re: [PATCH 2/2] CFS CGroup: Report usage
Cc: containers@lists.linux-foundation.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20071024043916.GA5357@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <471D4523.4040509@google.com>
	 <20071023164704.GE4667@linux.vnet.ibm.com>
	 <6599ad830710230941y5d175688ob3a4d9ac42ba8c8f@mail.gmail.com>
	 <20071023173837.GG4667@linux.vnet.ibm.com>
	 <6599ad830710231928n65a80021w582a07b5993377f8@mail.gmail.com>
	 <20071024043916.GA5357@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/07, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
>
> agreed, we need to be reporting idle time in (milli)seconds, although
> the requirement we had was to report it back in percentage. I guess the
> percentage figure can be derived from the raw idle time number.
>
> How about:
>
>         idle time = t4-t3 (effectively sleep time)
>
> in the above example?
>
> > It doesn't seem quite right to me that a cgroup's idle time metric be
> > affected by the activity of other cgroups on the machine,
>
> I don't see how the idle time metric defined above (t4-t3) can be
> affected by other cgroup activity, unless the execution pattern of one
> cgroup is dependent on the others.

If the other cgroups are busier, and t1-t2 is longer, then the cgroup
will get to the point where it's ready to sleep later in wallclock
time, and t4-t3 will be shorter in absolute terms. If there were no
other cgroups running, then presumably the sleep time would actually
be the sum of those three periods.

Even so, I guess you're right that t4-t3 is the most appropriate thing
to report, as long as people realise that it's a bit of a fuzzy value.

> I think primarily for systems management tools to report back various
> statistics about a OpenVZ/VServer-like container (just like top reports stats
> for a OS currently). Let me check if there are other uses envisoned for
> it.

Sorry, I didn't mean "how will you report it to users?", I meant "what
kinds of useful information will the users be able to get from it?"

Paul
