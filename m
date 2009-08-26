Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbZHZUEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbZHZUEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZHZUEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:04:09 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:57748 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbZHZUEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:04:09 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 26 Aug 2009 13:04:09 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gleb Natapov <gleb@redhat.com>
cc: Avi Kivity <avi@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
In-Reply-To: <20090826195002.GE11762@redhat.com>
Message-ID: <alpine.DEB.2.00.0908261303120.7780@makko.or.mcafeemobile.com>
References: <alpine.DEB.2.00.0908241114501.7951@makko.or.mcafeemobile.com> <20090824214900.GA9899@redhat.com> <alpine.DEB.2.00.0908241508440.7951@makko.or.mcafeemobile.com> <20090825072229.GA10608@redhat.com> <alpine.DEB.2.00.0908251456230.18518@makko.or.mcafeemobile.com>
 <20090826102908.GA21523@redhat.com> <alpine.DEB.2.00.0908261040100.7780@makko.or.mcafeemobile.com> <4A9585EC.2030505@redhat.com> <alpine.DEB.2.00.0908261201570.7780@makko.or.mcafeemobile.com> <4A95900D.9090201@redhat.com>
 <20090826195002.GE11762@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009, Gleb Natapov wrote:

> On Wed, Aug 26, 2009 at 10:42:05PM +0300, Avi Kivity wrote:
> > On 08/26/2009 10:13 PM, Davide Libenzi wrote:
> > >Ok, so why not using the eventfd counter as state?
> > >On the device side:
> > >
> > >void write_state(int sfd, int state) {
> > >	u64 cnt;
> > >
> > >	/* Clear the current state, sfd is in non-blocking mode */
> > >	read(sfd,&cnt, sizeof(cnt));
> > >	/* Writes new state */
> > >	cnt = 1 + !!state;
> > >	write(sfd,&cnt, sizeof(cnt));
> > >}
> > >
> > >
> > >On the hypervisor side:
> > >
> > >int read_state(int sfd) {
> > >	u64 cnt;
> > >
> > >	read(sfd,&cnt, sizeof(cnt));
> > >	return state - 1;
> > >}
> > >
> > 
> > Hadn't though of read+write as set.  While the 1+ is a little ugly,
> > it's workable.
> > 
> It's two system calls instead of one to inject interrupt.

I guess that's going to completely throw off-chart your RT performance, 
doesn't it?


- Davide


