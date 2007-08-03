Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbXHCMBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbXHCMBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 08:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbXHCMB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 08:01:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:46972 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751151AbXHCMB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 08:01:27 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX19RyUZyuE9R6dYoiU3hjavjUw0ATXNdTbAkFlB9Sl
	m7vKkVuFWEUzYH
Message-ID: <46B318B9.7020107@gmx.net>
Date: Fri, 03 Aug 2007 13:59:53 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
CC: dgc@sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: fallocate() man page - darft 2
References: <20070713123816.GA18000@amitarora.in.ibm.com> <20070713124601.GA22961@amitarora.in.ibm.com> <20070714082342.174830@gmx.net> <20070716053235.GA10945@amitarora.in.ibm.com> <46A44629.3090107@gmx.net> <20070723131039.GA29198@amitarora.in.ibm.com> <46AE3F8A.6040404@gmx.net> <20070802173653.GA13816@amitarora.in.ibm.com>
In-Reply-To: <20070802173653.GA13816@amitarora.in.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

>> Could you please review the changes, and the FIXMEs.
> 
> Please find my comments below..

Thanks.

[...]

>> .SH DESCRIPTION
>> .BR fallocate ()
>> allows the caller to directly manipulate the allocated disk space
>> for the file referred to by
>> .I fd
>> for the byte range starting at
>> .I offset
>> and continuing for
>> .I len
>> bytes.
>> .\" FIXME Amit: in other words the affected byte range
>> .\" is the bytes from (offset) to (offset + len - 1), right?
> 
> <Amit>
> Yes, you are right.
> </Amit> 

[...]

>> Preallocating blocks does not change
>> the file size (as reported by
>> .BR stat (2))
>> even if it is less than
>> .\" FIXME Amit: "offset + len" is written here.  But should it be
>> .\" "offset + len - 1" ?
> 
> <Amit>
> Good point. This text was directly taken from the man page of
> posix_fallocate and is also there on the posix specifications at:
> http://www.opengroup.org/onlinepubs/009695399/functions/posix_fallocate.html
> 
> The current posix_fallocate() implementation and also the fallocate()
> implementation in ext4 are based on above documentation, wherein EOF is
> compared with "offset + len" and not with "offset + len - 1".
> 
> I am not sure if this is right or wrong. But, this is as per posix
> specifications. ;)
> </Amit>

Ahhh -- the off by one error was inside my head!  Obviously if we allocate
bytes for offset 1000, len 100, then the affected byte range would run to
offset 1099, giving a file size of 1100 bytes -- that is (offset + len) --
not (offset + len - 1), which is of course the offset of the last byte.
Sorry for the confusion.

[...]

>> .B ENOSYS
>> The file system containing the file system referred to by
> 
> <Amit>
> There is a typo above. We have "file system" repeated twice in above
> sentence. Second one should be "file".
> </Amit>

Thanks for catching that.

Okay -- it seems that this page is pretty much ready for publication,
right?  I'll hold off for a bit, until nearer the end of the 2.6.23 cycle.

Cheers,

Michael

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.
