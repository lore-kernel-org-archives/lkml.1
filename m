Return-Path: <linux-kernel-owner+w=401wt.eu-S934824AbXKPV7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934824AbXKPV7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:59:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758417AbXKPV6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:58:53 -0500
Received: from namei.org ([69.55.235.186]:53198 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757578AbXKPV6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:58:52 -0500
Date: Sat, 17 Nov 2007 08:58:01 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, selinux@tycho.nsa.gov,
       alan@redhat.com, chrisw@redhat.com, hpa@zytor.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 3/3] security: allow capable check to permit mmap or low
 vm space
In-Reply-To: <1195250009.2924.103.camel@localhost.localdomain>
Message-ID: <Xine.LNX.4.64.0711170856200.22208@us.intercode.com.au>
References: <1195246545.2924.88.camel@localhost.localdomain> 
 <Xine.LNX.4.64.0711170845050.22208@us.intercode.com.au>
 <1195250009.2924.103.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007, Eric Paris wrote:

> On Sat, 2007-11-17 at 08:47 +1100, James Morris wrote:
> > On Fri, 16 Nov 2007, Eric Paris wrote:
> > 
> > > On a kernel with CONFIG_SECURITY but without an LSM which implements
> > > security_file_mmap it is impossible for an application to mmap addresses
> > > lower than mmap_min_addr.
> > 
> > Actually, should we be doing any checking in the dummy module, given that 
> > it is not done with !CONFIG_SECURITY ?
> 
> I'm not sure I understand the question.  We already do a number of
> capable type security checks in dummy functions. See dummy_settime() as
> just one example.

I mean just in this case.  If no mmap_min_addr check is done without 
CONFIG_SECURITY, then perhaps none should be done in the dummy module, 
i.e. preserving existing behavior.  LSM is theoretically supposed to be 
unnoticable from a behavioral pov unless a non-dummy module is loaded.

> 
> If we have !CONFIG_SECURITY we don't have any security protections (how
> could we?  we turned them off) so we don't get into dummy hooks.  If we
> do checks or not in uncompiled code doesn't seem to me to matter.
> 
> Maybe I'm just confused...
> 
> -Eric
> 

-- 
James Morris
<jmorris@namei.org>
