Return-Path: <linux-kernel-owner+w=401wt.eu-S1759481AbYEQU3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbYEQU3h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 16:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758404AbYEQU31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 16:29:27 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:49279 "EHLO
	QMTA03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758319AbYEQU30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 16:29:26 -0400
X-Authority-Analysis: v=1.0 c=1 a=y2SMKWlHeE8A:10 a=n5JjvYRQxMoA:10
 a=0k3DWULWOcjMIg4IU_oA:9 a=AcrQB6pki5UdPHVn-TZ_nFBDYW4A:4 a=KMEqjWUN97gA:10
 a=HVLfEFYxIYkA:10
Message-Id: <200805172026.m4HKQwh06910@www.watkins-home.com>
From: "Guy Watkins" <linux-raid@watkins-home.com>
To: "'David Lethe'" <david@santools.com>,
       "'LinuxRaid'" <linux-raid@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: RE: Mechanism to safely force repair of single md stripe w/o hurting data integrity of file system
Date: Sat, 17 May 2008 16:26:53 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook, Build 11.0.6353
In-Reply-To: <A20315AE59B5C34585629E258D76A97C6B3E91@34093-C3-EVS3.exchange.rackspace.com>
Thread-Index: Aci4MYdPw9tbfNruRViIyv8sCMY+VwAGS7XQAARKeMA=
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of David Lethe
} Sent: Saturday, May 17, 2008 3:10 PM
} To: LinuxRaid; linux-kernel@vger.kernel.org
} Subject: Mechanism to safely force repair of single md stripe w/o hurting
} data integrity of file system
} 
} I'm trying to figure out a mechanism to safely repair a stripe of data
} when I know a particular disk has a unrecoverable read error at a
} certain physical block (for 2.6 kernels)
} 
} My original plan was to figure out the range of blocks in md device that
} utilizes the known bad block and force a raw read on physical device
} that covers the entire chunk and let the md driver do all of the work.
} 
} Well, this didn't pan out. Problems include issues where if bad block
} maps to the parity block in a stripe then md won't necessarily
} read/verify parity, and in cases where you are running RAID1, then load
} balancing might result in the kernel reading the bad block from the good
} disk.
} 
} So the degree of difficulty is much higher than I expected.  I prefer
} not to patch kernels due to maintenance issues as well as desire for the
} technique to work across numerous kernels and  patch revisions, and
} frankly, the odds are I would screw it up.  An application-level program
} that can be invoked as necessary would be ideal.
} 
} As such, anybody up to the challenge of writing the code?  I want it
} enough to paypal somebody $500 who can write it, and will gladly open
} source the solution.
} 
} (And to clarify why, I know physical block x on disk y is bad before the
} O/S reads the block, and just want to rebuild the stripe, not the entire
} md device when this happens. I must not compromise any file system data,
} cached or non-cached that is built on the md device.  I have system with
} >100TB and if I did a rebuild every time I discovered a bad block
} somewhere, then a full parity repair would never complete before another
} physical bad block is discovered.)
} 
} Contact me offline for the financial details, but I would certainly
} appreciate some thread discussion on an appropriate architecture.  At
} least it is my opinion that such capability should eventually be native
} Linux, but as long as there is a program that can be run on demand that
} doesn't require rebuilding or patching kernels then that is all I need.
} 
} David @ santools.com

I thought this would cause md to read all blocks in an array:
echo repair > /sys/block/md0/md/sync_action

And rewrite any blocks that can't be read.

In the old days, md would kick out a disk on a read error.  When you added
it back, md would rewrite everything on that disk, which corrected read
errors.

Guy

