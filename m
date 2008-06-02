Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbYFBS2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbYFBS2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 14:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYFBS2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 14:28:36 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:24355 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbYFBS2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 14:28:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=NSTYIj7OYq4VKWHn0DRc58F5u9myGEadGcvZBFIErc7GpLtVE1/l+EWTw4t183XvPsPqBcb/GHKAdycBUJXwpZfBTQXvu6WP6d8uneNypjLY0GAnhK37TpSZQCztlUkoLXGRhRPpbT1QhKpc9Nm0O3XZXEfksiNX7+cRcVlTVhA=
Message-ID: <6278d2220806021128h1dd76c16p9ab15142af2fcbdf@mail.gmail.com>
Date: Mon, 2 Jun 2008 19:28:21 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Rick van Rein" <rick@groengemak.nl>
Subject: Re: Future Linux on Bistable Storage
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 Jun, 14:40, Rick van Rein <rick@groengemak.nl> wrote:
> Hello,
>
> Future generations of Linux are likely to run on machines with non-volatile
> memories based on bistable technologies.  This will save the energy of DRAM
> refresh cycles and avoid the mechanical problems related to hard disks.  The
> result is probably a computer with no distinction between disk and RAM.
>
> Such computer architectures can conserve a lot of energy, as it is very
> simple to suspend and resume them: no data loss means no time needed to
> resume the system -- except perhaps for I/O initialisation.  Conserving
> energy means (1) having more fun|hours per kg of batteries, and (2) saving
> the planet.
>
> I wonder inhowfar Linux is (already) capable of dealing with such hardware.
> Several core concepts suddenly become meaningless if disk and RAM are merged
> into one storage device:
>  * swapping out data
>  * lazy loading of programs from disk to RAM
>  * buffering disk blocks
>  * mapping and unmapping disk onto RAM
[snip]

Perhaps one of the more key stepping stones here is execution in place
(XIP) support, which at present works for a particular combination of
embedded architecture, block device and filesystem. Maybe that's the
wrong way of looking at it, and we should consider XIP-for-ramdisk
(rather than ROM/flash).

Anyway, from a mmap() perspective, we'd be logically merging the
filesystem and pagecache layers and losing a layer of physical
indirection.
-- 
Daniel J Blueman
