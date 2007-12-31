Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbXLaQL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbXLaQL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 11:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbXLaQLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 11:11:14 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:13084 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbXLaQLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 11:11:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NQiMall6MieX2itZNfd+zrUC/sXrQGwiUUC3QCJGcpUqvEIfieYzaY3gTBqmZpcab8z1K1HbYgwFzMSVW2IVPyJD2Nwd8+SByvAEqwb2metlKc7WoTqe2PzRIhNjwF6gzPJKUalwcCgoZXHgmewB1oJKjybXK3CTFy7TO5g2nDk=
Message-ID: <64bb37e0712310811r34423ff5q2e9516d02f6247de@mail.gmail.com>
Date: Mon, 31 Dec 2007 17:11:11 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH] Force UNIX domain sockets to be built in
Cc: "Adrian Bunk" <bunk@kernel.org>, "Bodo Eggert" <7eggert@gmx.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>, devzero@web.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <200712311659.14847.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LSU.0.999.0712311300020.3686@be1.lrz>
	 <20071231144255.GB13803@does.not.exist>
	 <64bb37e0712310755k2446e67eq81d31cd476eb75e3@mail.gmail.com>
	 <200712311659.14847.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 31, 2007 4:59 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Monday 31 December 2007 16:55:57 Torsten Kaiser wrote:
> > One thing I always wondered about in this discussion about wasted
> > EXPORT_SYMBOL's:
> > Shouldn't it be possible to garbage collect these?
> >
> > depmod already contains code to analyze all modules to create a
> > dependency tree. It should not be too difficult to extend it to create
> > a list of all symbols that really are used by the current modules.
> > Everything else could be stripped to save space.
> >
> > The problem with that:
> > * out-of-tree modules would break if they don't get lucky to only use
> > the remaining symbol. I would not see this as a problem, if the help
> > text of the garbage-collect-option would contain a note like "don't
> > enable this if you want out-of-tree modules".
> > * if you later change your .config to include additional modules you
> > might need to rebuild vmlinux and reboot into the new kernel.
> > Currently you can probably build and load new modules without a
> > reboot. (for example: usb drivers)
>
> I'd say the practical advantage to the user would be almost zero.
> Which distribution is going to enable this option and defacto
> banning external modules?

I would default this option to not remove used symbols, because it
could break something.
For distributions it could be used in both ways:
* enabled -> only "distro approved" modules can be loaded
* disabled -> works as of now

For every other user who compiles own kernels without external modules
(Not including out-of-tree drivers that get patched into the kernel
code! Only modules that get compiled later independent from the kernel
build!) it will save space.

If this space would not matter there would be no need to be so hard on
currently unused EXPORT_SYMBOLs.

Torsten
