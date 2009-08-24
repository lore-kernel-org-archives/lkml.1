Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbZHXVu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbZHXVu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 17:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbZHXVu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 17:50:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688AbZHXVuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 17:50:25 -0400
Date: Tue, 25 Aug 2009 00:49:00 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Avi Kivity <avi@redhat.com>, gleb@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
Message-ID: <20090824214900.GA9899@redhat.com>
References: <alpine.DEB.2.00.0908200916300.14844@makko.or.mcafeemobile.com> <4A8D8A28.2050004@redhat.com> <20090820175540.GA9232@redhat.com> <4A8D90BB.2030506@redhat.com> <20090820182847.GB9282@redhat.com> <4A913DA9.1020403@redhat.com> <20090823133620.GA12841@redhat.com> <4A9146E3.2090007@redhat.com> <20090823143021.GA27495@redhat.com> <alpine.DEB.2.00.0908241114501.7951@makko.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908241114501.7951@makko.or.mcafeemobile.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 11:25:01AM -0700, Davide Libenzi wrote:
> On Sun, 23 Aug 2009, Michael S. Tsirkin wrote:
> 
> > On Sun, Aug 23, 2009 at 04:40:51PM +0300, Avi Kivity wrote:
> > > On 08/23/2009 04:36 PM, Michael S. Tsirkin wrote:
> > >> More important here is realization that eventfd is a mutex/semaphore
> > >> implementation, not a generic event reporting interface as we are trying
> > >> to use it.
> > >>    
> > >
> > > Well it is a generic event reporting interface (for example, aio uses it).
> > 
> > Davide, I think it's a valid point.  For example, what read on eventfd
> > does (zero a counter and return) is not like any semaphore I saw.
> 
> 
> Indeed, the default eventfd behaviour is like, well, an event. Signaling 
> (kernel side) or writing (userspace side), signals the event.
> Waiting (reading) it, will reset the event.
> If you use EFD_SEMAPHORE, you get a semaphore-like behavior.
> Events and sempahores are two widely known and used abstractions.
> The EFD_STATE proposed one, well, no. Not at all.

Hmm. All we try to do is, associate a small key with the event
that we signal. Is it really that uncommon/KVM specific?

> 
> 
> - Davide
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
