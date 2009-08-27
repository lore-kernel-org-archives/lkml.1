Return-Path: <linux-kernel-owner+w=401wt.eu-S1752120AbZH0OVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbZH0OVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 10:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbZH0OVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 10:21:49 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:36348 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbZH0OVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 10:21:48 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 27 Aug 2009 07:21:49 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Paolo Bonzini <pbonzini@redhat.com>
cc: Avi Kivity <avi@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
       gleb@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
In-Reply-To: <1251363930-3916-1-git-send-email-pbonzini@redhat.com>
Message-ID: <alpine.DEB.2.00.0908270720250.3809@makko.or.mcafeemobile.com>
References: <alpine.DEB.2.00.0908261201570.7780@makko.or.mcafeemobile.com> <1251363930-3916-1-git-send-email-pbonzini@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009, Paolo Bonzini wrote:

> > Ok, so why not using the eventfd counter as state?
> > On the device side:
> > 
> > void write_state(int sfd, int state) {
> > 	u64 cnt;
> > 
> > 	/* Clear the current state, sfd is in non-blocking mode */
> > 	read(sfd,&cnt, sizeof(cnt));
> > 	/* Writes new state */
> > 	cnt = 1 + !!state;
> > 	write(sfd,&cnt, sizeof(cnt));
> > }
> 
> It's interesting [no sarcasm intended, mind] that EFD_SEMAPHORE was
> added exactly to avoid a read+write combination for the case of
> decrementing a value.

Like I repeated 25 times already, EFD_SEMAPHORE was added, because a 
*semaphore* is a pretty widely known and used abstraction.


- Davide


