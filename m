Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab0CJXNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 18:13:13 -0500
Received: from cantor.suse.de ([195.135.220.2]:39467 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932900Ab0CJXNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 18:13:08 -0500
Date: Wed, 10 Mar 2010 15:11:16 -0800
From: Greg KH <gregkh@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] numa: fix BUILD_BUG_ON for node_read_distance
Message-ID: <20100310231116.GA6797@suse.de>
References: <alpine.DEB.2.00.1003101449480.21849@chino.kir.corp.google.com>
 <20100310225841.GA6536@suse.de>
 <alpine.DEB.2.00.1003101501330.15549@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003101501330.15549@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 03:05:47PM -0800, David Rientjes wrote:
> On Wed, 10 Mar 2010, Greg KH wrote:
> 
> > > node_read_distance() has a BUILD_BUG_ON() to prevent buffer overruns when
> > > the number of nodes printed will exceed the buffer length.
> > > 
> > > Each node only needs four chars: three for distance (maximum distance is
> > > 255) and one for a seperating space or a trailing newline.
> > 
> > Is this causing a problem as-is today that we need to resolve for
> > 2.6.34?  Or is this 2.6.35 material?
> > 
> 
> It's not needed at least for x86 for 2.6.34 since the max 
> CONFIG_NODES_SHIFT is 9.  I don't know about other architectures with 
> different ranges or page sizes.
> 
> I'm going to push a change to the x86 maintainers to increase that max 
> CONFIG_NODES_SHIFT to 10 hopefully for 2.6.35, that's where we run into 
> this error.

Ok, I'll queue this up for .35, thanks.

greg k-h
