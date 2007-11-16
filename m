Return-Path: <linux-kernel-owner+w=401wt.eu-S932777AbXKPWHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777AbXKPWHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 17:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbXKPWH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 17:07:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757264AbXKPWH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 17:07:28 -0500
Subject: Re: [PATCH 3/3] security: allow capable check to permit mmap or
	low vm space
From: Eric Paris <eparis@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, selinux@tycho.nsa.gov,
       alan@redhat.com, chrisw@redhat.com, hpa@zytor.com,
       akpm@linux-foundation.org
In-Reply-To: <Xine.LNX.4.64.0711170856200.22208@us.intercode.com.au>
References: <1195246545.2924.88.camel@localhost.localdomain>
	 <Xine.LNX.4.64.0711170845050.22208@us.intercode.com.au>
	 <1195250009.2924.103.camel@localhost.localdomain>
	 <Xine.LNX.4.64.0711170856200.22208@us.intercode.com.au>
Content-Type: text/plain
Date: Fri, 16 Nov 2007 17:07:20 -0500
Message-Id: <1195250840.2924.113.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-11-17 at 08:58 +1100, James Morris wrote:
> On Fri, 16 Nov 2007, Eric Paris wrote:
> 
> > On Sat, 2007-11-17 at 08:47 +1100, James Morris wrote:
> > > On Fri, 16 Nov 2007, Eric Paris wrote:
> > > 
> > > > On a kernel with CONFIG_SECURITY but without an LSM which implements
> > > > security_file_mmap it is impossible for an application to mmap addresses
> > > > lower than mmap_min_addr.
> > > 
> > > Actually, should we be doing any checking in the dummy module, given that 
> > > it is not done with !CONFIG_SECURITY ?
> > 
> > I'm not sure I understand the question.  We already do a number of
> > capable type security checks in dummy functions. See dummy_settime() as
> > just one example.
> 
> I mean just in this case.  If no mmap_min_addr check is done without 
> CONFIG_SECURITY, then perhaps none should be done in the dummy module, 
> i.e. preserving existing behavior.  LSM is theoretically supposed to be 
> unnoticable from a behavioral pov unless a non-dummy module is loaded.

When this protection was originally concieved it intentionally was
offing something even without an more 'full featured' LSM.  That was the
whole reason I had to drop the secondary stacking hook inside the
selinux code.

While I now understand the question, I think that this is the behavior
most people would want.  I'll revert the security enhancement for
non-LSM systems if others agree with James, but I think adding another
small bit of protection against kernel flaws for everyone who wants
security is a win.  (and remember, in kernel we still default this to
off so noone is going to 'accidentally' see and security checks in the
dummy hooks)

-Eric

