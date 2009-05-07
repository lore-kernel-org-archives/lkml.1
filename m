Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbZEGMoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbZEGMoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 08:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbZEGMo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 08:44:29 -0400
Received: from hera.cwi.nl ([192.16.191.8]:61777 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbZEGMo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 08:44:28 -0400
X-Greylist: delayed 1961 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 May 2009 08:44:28 EDT
Date: Thu, 7 May 2009 14:10:17 +0200
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: linux-kernel@vger.kernel.org
Subject: madvise failure
Message-ID: <20090507121012.GA17048@ub>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In an application something like
	p = mmap(0, sz, PROT_READ, MAP_PRIVATE, fd, 0);
	madvise(p, sz, MADV_SEQUENTIAL);
is done for a small number of files, each with a size of a few GB.
A single sequential pass is done over these files - essentially a merge.

On an old machine the madvise is useful, and decreases total time.
But on a more recent machine, with more memory, the madvise makes
things worse. There, it seems better not to reveal to the kernel
that the data will be read sequentially.

Timing (six files of 4GB each, quadcore Intel Q9550, 16GB memory,
kernel 2.6.27 [Ubuntu], two other processes active):
with madvise, 7 runs: real time varying 9m10s - 37m29s,
without madvise, 6 runs: real time fairly constant 5m45s - 5m54s.


Andries

