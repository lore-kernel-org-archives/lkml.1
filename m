Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608AbZH0Ob4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbZH0Ob4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 10:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbZH0Ob4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 10:31:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbZH0Obz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 10:31:55 -0400
Date: Thu, 27 Aug 2009 17:30:27 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Avi Kivity <avi@redhat.com>,
       gleb@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
Message-ID: <20090827143027.GA22720@redhat.com>
References: <alpine.DEB.2.00.0908261201570.7780@makko.or.mcafeemobile.com> <1251363930-3916-1-git-send-email-pbonzini@redhat.com> <alpine.DEB.2.00.0908270720250.3809@makko.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908270720250.3809@makko.or.mcafeemobile.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 07:21:49AM -0700, Davide Libenzi wrote:
> On Thu, 27 Aug 2009, Paolo Bonzini wrote:
> 
> > > Ok, so why not using the eventfd counter as state?
> > > On the device side:
> > > 
> > > void write_state(int sfd, int state) {
> > > 	u64 cnt;
> > > 
> > > 	/* Clear the current state, sfd is in non-blocking mode */
> > > 	read(sfd,&cnt, sizeof(cnt));
> > > 	/* Writes new state */
> > > 	cnt = 1 + !!state;
> > > 	write(sfd,&cnt, sizeof(cnt));
> > > }
> > 
> > It's interesting [no sarcasm intended, mind] that EFD_SEMAPHORE was
> > added exactly to avoid a read+write combination for the case of
> > decrementing a value.
> 
> Like I repeated 25 times already, EFD_SEMAPHORE was added, because a 
> *semaphore* is a pretty widely known and used abstraction.

what about an atomic variable, btw?  does it make sense to implement
write that does compare and exchange?

> 
> - Davide
> 
