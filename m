Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbZHYHX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbZHYHX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 03:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbZHYHXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 03:23:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbZHYHXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 03:23:55 -0400
Date: Tue, 25 Aug 2009 10:22:29 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Avi Kivity <avi@redhat.com>, gleb@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
Message-ID: <20090825072229.GA10608@redhat.com>
References: <20090820175540.GA9232@redhat.com> <4A8D90BB.2030506@redhat.com> <20090820182847.GB9282@redhat.com> <4A913DA9.1020403@redhat.com> <20090823133620.GA12841@redhat.com> <4A9146E3.2090007@redhat.com> <20090823143021.GA27495@redhat.com> <alpine.DEB.2.00.0908241114501.7951@makko.or.mcafeemobile.com> <20090824214900.GA9899@redhat.com> <alpine.DEB.2.00.0908241508440.7951@makko.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908241508440.7951@makko.or.mcafeemobile.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 03:15:05PM -0700, Davide Libenzi wrote:
> On Tue, 25 Aug 2009, Michael S. Tsirkin wrote:
> 
> > On Mon, Aug 24, 2009 at 11:25:01AM -0700, Davide Libenzi wrote:
> > > On Sun, 23 Aug 2009, Michael S. Tsirkin wrote:
> > > 
> > > > On Sun, Aug 23, 2009 at 04:40:51PM +0300, Avi Kivity wrote:
> > > > > On 08/23/2009 04:36 PM, Michael S. Tsirkin wrote:
> > > > >> More important here is realization that eventfd is a mutex/semaphore
> > > > >> implementation, not a generic event reporting interface as we are trying
> > > > >> to use it.
> > > > >>    
> > > > >
> > > > > Well it is a generic event reporting interface (for example, aio uses it).
> > > > 
> > > > Davide, I think it's a valid point.  For example, what read on eventfd
> > > > does (zero a counter and return) is not like any semaphore I saw.
> > > 
> > > 
> > > Indeed, the default eventfd behaviour is like, well, an event. Signaling 
> > > (kernel side) or writing (userspace side), signals the event.
> > > Waiting (reading) it, will reset the event.
> > > If you use EFD_SEMAPHORE, you get a semaphore-like behavior.
> > > Events and sempahores are two widely known and used abstractions.
> > > The EFD_STATE proposed one, well, no. Not at all.
> > 
> > Hmm. All we try to do is, associate a small key with the event
> > that we signal. Is it really that uncommon/KVM specific?
> 
> All I'm trying to do, is to avoid that eventfd will become an horrible 
> multiplexor for every freaky one-time-use behaviors arising inside kernel 
> modules.

Yes, we don't want that. The best thing is to try to restate the problem
in a way that is generic, and then either solve or best use existing
solution. Right?

I thought I had that, but apparently not.  The reason I'm Cc-ing you is
not to try and spam you until you give up and accept the patch, it's
hoping that you see the pattern behind our usage, and help generalize
it.

If I understand it correctly, you believe this is not possible and so
any solution will have to be in KVM? Or maybe I didn't state the problem
clearly enough and should restate it?


> 
> 
> - Davide

-- 
MST
