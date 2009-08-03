Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbZHCHqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbZHCHqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 03:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbZHCHqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 03:46:03 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:35148 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbZHCHqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 03:46:00 -0400
Date: Mon, 3 Aug 2009 13:15:54 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: Re: ext4 ioctl(FIEMAP) bug? observed in 2.6.29.4 (32-bit x86)
Message-ID: <20090803074554.GA21042@skywalker>
References: <4A76069C.1010801@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A76069C.1010801@rtr.ca>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 02, 2009 at 05:35:24PM -0400, Mark Lord wrote:
> I have been stressing out the FIEMAP ioctl() quite a bit recently,
> while working on the wiper.sh SSD TRIM utility (part of the hdparm package).
>
> For an hour or so today, things got very confusing.
> My wiper.sh script stopped working correctly, and I narrowed
> it down to FIEMAP's incorrect use of the "LAST" flag.
>
> Normally, FIEMAP signals the final extent of a file by
> setting the "LAST" bit (bit-0) in flags.
> When the application sees this flag, it knows it should
> not need to issue any more FIEMAP calls.
>
> But suddenly, for a couple of hours today, FIEMAP began
> setting the "LAST" flag on every single FIEMAP call,
> tricking my code into thinking that the file being
> queried was a lot smaller than it really was.
>
> No strace(), because I still hadn't figured-out what was going on,
> but I did save this trace from debug code inside hdparm.
>
> The file being FIEMAP'd was a 50GB+ file, filling the ext4
> filesystem to near 100% capacity.  I have no idea what caused
> FIEMAP to misbehave, but after a couple of hours it suddenly
> started working correctly again.
>
> This was all observed on 32-bit x86 Linux-2.6.29.4,
> and no, it is not reproduceable.
>
> A command-line "sync" was done before the file was
> opened for FIEMAP.
>
> The output below shows the sequence of FIEMAP calls
> on the single massive file.  Notice that the first call
> returned the "LAST" flag set, despite there being many
> many more extents after that bunch.
>

Can you try with

commit c9877b205f6ce7943bb95281342f4001cc1c00ec
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Fri May 1 23:32:06 2009 -0400

    ext4: fix for fiemap last-block test

-aneesh
