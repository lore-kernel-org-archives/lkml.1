Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbZCKS0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbZCKS0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 14:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbZCKS0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 14:26:35 -0400
Received: from mx1.suse.de ([195.135.220.2]:35898 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbZCKS0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 14:26:35 -0400
Date: Wed, 11 Mar 2009 11:19:04 -0700
From: Greg KH <gregkh@suse.de>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Alex Chiang <achiang@hp.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       jbarnes@virtuousgeek.org, tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] sysfs: only allow one scheduled removal callback
	per kobj
Message-ID: <20090311181904.GA10309@suse.de>
References: <20090310232027.GC25665@ldl.fc.hp.com> <20090311044151.GB25840@suse.de> <20090311070359.GF25665@ldl.fc.hp.com> <20090311153228.GA21217@suse.de> <20090311184729.110761e4@gondolin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311184729.110761e4@gondolin>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 06:47:29PM +0100, Cornelia Huck wrote:
> On Wed, 11 Mar 2009 08:32:28 -0700,
> Greg KH <gregkh@suse.de> wrote:
> 
> > Why can't you use device_unregister()?  Or, you could use device_del(),
> > which lets you rely on the fact that the device structure is still
> > around for a bit, but it will disappear from sysfs.  Just don't forget
> > to do the final put_device() on it to free the memory and "really"
> > release it.
> > 
> > Or am I missing something else here?
> 
> You can't unregister a device from one of its attribute callbacks,

Doh!  You're right, very sorry Alex for missing this.

> (For the original oops, I'd rather solve the problem by making sure the
> caller doesn't trigger removal several times - should probably be less
> code than the proposed patch?)

Any ideas on how to do this?

thanks,

greg k-h
