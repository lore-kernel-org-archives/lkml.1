Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbZETOMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbZETOMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 10:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbZETOM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 10:12:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:59263 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZETOM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 10:12:26 -0400
Subject: Re: INFO: possible circular locking dependency at
 cleanup_workqueue_thread
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090520135537.GA18480@redhat.com>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com>
	 <20090517071834.GA8507@elte.hu> <1242821938.26820.586.camel@twins>
	 <20090520131823.GA14933@redhat.com> <1242827092.26820.612.camel@twins>
	 <20090520135537.GA18480@redhat.com>
Content-Type: text/plain
Date: Wed, 20 May 2009 16:12:15 +0200
Message-Id: <1242828735.32543.1629.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-20 at 15:55 +0200, Oleg Nesterov wrote:
> On 05/20, Peter Zijlstra wrote:
> >
> > On Wed, 2009-05-20 at 15:18 +0200, Oleg Nesterov wrote:
> > > On 05/20, Peter Zijlstra wrote:
> > > >
> > > > Breaking the setup_lock -> cpu_add_remove_lock dependency seems
> > > > sufficient.
> > >
> > > Hmm. What do you mean? Afaics setup_lock -> cpu_add_remove_lock
> > > is not a problem?
> >
> > >From what I could see that is the only dependency that makes
> > cpu_add_remove_lock nest under "events" workqueue 'lock', which is what
> > is generating the deadlock.
> 
> But cpu_add_remove_lock does not participate in this deadlock, see
> http://marc.info/?l=linux-kernel&m=124274977707363 ?
> 
> Perhaps you mean something else, could you spell in that case?

Ah, right, I knew I should have payed more attention when reading the
thread. Yes breaking that chain around dpm_list_mutex would also work,
and solve this other deadlock too.



