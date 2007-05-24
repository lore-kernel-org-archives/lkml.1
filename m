Return-Path: <linux-kernel-owner+w=401wt.eu-S1752922AbXEXTN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbXEXTN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 15:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbXEXTNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 15:13:18 -0400
Received: from ppsw-3.csi.cam.ac.uk ([131.111.8.133]:36050 "EHLO
	ppsw-3.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbXEXTNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 15:13:17 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <20070524115055.6be93924.akpm@linux-foundation.org>
References: <1412F214-FA89-4088-B3A2-DEE03C324FB6@cam.ac.uk> <20070524115055.6be93924.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <3D8CC408-75EA-445C-81F9-83EC7703A2AF@cam.ac.uk>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Richard Purdie <richard@openedhand.com>, markus@oberhumer.com
Content-Transfer-Encoding: 7bit
From: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Re: [RFC] [-mm] Remove 'unsafe' LZO decompressor
Date: Thu, 24 May 2007 20:13:14 +0100
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 May 2007, at 19:50, Andrew Morton wrote:

> On Thu, 24 May 2007 18:15:17 +0100
> Michael-Luke Jones <mlj28@cam.ac.uk> wrote:
>
>> Attached is a patch which may be desirable for -mm. It applies
>> directly to 2.6.22-rc2-mm1.
>>
>> The patch removes the 'unsafe' LZO decompression function, lowering
>> the size of the minilzo.c file by nearly 500 out of an original 1727
>> lines. It also removes references to the 'unsafe' decompression
>> function in the public LZO header and the EXPORT_SYMBOL_GPL  
>> declaration.
>>
>> This is intended to provoke some discussion over whether a
>> decompression function able to scribble on arbitrary memory is
>> desirable in the mainline kernel, whatever the performance increases.
>>
>> Over and above the security/stability implications of using this
>> code, it can also be argued to represent an unnecessary duplication
>> of the vast majority of LZO decompression code. This is due to the
>> lack of likely in-kernel uses of the 'unsafe' function.
>>
>> Only a single user for this 'unsafe' code has been suggested, the
>> 'Compressed Caching' project. This code is highly unlikely to move
>> into mainline in the same timeframe as the LZO code. All of the other
>> suggested uses require decompression of untrusted data, such that the
>> 'safe' function should be used.
>>
>> Comments / disagreement all welcome :)
>
> This is obviously a highly desirable thing to do for a number of  
> reasons.
> But have we quantified the performance difference?

The author of LZO may be able to help us out here, so he's CCed as of  
this mail.

Michael-Luke

