Return-Path: <linux-kernel-owner+w=401wt.eu-S1161133AbXBAGqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161133AbXBAGqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 01:46:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933385AbXBAGqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 01:46:11 -0500
Received: from relay4.usu.ru ([194.226.235.39]:54486 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933383AbXBAGqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 01:46:10 -0500
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Feb 2007 01:46:09 EST
Message-ID: <45C18ADA.4070602@ums.usu.ru>
Date: Thu, 01 Feb 2007 11:38:18 +0500
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "=?ISO-8859-1?Q?=22S=2E?= =?ISO-8859-1?Q?=C3a=C4lar_Onur=22?=" 
	<caglar@pardus.org.tr>,
       lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Mark Huang <mlhuang@CS.Princeton.EDU>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Linux 2.6.20-rc7
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org> <200702010416.59469.caglar@pardus.org.tr> <Pine.LNX.4.64.0701311828540.3632@woody.linux-foundation.org> <200702010501.20994.caglar@pardus.org.tr> <Pine.LNX.4.64.0701311921090.3632@woody.linux-foundation.org> <45C17E4C.1030509@zytor.com> <Pine.LNX.4.64.0701312157450.3632@woody.linux-foundation.org> <45C18457.6030504@zytor.com>
In-Reply-To: <45C18457.6030504@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Linus Torvalds wrote:
>>
>> On Wed, 31 Jan 2007, H. Peter Anvin wrote:
>>> It would be interesting to know what the inode numbers are in the 
>>> image; also,
>>> what is the exact behaviour -- do you end up with a missing link, or 
>>> do both
>>> entries end up getting hard-linked to an empty file?
>>
>> Judging by the
>>
>>     request_module: runaway loop modprobe binfmt-0000
>>
>> one or more of the hardlinked binaries (modprobe being one, but not 
>> necessarily the one that initially triggers hits) will read all zeroes-
>>
>> Or at least bytes at offsets 2 and 3 will read as zero, causing it to 
>> not be recognized as a proper binary, causing that "binfmt-0000" thing.
>>
> 
> Or perhaps not read at all, which would explain the problem.
> 
> cpio represents a hard link as who headers with the same type and the 
> same file (inode) number and a link count that is > 1.  Only the first 
> one contains data; the subsequent ones have length 0.  It's fairly easy 
> for a bug in the decoder to truncate the file upon encountering the 
> second header, since this is somewhat of a special case (it would have 
> been better if the cpio format distinguished "hard link" explicitly, as 
> tar does.)
> 
> I will look into this as soon as I can, but as I'm currently in the 
> middle of job hunting it might take until the weekend.

What's the proper way to make sure that the fix, when it appears, ends up in 
my inbox?

-- 
Alexander E. Patrakov
