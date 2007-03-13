Return-Path: <linux-kernel-owner+w=401wt.eu-S1030457AbXCMPL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030457AbXCMPL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 11:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030624AbXCMPL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 11:11:57 -0400
Received: from MAIL.13thfloor.at ([213.145.232.33]:52256 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030457AbXCMPL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 11:11:56 -0400
Date: Tue, 13 Mar 2007 16:11:55 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: Kirill Korotaev <dev@sw.ru>
Cc: Pavel Emelianov <xemul@sw.ru>, Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.osdl.org, menage@google.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/7] RSS controller core
Message-ID: <20070313151154.GI8755@MAIL.13thfloor.at>
Mail-Followup-To: Kirill Korotaev <dev@sw.ru>,
	Pavel Emelianov <xemul@sw.ru>,
	Andrew Morton <akpm@linux-foundation.org>,
	containers@lists.osdl.org, menage@google.com,
	linux-kernel@vger.kernel.org
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru> <20070306140036.4e85bd2f.akpm@linux-foundation.org> <45F3F581.9030503@sw.ru> <20070311045111.62d3e9f9.akpm@linux-foundation.org> <20070312010039.GC21861@MAIL.13thfloor.at> <45F51709.1010409@sw.ru> <20070312211111.GB21258@MAIL.13thfloor.at> <45F6BEFF.5000109@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F6BEFF.5000109@sw.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 06:10:55PM +0300, Kirill Korotaev wrote:
> >>So what to do when virtual physical limit is hit?
> >>OOM-kill current task?
> > 
> > 
> > when the RSS limit is hit, but there _are_ enough
> > pages left on the physical system, there is no
> > good reason to swap out the page at all
> > 
> >  - there is no benefit in doing so (performance
> >    wise, that is)
> > 
> >  - it actually hurts performance, and could
> >    become a separate source for DoS
> > 
> > what should happen instead (in an ideal world :)
> > is that the page is considered swapped out for
> > the guest (add guest penality for swapout), and 
> > when the page would be swapped in again, the guest
> > takes a penalty (for the 'virtual' page in) and
> > the page is returned to the guest, possibly kicking
> > out (again virtually) a different page
> 
> great. I agree with that.

> Just curious why current vserver code kills arbitrary
> task in container then?

because it obviously lacks the finess of OpenVZ code :)

seriously, handling the OOM kills inside a container
has never been a real world issue, as once you are
really out of memory (and OOM starts killing) you 
usually have lost the game anyways (i.e. a guest restart
or similar is required to get your services up and
running again) and OOM killer decisions are not perfect
in mainline either, but, you've probably seen the 
FIXME and TODO entries in the code showing that this
is work in progress ...

> >>> - accounting and limits have to be consistent
> >>>   and should roughly represent the actual used
> >>>   memory/swap (modulo optimizations, I can go
> >>>   into detail here, if necessary)
> >>
> >>This is true for current implementation for
> >>booth - this patchset ang OpenVZ beancounters.
> >>
> >>If you sum up the physpages values for all containers
> >>you'll get the exact number of RAM pages used.
> > 
> > 
> > hmm, including or excluding the host pages?
> 
> depends on whether you will include beanocunter 0 usages or not :)

so that is an option then?

best,
Herbert

> Kirill
