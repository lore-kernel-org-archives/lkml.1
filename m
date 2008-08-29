Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbYH2Ikv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbYH2Ikv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbYH2Ikm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:40:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62089 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbYH2Ikl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:40:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH RFC] nilfs2: continuous snapshotting file system
Date: Fri, 29 Aug 2008 10:40:06 +0200
User-Agent: KMail/1.9.9
Cc: Jorn Engel <joern@logfs.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080827181904.GD1371@logfs.org> <200808290629.AA00218@capsicum.lab.ntt.co.jp>
In-Reply-To: <200808290629.AA00218@capsicum.lab.ntt.co.jp>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808291040.06917.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18puYSpORKsyenyZp7kS67GbKFPsFksmIVVVKN
 gcTkf6UR9Kz6+bllWZ8KKFyolHHyN5Jp1ukI7s60ZTK22/YABr
 iW7Qpqn3eYT7k/vCgLw1g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 August 2008, Ryusuke Konishi wrote:
> >Do you do wear leveling or scrubbing?
> 
> NILFS does not support scrubbing. (as you guessed)
> Under the current GC daemon, it writes logs sequentially and circularly
> in the partition, and as you know, this leads to the wear levelling
> except for superblock.

I don't see how that would cope with file systems that have a lot
of static data. The classic problem of most cheap devices that implement
wear leveling in hardware is that they never move data in an erase block
that is used for read-only data. If 90% of the file system is read-only,
your wear leveling will only work on 10% of the medium, wearing it down
10 times faster than it should.

Can the GC daemon handle this case, e.g. by moving around aging read-only
erase blocks?

	Arnd <><
