Return-Path: <linux-kernel-owner+w=401wt.eu-S1762557AbYHFCxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762557AbYHFCxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 22:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758540AbYHFCqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 22:46:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49396 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758015AbYHFCqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 22:46:07 -0400
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: "Eric Paris" <eparis@redhat.com>, "Greg KH" <greg@kroah.com>,
       <linux-kernel@vger.kernel.org>, <malware-list@lists.printk.net>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface foron access scanning
From: Andi Kleen <andi@firstfloor.org>
References: <1217883616.27684.19.camel@localhost.localdomain>
	<20080804223249.GA10517@kroah.com>
	<1217896374.27684.53.camel@localhost.localdomain>
	<2629CC4E1D22A64593B02C43E855530304807431@USILMS12.ca.com>
Date: Wed, 06 Aug 2008 04:46:05 +0200
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304807431@USILMS12.ca.com> (Jonathan Press's message of "Tue, 5 Aug 2008 10:41:44 -0400")
Message-ID: <87vdye6etu.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Press, Jonathan" <Jonathan.Press@ca.com> writes:
>
> Also...  I was one of the people who brought up the idea of a process
> exclusion when the requirements list was being developed.  I intended it
> as a way that an AV application could exclude specific OTHER processes
> by name (as selected by the AV user)

There's no fixed process name in Linux that cannot be easily faked: 

Use process name -- every process can change that by writing to its own
environment.
Use comm name -- there's a prctl to change that and there can be collisions
Use path name of binary -- breaks with chroot and name spaces. Also existing
binaries can be subverted.
Use inode of binary -- can be faked with fuse and breaks when the binaries
is copied ...
Use dev, inode -- breaks when copying binary and when running on network
file systems without a device node

-Andi

