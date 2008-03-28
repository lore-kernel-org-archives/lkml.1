Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbYC1U1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbYC1U1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbYC1U1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:27:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326AbYC1U1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:27:22 -0400
Date: Fri, 28 Mar 2008 13:22:26 -0700
From: Greg KH <gregkh@suse.de>
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc7: udevd compatibility issue?
Message-ID: <20080328202226.GA16799@suse.de>
References: <47ED3DDE.3030201@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47ED3DDE.3030201@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 02:50:06PM -0400, Mark Lord wrote:
> Having coerced 2.6.25-rc7 onto one notebook here,
> we're now working on the other one.
>
> This one is the Dell Lattitude X1 sub-notebook, with Intel everything and 
> 2GB.
>
> On boot, syslog is flooded with "uevent: unsupported action-string;" 
> messages.
> The messages claim "this will be ignored in a future kernel", but this is 
> not a "future kernel".
>
> So, what purpose do they have in 2.6.25-rc7 ?

To tell you nicely that your userspace scripts are doing stupid things
:)

> The system is using udev-079, which came with the distro 2 years ago.

As per the Documentation/CHANGES file, that is not going to work out so
well.

However, this is not udev that is causing the problem, it is your
startup scripts.  Let me guess, ubuntu?

> Mar 28 14:43:29 shrimp syslogd 1.4.1#17ubuntu7.1: restart.

Ah, how did I know.  Yeah, it's their fault, they are writing something
stupid into a sysfs file expecting the kernel just to ignore it.  Try
updating the package and it should go away.  Or you can ignore it for
now, but I'd recommend fixing it.

thanks,

greg k-h
