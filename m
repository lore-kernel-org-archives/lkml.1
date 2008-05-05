Return-Path: <linux-kernel-owner+w=401wt.eu-S1756296AbYEEHYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbYEEHYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 03:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYEEHYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 03:24:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:62874 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbYEEHYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 03:24:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=B8ufcxlIik0aUqfml1TINxtZvunz0hP2VJ2qr4RRtSAobzUeJueGEXhloj0yO3eTvJ97Yb0nu9o0it9FPhgGngPTJ7RtV06707DXJO5CPll6VcmmE4wt4zrbdcluriquYi0VwwedhyYQNY0nwtW9eV18wqPqxceTs5onKCdxW0c=
Date: Mon, 5 May 2008 07:27:34 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Jay Cliburn <jacliburn@bellsouth.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Chris Snook <csnook@redhat.com>
Subject: Re: Need help debugging memory corruption
Message-ID: <20080505072734.GA4069@ff.dom.local>
References: <20080503130951.091392ba@osprey.hogchain.net> <481DC731.5090303@gmail.com> <481DCE4C.9070805@gmail.com> <20080504145529.2eac672e@osprey.hogchain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080504145529.2eac672e@osprey.hogchain.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 02:55:29PM -0500, Jay Cliburn wrote:
> On Sun, 04 May 2008 16:55:08 +0200
> Jarek Poplawski <jarkao2@gmail.com> wrote:
> 
> > Jarek Poplawski wrote, On 05/04/2008 04:24 PM:
> > ...
> > 
> > > I'm definitely with less experience, so I wonder why it can't be
> > > a simple race between atl1_clean_rx_ring() and something (maybe even
> > > pending atl1_intr_rx()) on the other cpu writing skb while kfreeing?
> > 
> > 
> > Hmm... atl1_intr_rx() looks impossible, so atl1_alloc_rx_buffers()?
> 
> I booted with nosmp and the bug is *much* harder to hit, but I still
> hit it once out of about 10 tries.  Does the fact that I hit it once
> using nosmp disprove the race theory?

Probably not: I don't know how about preemption model, but especially
some maybe unkilled timers/watchdogs or workqueues could be considered.
Of course this idea looks very unprobable (should happen with less
than 4GB too), but should be quite easy to verify by adding some
temporary spinlocks around these rx ring operations?

Jarek P.
