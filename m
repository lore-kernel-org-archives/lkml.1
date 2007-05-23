Return-Path: <linux-kernel-owner+w=401wt.eu-S965698AbXEWN6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965698AbXEWN6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 09:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758072AbXEWN6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 09:58:06 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:55132 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360AbXEWN6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 09:58:05 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <4cefeab80705230439n6bbb1259le3c3b9704ce49b75@mail.gmail.com>
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com> <0F6CEFD7-86F2-4903-B4F7-F723DF88BE9A@cam.ac.uk> <4cefeab80705230439n6bbb1259le3c3b9704ce49b75@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <624FD7A7-5552-415F-96D8-4353453EA2A3@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, "Richard Purdie" <richard@openedhand.com>,
       linux-mm-cc@laptop.org
Content-Transfer-Encoding: 7bit
From: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Re: [RFC] LZO de/compression support - take 3
Date: Wed, 23 May 2007 14:57:39 +0100
To: "Nitin Gupta" <nitingupta910@gmail.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 May 2007, at 12:39, Nitin Gupta wrote:

> Hi Michael,
>
> On 5/23/07, Michael-Luke Jones <mlj28@cam.ac.uk> wrote:
>> I understand that the 'safe' decompression code is 'somewhat slower'
>> and that decompressor performance is a key feature of this algorithm.
>> However, I am concerned about the safety implications of including
>> the 'unsafe' standard version in-kernel when likely uses include
>> compression of network data, memory objects and so-on, all of which
>> could in theory be maliciously modified.
>>
>
> The 'unsafe' version is still included since in some scenarios we have
> guarantee that compressed data has not been modified (for e.g. where
> we keep compressed data in memory only). So, in those cases there is
> no need to go for slower 'safe' version. So, the version of
> decompressor selected should be left to the user (kernel dev) only -
> he should make sure that he is using the right version.

Fair enough. However, this rather important issue is pretty much  
undocumented (source code comments don't count) and Reiser4 is  
already using the lzo1x_decompress() function rather than the  
seemingly more appropriate lzo1x_decompress_safe() function...

http://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22- 
rc2/2.6.22-rc2-mm1/broken-out/reiser4-use-lzo-library-functions.patch

Perhaps a rename is in order:
lzo1x_decompress() => lzo1x_decompress_unsafe()
lzo1x_decompress_safe => lzo1x_decompress()

M-L


