Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbYCOWAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbYCOWAR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 18:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbYCOWAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 18:00:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbYCOWAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 18:00:01 -0400
Date: Sat, 15 Mar 2008 17:59:52 -0400
From: Alan Cox <alan@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, alan <alan@redhat.com>, aviro@redhat.com,
       drepper@redhat.com, hch@infradead.org, sds@tycho.nsa.gov,
       jmorris@namei.org
Subject: Re: [RFC] correct flags to f_mode conversion in __dentry_open
Message-ID: <20080315215952.GB18676@devserv.devel.redhat.com>
References: <1205346327.5297.232.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205346327.5297.232.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 02:25:27PM -0400, Eric Paris wrote:
> I recently tried to add an SELinux BUG_ON in the case where the kernel
> made a permission request for no permissions and was able to stumble
> over it with something as simple as
> 
> open("/dev/null", 3);
> 
> Notice that 3 == (O_RDWR | O_WRONLY)
> 
> First question, is 3 ever a valid flag from from userspace to sys_open?

Yes.

> does 11 really mean and should it really always be mapped to (FMODE_READ
> | FMODE_WRITE) or should it continue to get mapped to 'no permission?'

We've always mapped 3 to "no permission" to read or write. It's a linuxism


