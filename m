Return-Path: <linux-kernel-owner+w=401wt.eu-S1161218AbXBAGLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161218AbXBAGLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 01:11:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161215AbXBAGLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 01:11:08 -0500
Received: from terminus.zytor.com ([192.83.249.54]:39028 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161218AbXBAGLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 01:11:07 -0500
Message-ID: <45C18457.6030504@zytor.com>
Date: Wed, 31 Jan 2007 22:10:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: =?ISO-8859-1?Q?=22S=2E=C3a=C4lar_Onur=22?= <caglar@pardus.org.tr>,
       lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Mark Huang <mlhuang@CS.Princeton.EDU>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Linux 2.6.20-rc7
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org> <200702010416.59469.caglar@pardus.org.tr> <Pine.LNX.4.64.0701311828540.3632@woody.linux-foundation.org> <200702010501.20994.caglar@pardus.org.tr> <Pine.LNX.4.64.0701311921090.3632@woody.linux-foundation.org> <45C17E4C.1030509@zytor.com> <Pine.LNX.4.64.0701312157450.3632@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0701312157450.3632@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 31 Jan 2007, H. Peter Anvin wrote:
>> It would be interesting to know what the inode numbers are in the image; also,
>> what is the exact behaviour -- do you end up with a missing link, or do both
>> entries end up getting hard-linked to an empty file?
> 
> Judging by the
> 
> 	request_module: runaway loop modprobe binfmt-0000
> 
> one or more of the hardlinked binaries (modprobe being one, but not 
> necessarily the one that initially triggers hits) will read all zeroes-
> 
> Or at least bytes at offsets 2 and 3 will read as zero, causing it to not 
> be recognized as a proper binary, causing that "binfmt-0000" thing.
> 

Or perhaps not read at all, which would explain the problem.

cpio represents a hard link as who headers with the same type and the 
same file (inode) number and a link count that is > 1.  Only the first 
one contains data; the subsequent ones have length 0.  It's fairly easy 
for a bug in the decoder to truncate the file upon encountering the 
second header, since this is somewhat of a special case (it would have 
been better if the cpio format distinguished "hard link" explicitly, as 
tar does.)

I will look into this as soon as I can, but as I'm currently in the 
middle of job hunting it might take until the weekend.

	-hpa
