Return-Path: <linux-kernel-owner+w=401wt.eu-S1751762AbZIJWiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbZIJWiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 18:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbZIJWiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 18:38:09 -0400
Received: from mvp.visionpro.com ([63.91.95.2]:1169 "EHLO
	mvpexchange120.machinevisionproducts.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750853AbZIJWiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 18:38:08 -0400
User-Agent: Microsoft-Entourage/12.20.0.090605
Date: Thu, 10 Sep 2009 15:38:11 -0700
Subject: mmap vs. real memory
From: Brian McGrew <brian@visionpro.com>
To: <linux-kernel@vger.kernel.org>
Message-ID: <C6CECDE3.13A4A%brian@visionpro.com>
Thread-Topic: mmap vs. real memory
Thread-Index: AcoyZ2AsA7HHZfJO5Eq2jZhzsJBqow==
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good afternoon all,

Right now, I'm in what appears [to me] to be a very tricky situation.  We
have several programs that all need access to the same memory.  Currently,
we use mmap and map to a file on disk like this:

const u_long    kCommsegSize            = 1024L * 1024L * 1024L;
const u_long    kCommsegMappedAddress   = 0xb0000000;

And then the code is:

    char *cseg_addr = reinterpret_cast<char *>(mmap(
            reinterpret_cast<char *>(kCommsegMappedAddress),
            size,
            PROT_READ  | PROT_WRITE,
            MAP_SHARED | MAP_FIXED,
            fd,
            0));
    gShmemOffset = kCommsegMappedAddress - kCommseg;
    return(cseg_addr);

And, all of this has worked great ever since we went from a physical shared
memory board on a vme bus to emulating shared memory on the computer.  In
the beginning, kCommsegSize was only 4MB (4L * 1024L * 1024L).

Now that we are needing more and more shared memory, we're seeing random
performance issues.  With 16MB, 64MB and 256MB (in recent past) all was
good.  But now, trying to allocate 1GB of shared memory, we see it taking
anywhere from .6 to 9 SEONDS to access the file.  No good!

What I'm wondering and needed to do is map a chunk of mymoery (1GB today,
maybe 2GB later on) so that all my apps can access it.  Short of creating a
ramdisk and moving the mmap'ed file to ramdisk, what is the best way to do
this???

Thanks,

-brian

