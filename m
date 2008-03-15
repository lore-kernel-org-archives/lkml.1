Return-Path: <linux-kernel-owner+w=401wt.eu-S1755744AbYCOWBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbYCOWBV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 18:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbYCOWBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 18:01:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbYCOWBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 18:01:05 -0400
Date: Sat, 15 Mar 2008 18:00:58 -0400
From: Alexander Viro <aviro@redhat.com>
To: Alan Cox <alan@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       aviro@redhat.com, drepper@redhat.com, hch@infradead.org,
       sds@tycho.nsa.gov, jmorris@namei.org
Subject: Re: [RFC] correct flags to f_mode conversion in __dentry_open
Message-ID: <20080315220058.GA4265@devserv.devel.redhat.com>
References: <1205346327.5297.232.camel@localhost.localdomain> <20080315215952.GB18676@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080315215952.GB18676@devserv.devel.redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2008 at 05:59:52PM -0400, Alan Cox wrote:
> On Wed, Mar 12, 2008 at 02:25:27PM -0400, Eric Paris wrote:
> > I recently tried to add an SELinux BUG_ON in the case where the kernel
> > made a permission request for no permissions and was able to stumble
> > over it with something as simple as
> > 
> > open("/dev/null", 3);
> > 
> > Notice that 3 == (O_RDWR | O_WRONLY)
> > 
> > First question, is 3 ever a valid flag from from userspace to sys_open?
> 
> Yes.
> 
> > does 11 really mean and should it really always be mapped to (FMODE_READ
> > | FMODE_WRITE) or should it continue to get mapped to 'no permission?'
> 
> We've always mapped 3 to "no permission" to read or write. It's a linuxism

Note that we *do* request MAY_READ|MAY_WRITE; "no permission" part is
about what you can do to resulting descriptor afterwards.
