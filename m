Return-Path: <linux-kernel-owner+w=401wt.eu-S1762081AbYBEWGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762081AbYBEWGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759676AbYBEWGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:06:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48568 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759438AbYBEWGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:06:22 -0500
Date: Tue, 5 Feb 2008 14:05:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Oliver Pinter" <oliver.pntr@gmail.com>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, "James Morris" <jmorris@namei.org>,
       linux-usb@vger.kernel.org, Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: [2.6.24 REGRESSION] BUG: Soft lockup - with VFS
Message-Id: <20080205140506.c6354490.akpm@linux-foundation.org>
In-Reply-To: <6101e8c40802051348w2250e593x54f777bb771bd903@mail.gmail.com>
References: <6101e8c40801280031v1a860e90gfb3992ae5db37047@mail.gmail.com>
	<20080204213911.1bcbaf66.akpm@linux-foundation.org>
	<1202219216.27371.24.camel@moss-spartans.epoch.ncsc.mil>
	<20080205104028.190192b1.akpm@linux-foundation.org>
	<6101e8c40802051115v12d3c02br24873ef1014dbea9@mail.gmail.com>
	<6101e8c40802051321l13268239m913fd90f56891054@mail.gmail.com>
	<6101e8c40802051348w2250e593x54f777bb771bd903@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008 22:48:29 +0100
"Oliver Pinter" <oliver.pntr@gmail.com> wrote:

> On 2/5/08, Oliver Pinter <oliver.pntr@gmail.com> wrote:
> > http://students.zipernowsky.hu/~oliverp/kernel/regression_2624/
> >
> > uploaded:
> > kernel image
> > .config
> > new pictures
> > lspci
> > lsusb
> >
> > -----
> >
> > when read for /dev/uba then crashed the kernel, the read is egal, thet
> > dd or mount is ...

Looks like you deadlocked in ub_request_fn().  I assume that you were using
ub.c in 2.6.23 and that it worked OK?  If so, we broke it, possibly via
changes to the core block layer.

I think ub.c is basically abandoned in favour of usb-storage.  If so,
perhaps we should remove or disble ub.c?
