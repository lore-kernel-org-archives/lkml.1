Return-Path: <linux-kernel-owner+w=401wt.eu-S1423494AbXBPJpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423494AbXBPJpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 04:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423495AbXBPJpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 04:45:35 -0500
Received: from lazybastard.de ([212.112.238.170]:35684 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423494AbXBPJpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 04:45:35 -0500
Date: Fri, 16 Feb 2007 09:13:21 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Juan Piernas Canovas <piernas@ditec.um.es>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, sfaibish <sfaibish@emc.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
Message-ID: <20070216091321.GA28092@lazybastard.org>
References: <op.tnkdlbgsrwwil4@brcsmondepl2c.corp.emc.com> <op.tnrbrocsunckof@usensfaibisl2e.eng.emc.com> <Pine.LNX.4.61.0702142251460.19368@yvahk01.tjqt.qr> <Pine.LNX.4.61.0702151910370.19998@ditec.inf.um.es> <20070215200922.GB24643@lazybastard.org> <Pine.LNX.4.61.0702152353060.19998@ditec.inf.um.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.61.0702152353060.19998@ditec.inf.um.es>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 February 2007 23:59:14 +0100, Juan Piernas Canovas wrote:
> >
> Actually, the version of DualFS for Linux 2.4.19 implements a cleaner. In 
> our case, the cleaner is not really a problem because there is not too 
> much to clean (the meta-data device only contains meta-data blocks which 
> are 5-6% of the file system blocks; you do not have to move data blocks).

That sounds as if you have not hit the "interesting" cases yet.  Fun
starts when your device is near-full and you have a write-intensive
workload.  In your case, that would be metadata-write-intensive.  For
one, this is where write performance of log-structured filesystems
usually goes down the drain.  And worse, it is where the cleaner can
run into a deadlock.

Being good where log-structured filesystems usually are horrible is a
challenge.  And I'm sure many people are more interested in those
performance number than in the ones you shine at. :)

Jörn

-- 
Joern's library part 14:
http://www.sandpile.org/
