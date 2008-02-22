Return-Path: <linux-kernel-owner+w=401wt.eu-S1760172AbYBVJMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172AbYBVJMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 04:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYBVJLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 04:11:40 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:1756 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbYBVJLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 04:11:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Z62H61b6F5OcLtdJn3J3k9H4PkrzeiZpFUz4pMPRT5mFC681//miw3S5OVtIgB5bXsilYbeBzWJpYxBgwYfUS0YK7mpaI+BKpt+nMcjFttEIJ9Lt1yTKCd0RA/ClKkobramgptC7OjuWU0QxQnqENCEmMSW6smvzRDIg+/iHoRQ=
Message-ID: <3ae72650802220111s11e68f1ft149d7832e9bebbd6@mail.gmail.com>
Date: Fri, 22 Feb 2008 10:11:33 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: Linux 2.6.24.1 - kernel does not boot; IRQ trouble?
Cc: "Chris Rankin" <rankincj@yahoo.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <3ae72650802190047l5a1f07d9u5fc2031ac92608b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080218085333.3d32b626@extreme>
	 <395400.45093.qm@web52907.mail.re2.yahoo.com>
	 <20080218120636.00451d46@extreme>
	 <3ae72650802190047l5a1f07d9u5fc2031ac92608b6@mail.gmail.com>
X-Google-Sender-Auth: 4e3725a6412729df
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 9:47 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Feb 18, 2008 9:06 PM, Stephen Hemminger <shemminger@linux-foundation.org> wrote:
>  > On Mon, 18 Feb 2008 19:42:25 +0000 (GMT)
>  > Chris Rankin <rankincj@yahoo.com> wrote:
>  >
>  > > --- Stephen Hemminger <shemminger@linux-foundation.org> wrote:
>  > > > > > sysfs: duplicate filename 'bridge' can not be created
>  > > > > > WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
>  > > > > > Pid: 1, comm: swapper Not tainted 2.6.24.1 #1
>  > > > > >  [<c0105020>] show_trace_log_lvl+0x1a/0x2f
>  > > > > >  [<c0105990>] show_trace+0x12/0x14
>  > > > > >  [<c010613d>] dump_stack+0x6c/0x72
>  > > > > >  [<c01991bf>] sysfs_add_one+0x57/0xbc
>  > > > > >  [<c0199e41>] sysfs_create_link+0xc2/0x10d
>  > > > > >  [<c01bae9a>] pci_bus_add_devices+0xbd/0x103
>  > > > > >  [<c034016c>] pci_legacy_init+0x56/0xe3
>  > > > > >  [<c03274e1>] kernel_init+0x157/0x2c3
>  > > > > >  [<c0104c83>] kernel_thread_helper+0x7/0x10
>  > > > > >  =======================
>  > > > > > pci 0000:00:01.0: Error creating sysfs bridge symlink, continuing...
>  > > > > > sysfs: duplicate filename 'bridge' can not be created
>  > > > > > WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()

Greg,
it seems that:
  arch/x86/pci/legacy.c :: pci_legacy_init()

tries to create already created "bridge" symlinks in 2.6.24. So we
discover the same devices twice? Can this be a reason for the hang?

I guess in 2.6.25, the warning is gone with:
  commit fd7d1ced29e5beb88c9068801da7a362606d8273
  Author: Greg Kroah-Hartman <gregkh@suse.de>
  Date:   Tue May 22 22:47:54 2007 -0400

  PCI: make pci_bus a struct device

  This moves the pci_bus class device to be a real struct device and at
  the same time, place it in the device tree in the correct location.
  Note, the old "bridge" symlink is now gone.

Thanks,
Kay
