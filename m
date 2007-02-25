Return-Path: <linux-kernel-owner+w=401wt.eu-S964962AbXBYPis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964962AbXBYPis (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 10:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964964AbXBYPis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 10:38:48 -0500
Received: from lazybastard.de ([212.112.238.170]:35680 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964962AbXBYPir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 10:38:47 -0500
Date: Sun, 25 Feb 2007 12:01:39 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Juan Piernas Canovas <piernas@ditec.um.es>
Cc: Sorin Faibish <sfaibish@emc.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
Message-ID: <20070225120138.GA19047@lazybastard.org>
References: <20070220003059.GJ7813@lazybastard.org> <Pine.LNX.4.61.0702210507500.882@ditec.inf.um.es> <20070221123753.GA464@lazybastard.org> <Pine.LNX.4.61.0702211925570.13823@ditec.inf.um.es> <20070221192523.GG3219@lazybastard.org> <Pine.LNX.4.61.0702220428180.9002@ditec.inf.um.es> <20070222162547.GB7149@lazybastard.org> <Pine.LNX.4.61.0702222033460.19296@ditec.inf.um.es> <20070223132645.GB11653@lazybastard.org> <Pine.LNX.4.61.0702250255530.18915@ditec.inf.um.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.61.0702250255530.18915@ditec.inf.um.es>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 February 2007 03:41:40 +0100, Juan Piernas Canovas wrote:
> 
> Well, our experimental results say another thing. As I have said, the 
> greatest part of the files are written at once, so their meta-data blocks 
> are together on disk. This allows DualFS to implement an explicit 
> prefetching of meta-data blocks which is quite effective, specially when 
> there are several processes reading from disk at the same time.
> 
> On the other hand, DualFS also implements an on-line meta-data relocation 
> mechanism which can help to improve meta-data prefetching, and garbage 
> collection.
> 
> Obviously, there can be some slow-growing files that can produce some 
> garbage, but they do not hurt the overall performance of the file system.

Well, my concerns about the design have gone.  There remain some
concerns about the source code and I hope they will disappear just as
fast. :)

Obviously, a patch against 2.4.x is fairly useless.  Iirc, you claimed
somewhere to have a patch against 2.6.11, but I was unable to find that.
Porting 2.6.11 to 2.6.20 should be simple enough.

Then there is some assembly code inside the patch that you seem to have
copied from some other project.  I would be surprised if that is really
required.  If you can replace it with C code, please do.

If the assembly actually is a performance gain (and I consider it your
duty to prove that), you can have a two-patch series with the first
introducing DualFS and the second adding the assembly as a config option
for one architecture.

> Yeah :) If you have taken a look to my presentation at LFS07, the disk 
> traffic of meta-data blocks is dominated by writes.

Last time I tried it was only available to members.  Is it generally
available now?

Jörn

-- 
My second remark is that our intellectual powers are rather geared to
master static relations and that our powers to visualize processes
evolving in time are relatively poorly developed.
-- Edsger W. Dijkstra
