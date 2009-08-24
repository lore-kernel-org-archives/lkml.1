Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbZHXSZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbZHXSZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 14:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbZHXSZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 14:25:03 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:53352 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbZHXSZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 14:25:02 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 24 Aug 2009 11:25:01 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: Avi Kivity <avi@redhat.com>, gleb@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
In-Reply-To: <20090823143021.GA27495@redhat.com>
Message-ID: <alpine.DEB.2.00.0908241114501.7951@makko.or.mcafeemobile.com>
References: <20090820155655.GA8764@redhat.com> <alpine.DEB.2.00.0908200916300.14844@makko.or.mcafeemobile.com> <4A8D8A28.2050004@redhat.com> <20090820175540.GA9232@redhat.com> <4A8D90BB.2030506@redhat.com> <20090820182847.GB9282@redhat.com> <4A913DA9.1020403@redhat.com>
 <20090823133620.GA12841@redhat.com> <4A9146E3.2090007@redhat.com> <20090823143021.GA27495@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Aug 2009, Michael S. Tsirkin wrote:

> On Sun, Aug 23, 2009 at 04:40:51PM +0300, Avi Kivity wrote:
> > On 08/23/2009 04:36 PM, Michael S. Tsirkin wrote:
> >> More important here is realization that eventfd is a mutex/semaphore
> >> implementation, not a generic event reporting interface as we are trying
> >> to use it.
> >>    
> >
> > Well it is a generic event reporting interface (for example, aio uses it).
> 
> Davide, I think it's a valid point.  For example, what read on eventfd
> does (zero a counter and return) is not like any semaphore I saw.


Indeed, the default eventfd behaviour is like, well, an event. Signaling 
(kernel side) or writing (userspace side), signals the event.
Waiting (reading) it, will reset the event.
If you use EFD_SEMAPHORE, you get a semaphore-like behavior.
Events and sempahores are two widely known and used abstractions.
The EFD_STATE proposed one, well, no. Not at all.



- Davide


