Return-Path: <linux-kernel-owner+w=401wt.eu-S1751046AbZH0FZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751046AbZH0FZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 01:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbZH0FZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 01:25:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbZH0FZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 01:25:39 -0400
Date: Thu, 27 Aug 2009 08:25:38 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Avi Kivity <avi@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
Message-ID: <20090827052538.GH30093@redhat.com>
References: <alpine.DEB.2.00.0908241508440.7951@makko.or.mcafeemobile.com>
 <20090825072229.GA10608@redhat.com>
 <alpine.DEB.2.00.0908251456230.18518@makko.or.mcafeemobile.com>
 <20090826102908.GA21523@redhat.com>
 <alpine.DEB.2.00.0908261040100.7780@makko.or.mcafeemobile.com>
 <4A9585EC.2030505@redhat.com>
 <alpine.DEB.2.00.0908261201570.7780@makko.or.mcafeemobile.com>
 <4A95900D.9090201@redhat.com>
 <20090826195002.GE11762@redhat.com>
 <alpine.DEB.2.00.0908261303120.7780@makko.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908261303120.7780@makko.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 01:04:09PM -0700, Davide Libenzi wrote:
> On Wed, 26 Aug 2009, Gleb Natapov wrote:
> 
> > On Wed, Aug 26, 2009 at 10:42:05PM +0300, Avi Kivity wrote:
> > > On 08/26/2009 10:13 PM, Davide Libenzi wrote:
> > > >Ok, so why not using the eventfd counter as state?
> > > >On the device side:
> > > >
> > > >void write_state(int sfd, int state) {
> > > >	u64 cnt;
> > > >
> > > >	/* Clear the current state, sfd is in non-blocking mode */
> > > >	read(sfd,&cnt, sizeof(cnt));
> > > >	/* Writes new state */
> > > >	cnt = 1 + !!state;
> > > >	write(sfd,&cnt, sizeof(cnt));
> > > >}
> > > >
> > > >
> > > >On the hypervisor side:
> > > >
> > > >int read_state(int sfd) {
> > > >	u64 cnt;
> > > >
> > > >	read(sfd,&cnt, sizeof(cnt));
> > > >	return state - 1;
> > > >}
> > > >
> > > 
> > > Hadn't though of read+write as set.  While the 1+ is a little ugly,
> > > it's workable.
> > > 
> > It's two system calls instead of one to inject interrupt.
> 
> I guess that's going to completely throw off-chart your RT performance, 
> doesn't it?
> 
Do you consider interrupt injection path not worth of optimizing?

--
			Gleb.
