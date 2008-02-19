Return-Path: <linux-kernel-owner+w=401wt.eu-S1759391AbYBSIri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbYBSIri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 03:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbYBSIr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 03:47:26 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:51679 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbYBSIrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 03:47:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=q3VaMeC4Zvk+jEt0e4jXAoPPgJCLF5eoIdWswo2sNR7/J+JwUgIontrZNYmx2r6iDA4yU4f3DzUyYOC8Ua4Ldf28oa3weXQUOVJCKVWGgb0TAppraeEquwZGDk/6DumLVNTw9VfdY/PH5KTqgqgp9gETTUB/zud8iHNV1FxIUQo=
Message-ID: <3ae72650802190047l5a1f07d9u5fc2031ac92608b6@mail.gmail.com>
Date: Tue, 19 Feb 2008 09:47:23 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: Linux 2.6.24.1 - kernel does not boot; IRQ trouble?
Cc: "Chris Rankin" <rankincj@yahoo.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20080218120636.00451d46@extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080218085333.3d32b626@extreme>
	 <395400.45093.qm@web52907.mail.re2.yahoo.com>
	 <20080218120636.00451d46@extreme>
X-Google-Sender-Auth: 9a3e6e22fbf6a081
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 18, 2008 9:06 PM, Stephen Hemminger
<shemminger@linux-foundation.org> wrote:
> On Mon, 18 Feb 2008 19:42:25 +0000 (GMT)
> Chris Rankin <rankincj@yahoo.com> wrote:
>
> > --- Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> > > > > sysfs: duplicate filename 'bridge' can not be created
> > > > > WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> > > > > Pid: 1, comm: swapper Not tainted 2.6.24.1 #1
> > > > >  [<c0105020>] show_trace_log_lvl+0x1a/0x2f
> > > > >  [<c0105990>] show_trace+0x12/0x14
> > > > >  [<c010613d>] dump_stack+0x6c/0x72
> > > > >  [<c01991bf>] sysfs_add_one+0x57/0xbc
> > > > >  [<c0199e41>] sysfs_create_link+0xc2/0x10d
> > > > >  [<c01bae9a>] pci_bus_add_devices+0xbd/0x103
> > > > >  [<c034016c>] pci_legacy_init+0x56/0xe3
> > > > >  [<c03274e1>] kernel_init+0x157/0x2c3
> > > > >  [<c0104c83>] kernel_thread_helper+0x7/0x10
> > > > >  =======================
> > > > > pci 0000:00:01.0: Error creating sysfs bridge symlink, continuing...
> > > > > sysfs: duplicate filename 'bridge' can not be created
> > > > > WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> > > > > Pid: 1, comm: swapper Not tainted 2.6.24.1 #1
> > > > >  [<c0105020>] show_trace_log_lvl+0x1a/0x2f
> > > > >  [<c0105990>] show_trace+0x12/0x14
> > > > >  [<c010613d>] dump_stack+0x6c/0x72
> > > > >  [<c01991bf>] sysfs_add_one+0x57/0xbc
> > > > >  [<c0199e41>] sysfs_create_link+0xc2/0x10d
> > > > >  [<c01bae9a>] pci_bus_add_devices+0xbd/0x103
> > > > >  [<c01bae82>] pci_bus_add_devices+0xa5/0x103
> > > > >  [<c034016c>] pci_legacy_init+0x56/0xe3
> > > > >  [<c03274e1>] kernel_init+0x157/0x2c3
> > > > >  [<c0104c83>] kernel_thread_helper+0x7/0x10
> > > > >  =======================
> > > >
> > > > I have a vague feeling that this was fixed, perhaps in 2.6.24.x?
> > >
> > > Never heard of this, what is the initialization script that causes this?
> > > Also do you have the SYSFS_DEPRECATED option configured? that caused issues
> > > with regular network drivers.
> >
> > Yes, SYSFS_DEPRECATED is enabled. And the init scripts are from Fedora 8.
>
> There was a bug (fixed in 2.6.24) that had to do with sysfs_create_link
> and SYSFS_DEPRECATED probably there is a similar problem with directories.

Chris, could you enable CONFIG_DEBUG_KOBJECT=y, it might show what
objects try to claim the same name.

Thanks,
Kay
