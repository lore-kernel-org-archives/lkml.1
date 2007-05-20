Return-Path: <linux-kernel-owner+w=401wt.eu-S1758331AbXETNYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331AbXETNYX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 09:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbXETNYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 09:24:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:9076 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619AbXETNYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 09:24:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M6NOKvk0AsT8PYifmmFlG0f9EXnTlocQpz8lzCC3iqj5BJCirKto5xw4Rwd/6OteBr5PEGoNb46/8acg8bPsciVzDAcn/ci8oXgaasjQhmt/dJAUVLFfNvj6p70EJtOr7Yez08zlo2/E4+bszXhChSkYJxJEuE7gN4cKxI/leMs=
Message-ID: <a781481a0705200624q5f62a492o708a2e1c5e8d4c3c@mail.gmail.com>
Date: Sun, 20 May 2007 18:54:12 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Srihari Vijayaraghavan" <sriharivijayaraghavan@yahoo.com.au>
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
Cc: "Christoph Lameter" <clameter@sgi.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <380486.61048.qm@web52604.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705200011200.18989@schroedinger.engr.sgi.com>
	 <380486.61048.qm@web52604.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au> wrote:
> --- Christoph Lameter <clameter@sgi.com> wrote:
> > On Sun, 20 May 2007, Srihari Vijayaraghavan wrote:
> >
> > > Code: 0f ob eb fe 48 8b 1b 48 8b 0x 0f 18 08 48 81 fb 60 cb 51 80
> > > RIP [...] slab_sysfs_init+0x49/0x98
> > > RSP [...]
> > > kernel panic - not syncing: Attempted to kill init!
> >
> > sysfs? If you build without CONFIG_SLUB_DEBUG then SLUB will not use
> > sysfs. You can switch that off in the embedded section.
>
> Fair enough. Would you the section name it appears in 'menuconfig'?
>
> I looked under 'Kernel hacking' section (where the slab debugging appears if
> slab is turned on as 'Debug slab memory allocation') & in the 'General setup'
> section also. I unable to figure out how to disable slub debugging :-(.

SLUB_DEBUG is both "bool if EMBEDDED" and "depends on SLUB", which
means just getting it to be visible in "menuconfig" is quite a challenge :-)

You first need to go into the choice where you pick the allocators ("Choose
allocator --->" which is the last option in General Setup), and then pick
SLUB as your allocator.

Then, from the General Setup again, turn on the "Configure standard
kernel features (for small systems) --->" just above the previous option
and then go into that menu. Now the option to disable SLUB_DEBUG
(which is y by default) becomes visible, so just deselect it to disable it.
