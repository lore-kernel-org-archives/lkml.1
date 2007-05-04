Return-Path: <linux-kernel-owner+w=401wt.eu-S1767722AbXEDIPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767722AbXEDIPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 04:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767723AbXEDIPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 04:15:24 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:45428 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767722AbXEDIPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 04:15:21 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <E1HjjyF-00022D-00@calista.eckenfels.net>
References: <E1HjjyF-00022D-00@calista.eckenfels.net>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <0733FB88-3E6E-47B7-A55D-704B5C0DB239@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: Ext3 vs NTFS performance
Date: Fri, 4 May 2007 09:12:31 +0100
To: Bernd Eckenfels <ecki@lina.inka.de>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 May 2007, at 23:40, Bernd Eckenfels wrote:
> In article <20070503211450.GA3869@nifty> you wrote:
>> For this particular case, Ted is probably right and the only place
>> we'll ever see this insane poor man's pre-allocate pattern is from  
>> the
>> Windows CIFS client, in which case fixing this in Samba makes sense -
>> although I'm a bit horrified by the idea of writing 128K of zeroes to
>> pre-allocate... oh well, it's temporary, and what we care about here
>> is the read performance, more than the write performance.
>
> What about an ioctl or advice to avoid holes? Which could be issued by
> samba? Is that related to SetFileValidData and SetEndOfFile win32  
> functions?
> What is the windows client calling, and what command is transmitted  
> by smb?

Nothing to do with win32 functions.  Windows does NOT create sparse  
files therefore it never can have an issue like ext3 does in this  
scenario.  Windows will cause nice allocations to happen because of  
this and the 1-byte writes are perfectly sensible in this regard.   
(Although a little odd as Windows has a proper API for doing  
preallocation so I don't get why it is not using that instead...)

As far as I know the only time Windows will create sparse files is if  
you specifically mark a file as sparse using the FSCTL_SET_SPARSE  
ioctl and then create a sparse region using the FSCTL_SET_ZERO_DATA  
ioctl.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/


