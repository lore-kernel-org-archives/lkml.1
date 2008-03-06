Return-Path: <linux-kernel-owner+w=401wt.eu-S935252AbYCFSHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935252AbYCFSHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935166AbYCFSHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:07:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:48030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935164AbYCFSHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:07:32 -0500
Date: Thu, 6 Mar 2008 10:05:59 -0800
From: Greg KH <gregkh@suse.de>
To: Balaji Rao <balajirrao@gmail.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Mark kobjects as unitialized
Message-ID: <20080306180559.GA14934@suse.de>
References: <200803062223.18857.balajirrao@gmail.com> <20080306170514.GA13839@suse.de> <200803062320.50296.balajirrao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803062320.50296.balajirrao@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 11:20:50PM +0530, Balaji Rao wrote:
> On Thursday 06 March 2008 10:35:14 pm Greg KH wrote:
> <snip>
> > Where exactly in the code does that happen?  kobjects should not be
> > "reused" as that implies that they are static, and not dynamically
> > allocated, right?
> >
> > Which kobject is this?
> Yes, its static. Here's the code from virt/kvm_main.c:1269
> 
> static struct sys_device kvm_sysdev = {
>         .id = 0,
>         .cls = &kvm_sysdev_class,
> };
> 
> this sys_device is being registered/unregistered when kvm-intel is 
> loaded/unloaded.

Ah, ok.  I'll add this patch then.

> > Ugh, is this the sys_device stuff?  I hate that code...
> >
> Yes it is! But, why do you hate it ?

For reasons like this :)

kobjects should not be static.  the sysdevice stuff was a hack when it
was originally created and never touched since the mid 2.5 days.  It
needs to be fixed up a lot, and is on my TODO list, slowly getting
closer to the top...

thanks,

greg k-h
