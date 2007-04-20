Return-Path: <linux-kernel-owner+w=401wt.eu-S1423014AbXDTHJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423014AbXDTHJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 03:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbXDTHJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 03:09:08 -0400
Received: from mx10.go2.pl ([193.17.41.74]:35583 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753981AbXDTHJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 03:09:07 -0400
Date: Fri, 20 Apr 2007 09:14:45 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070420071445.GA1695@ff.dom.local>
References: <20070419065404.GB1782@ff.dom.local> <4627A1BF.8080406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4627A1BF.8080406@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 01:07:11PM -0400, Chuck Ebbert wrote:
> Jarek Poplawski wrote:
> > Hi,
> > 
> > IMHO cancel_rearming_delayed_work is dangerous place:
> > 
> > - it assumes a work function always rearms (with no exception),
> > which probably isn't explained enough now (but anyway should
> > be checked in such loops);
> > 
> > - probably possible (theoretical) scenario: a few work
> > functions rearm themselves with very short, equal times;
> > before flush_workqueue ends, their timers are already
> > fired, so cancel_delayed_work has nothing to do.
> > 
> > Maybe this patch could check, if I'm not dreaming...
> > 
> > PS: of course the counter value below is a question of taste
> 
> Okay, an easy test for it: insmod netconsole ; rmmod netconsole
> 
> In 2.6.20.x it loops forever and cancel_rearming_delayed_work()
> is part of the trace...
 
Sure, but the dreaming test is more needed for the second
point - I mean - if it's theoretical only? The first scenario
is in my opinion assured logically - there was only a question,
whether it could be detected by other means - and it seems not.

Cheers,
Jarek P.
