Return-Path: <linux-kernel-owner+w=401wt.eu-S1759339AbXHTMiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339AbXHTMiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 08:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757482AbXHTMhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 08:37:35 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:23504 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbXHTMgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 08:36:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=oby6wX8TZFW9aFW2jQDLAbnXOXd70xcxtGTQSe0ZB+bCMLC2CW10Qy1lUcntZwDMAj23hR3E9vq3CudqMJj5t1mJlUe86N40n6Ae+cAavm6oL5fHYDsTTqSgDLhtVPjeVf8wZvyZIwkduZykU9xHnUaepSc73bKdGrn5p5CrToQ=
Message-ID: <6278d2220708200536r786ee72ere7522547c375a428@mail.gmail.com>
Date: Mon, 20 Aug 2007 13:36:46 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Dave Airlie" <airlied@gmail.com>
Subject: Re: uncached page allocator
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 Aug, 01:50, "Dave Airlie" <airlied@gmail.com> wrote:
> Hi all,
>
> I've started doing some work with using the new DRM memory manager
> from TG for pixmaps in the X server using Intel 9xx series hardware.
>
> The intel hardware pretty much requires pages to be uncached for the
> GPU to access them. It can use cached memory for some operations but
> it isn't very useful and my attempts to use it ended in a lot of
> crashiness..

Write-combining access seems the correct thing here, followed by a
wmb(). Uncached writing would be horrendously slow.

[snip]
> So after all that I'd like to have some sort of uncached page list I
> can allocate pages from

This is exactly what Intel's PAT mechanism exists for - just mark the
desired access type (index) on the pages you've been allocated.

It's documented in the Intel Architecture Software Design manuals, but
Linux's support is lacking in certain areas [discussions on LKML],
which a number of developers have been trying to move forward.

Quite a few significant graphics/HPC etc vendors are forced to use it
without this complete support, so it would be good to get this
additional impetus involved...

Daniel
-- 
Daniel J Blueman
