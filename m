Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbZBLQFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbZBLQFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 11:05:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757931AbZBLQE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 11:04:59 -0500
Received: from ns1.suse.de ([195.135.220.2]:59510 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbZBLQE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 11:04:58 -0500
Date: Thu, 12 Feb 2009 08:02:57 -0800
From: Greg KH <gregkh@suse.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alex Chiang <achiang@hp.com>, alex.williamson@hp.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: sysfs_add_one tells you _where_ the duplicate
	file is
Message-ID: <20090212160257.GA18786@suse.de>
References: <20090211202601.GC3402@ldl.fc.hp.com> <20090211223903.GA21100@suse.de> <20090212025655.GA6916@ldl.fc.hp.com> <20090212030227.GA4859@suse.de> <20090212070210.GB6916@ldl.fc.hp.com> <ac3eb2510902120105u17f5a0f9q13a228b9ff6ff3d4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510902120105u17f5a0f9q13a228b9ff6ff3d4@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 10:05:23AM +0100, Kay Sievers wrote:
> On Thu, Feb 12, 2009 at 08:02, Alex Chiang <achiang@hp.com> wrote:
> 
> > sysfs: sysfs_add_one WARNs with full path to duplicate filename
> >
> > As a debugging aid, it can be useful to know the full path to a
> > duplicate file being created in sysfs.
> 
> >        ret = __sysfs_add_one(acxt, sd);
> > -       WARN(ret == -EEXIST, KERN_WARNING "sysfs: duplicate filename '%s' "
> > -                      "can not be created\n", sd->s_name);
> > +       if (ret == -EEXIST) {
> > +               char path[PATH_MAX];
> 
> Isn't that 4k on the stack, and a bit large to put there?

I agree, that's not ok.  Alex, care to redo this?

thanks,

greg k-h
