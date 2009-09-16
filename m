Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbZIPPDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbZIPPDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbZIPPDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:03:10 -0400
Received: from james.oetiker.ch ([213.144.138.195]:50801 "EHLO
	james.oetiker.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759183AbZIPPDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:03:09 -0400
Date: Wed, 16 Sep 2009 17:03:11 +0200 (CEST)
From: Tobias Oetiker <tobi@oetiker.ch>
To: Vivek Goyal <vgoyal@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: io-controller: file system meta data operations
In-Reply-To: <20090916144946.GB5221@redhat.com>
Message-ID: <alpine.DEB.2.00.0909161650360.14727@sebohet.brgvxre.pu>
References: <alpine.DEB.2.00.0909161445440.11232@sebohet.brgvxre.pu> <20090916144946.GB5221@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

Today Vivek Goyal wrote:

> On Wed, Sep 16, 2009 at 02:58:52PM +0200, Tobias Oetiker wrote:
> > Hi Vivek,
> >
> > I am trying to optimize user-experience on a busy NFS server.
> >
> > I think much could be achieved if the following was true.
> >
> >   get a response to file system meta data operations (opendir,
> >   readdir, stat, mkdir, unlink) within 200 ms even under heavy
> >   read/write strain ...
> >
>
> Hi tobi,
>
> Is it better with vanilla CFQ (without io controller). I see that CFQ
> preempts the ongoing process if it receives a meta data request and that
> way it provides faster response.
>
> If yes, then similar thing should work for IO controller also. Wait there
> is one issue though. If a file system request gets backlogged in a group
> while a different group was being served, then preemption will not happen
> and that's probably the reason you are not seeing better latencies.

I only looked at io-controller once I did not get ahead with
vanilla cfq ( and the other schedulers for that matter).

I am working on a system with and Areca HW Raid6 with battery buffered cache.
I assume that if linux manages to fill the cache of the hwraid with
write requests it will eventually flush them and maybe not react
well to competing read requests at that level as well (just
guessing) I have disabled the cache, to see if this has a positive effect, but
the only gain was, that the everything became slower. Metadata
operations still were painfuly slow.

> I think there are two ways to handle this in IO controller.

> - Put the meta data requesting processes at the front of the service tree
>   in respective group. This will make sure that even if there are other
>   sequential readers or heavy writers in the group, this request gets
>   served quickly.

in my test setup this may be possible, but IRL I am dealing with an
NFS server, so I can not deal with individual processes (they are
on the clients and not known on the nfs sever I guess).

I am a bit at a loss as to how I should best configure
io-controller for such a situation since it seems to relie on
process ids for all its work ...

maybe fairness between different clients and userids might be
interesting here ... can cgroups deal with this?

> I will write a small patch for this. I think that should help you.

cool ..

cheers
tobi

> Thanks
> Vivek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

-- 
Tobi Oetiker, OETIKER+PARTNER AG, Aarweg 15 CH-4600 Olten, Switzerland
http://it.oetiker.ch tobi@oetiker.ch ++41 62 775 9902 / sb: -9900
