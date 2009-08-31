Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbZHaGdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbZHaGdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 02:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbZHaGdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 02:33:36 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:59159 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbZHaGdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 02:33:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GCUZ1kTtlWbu/Fd2klLZyrrrFihZl+dGOlBi+rOQwvUBIUlGoOlND5xc1V6nQuVDxJ
         RtTfENuRi1pSwBFNvrwj3dGJ7KGMTGpbICo2t2s1GAQmoU3GeqGSGbA7AWia24BAIw2O
         MhH3QLvnPxTleHUBB2tlxXzxSiP4bbBlxBey4=
Date: Mon, 31 Aug 2009 10:33:34 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Christoph Hellwig <hch@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix proc_file_write missing ppos update
Message-ID: <20090831063334.GB7821@x200.localdomain>
References: <1251563892.13287.11.camel@wall-e> <20090829231650.GA29419@infradead.org> <1251659144.20987.18.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251659144.20987.18.camel@wall-e>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 09:05:44PM +0200, Stefani Seibold wrote:
> Am Samstag, den 29.08.2009, 19:16 -0400 schrieb Christoph Hellwig:
> > On Sat, Aug 29, 2009 at 06:38:12PM +0200, Stefani Seibold wrote:
> > > The following fix a long standing issue in the proc_file_write function,
> > > which doesn't update the ppos file position pointer.
> > 
> > The right fix is to get rid of the last remaining
> > read_proc_t/write_proc_t instances and switch everyone to implement file
> > operations.  Alexey has been working on this on and off for a while.
> > 
> 
> Switching all users of read_proc_t/write_proc_t to file operation is a
> huge job. About 180 files must be fixed.

Less, staging stuff is on it's own.

> But the main reason not to do this is because the breakage of "out of
> tree" drivers.

Just how many times it needs to be repeated.

Out-of-tree argument means almost nothing.

> I like the current simplified proc interface. It saves a lot of code
> duplication because the basic operations will be handled inside the
> kernel and not in the driver.

It's garbage.

Arbirtrary 3 KB limit on read,
kernel memory giving trailer in ->read_proc which is impossible to get right,
was always buggy wrt module unload (quickly fixed, but it was always meant
to be temporary).

Now that SCSI pile is mostly finished, what a horrible code interface provoked.

> There is no reason for Alexey to finish his work, submit it and maybe it
> will be accepted. 

You'd better start converting to struct file_operations::write now.

> In the meantime i will see my patch as the preferred solution: a cleanup
> of the current interface.
