Return-Path: <linux-kernel-owner+w=401wt.eu-S1753417AbYIHFxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbYIHFxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 01:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbYIHFxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 01:53:13 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:24847 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752497AbYIHFxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 01:53:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NhaSceNqDnvxoipvyqAdEuGpRUDVK0qDDdFFPmTh9KcaRGLhhHo6KvECbAuw8V4UI5NxIW4eu0krr6NU6+42jBimpeX5lLm+0Z/iB3wcaCrsN/d7augYZP+A0J2Ik+Jwa8sS0PBYIDKNwrO3qgw7/1lkFyXwYqvKRPNTYLdXoO4=  ;
X-YMail-OSG: tB0Xg6cVM1mIeYsyLX8WNqXqDw5ucxV3Hq8q7da6ghETTp08zRjgw4S_9Jl5gAyfk.phl5kJa349hSTSas4Y1DqewR2RKySiM3xxIWjDYMKTfsCSiOqfNf3xdGCDDFcrZxs-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [RESEND] x86_64: add memory hotremove config option
Date: Mon, 8 Sep 2008 15:52:49 +1000
User-Agent: KMail/1.9.5
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, Gary Hade <garyhade@us.ibm.com>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Ingo Molnar <mingo@elte.hu>
References: <20080905215452.GF11692@us.ibm.com> <20080906153855.7260.E1E9C6FF@jp.fujitsu.com> <20080906085320.GE18288@one.firstfloor.org>
In-Reply-To: <20080906085320.GE18288@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809081552.50126.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 September 2008 18:53, Andi Kleen wrote:
> On Sat, Sep 06, 2008 at 04:06:38PM +0900, Yasunori Goto wrote:
> > > not.
> > >
> > > This means I don't see a real use case for this feature.
> >
> > I don't think its driver is almighty.
> > IIRC, balloon driver can be cause of fragmentation for 24-7 system.
>
> Sure the balloon driver can be likely improved too, it's just
> that I don't think a balloon driver should call into the function
> the original patch in the series hooked up.
>
> > In addition, I have heard that memory hotplug would be useful for
> > reducing of power consumption of DIMM.
>
> It's unclear that memory hotplug is the right model for DIMM power
> management. The problem is that DIMMs are interleaved, so you again have to
> completely free a quite large area. It's not much easier than node hotplug.
>
> > I have to admit that memory hotplug has many issues, but I would like to
>
> Let's call it "node" or "hardware" memory hot unplug, not that
> anyone confuses it with the easier VM based hot unplug or the really
> easy hotadd.
>
> > solve them step by step.
>
> The question is if they are even solvable in a useful way.
> I'm not sure it's that useful to start and then find out
> that it doesn't work anyways.

You use non-linear mappings for the kernel, so that kernel data is
not tied to a specific physical address. AFAIK, that is the only way
to really do it completely (like the fragmentation problem).

Of course, I don't think that would be a good idea to do that in the
forseeable future.
