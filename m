Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbYDCXKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbYDCXKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 19:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYDCXJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 19:09:58 -0400
Received: from ozlabs.org ([203.10.76.45]:43158 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbYDCXJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 19:09:58 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: module parameters versus kernel command line
Date: Fri, 4 Apr 2008 09:09:28 +1000
User-Agent: KMail/1.9.9
Cc: Tom Horsley <tom.horsley@ccur.com>, linux-kernel@vger.kernel.org
References: <20080403090053.56f243df@tomh> <20080403120425.232cb1ba@tomh> <20080403091444.827d954a.randy.dunlap@oracle.com>
In-Reply-To: <20080403091444.827d954a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804040909.28983.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 April 2008 02:14:44 Randy Dunlap wrote:
> On Thu, 3 Apr 2008 12:04:25 -0400 Tom Horsley wrote:
> > I know that part, I'm just wondering if it would be nice to have
> > even dynamically loaded modules notice the kernel option
> > so that the "usbcore" module would see the "blinkenlights=1"
> > parameter from the kernel boot options when dynamically loaded?
> >
> > That way, you wouldn't have to stop and figure out if a module
> > was static or dynamic to decide if you need to edit the grub boot
> > line or the modprobe.conf file.
>
> OK, that makes some sense to me.
>
> Rusty added to cc for his objective viewpoint.

I agree with Randy; it has some appeal, but it's not a killer feature.

We already do the reverse: sysfs exposed parameters are the same for modules 
and builtins.  If they're modifiable (most aren't), you don't have to care 
whether it's a module or not.

But there are also minor downsides.  The first is that we currently warn about 
unused parameters (at least those containing '.').  We'd have to come up with 
something cleverer if we want to warn only about parameters which cannot be 
used by modules (ie. do it in userspace).

The second is that users might be surprised when they take 
the 'usbcore.blinkenlights' line out of their modprobe config file and it 
still applies.  Most users use everything-is-a-module distributions.

Finally, it would be logical to take all the module parameters and autogen 
them into the kernel commandline, but it will soon hit cmdline limits (hmm, 
actually on my Ubuntu Hardy system here I think I'd be OK).

Cheers,
Rusty.
