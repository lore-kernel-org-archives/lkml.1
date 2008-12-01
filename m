Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbYLAIu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbYLAIu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 03:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbYLAIuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 03:50:13 -0500
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:56068 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbYLAIuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 03:50:11 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Anton Altaparmakov <aia21@cam.ac.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
In-Reply-To: <1227814545.5511.143.camel@brick>
Subject: Re: [PATCH-mm 1/8] ntfs: remove private wrapper around endian helpers
References: <1227733970.5511.123.camel@brick> <B9FA83C0-9993-44BB-86AA-FA8B97A2D6A2@cam.ac.uk> <1227814545.5511.143.camel@brick>
Message-Id: <72F61C56-4613-4369-9319-09A0A8C90F7C@cam.ac.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Date: Mon, 1 Dec 2008 08:50:08 +0000
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 27 Nov 2008, at 19:35, Harvey Harrison wrote:
> On Thu, 2008-11-27 at 08:22 +0000, Anton Altaparmakov wrote:
>> On 26 Nov 2008, at 21:12, Harvey Harrison wrote:
>>> The base versions handle constant folding just fine.
>>> Done with sed other than the mft.c and inode.c one-liners.
>>
>> Have you checked the compiler output?  And on all architectures?  And
>> on all gcc versions?
>
> Yes I've checked the compiler output for the new byteorder helpers
> for gcc 3.4, 4, 4.2 on x86.
>
> Notice this depends on the byteorder bits in -mm.  The failure of
> the old bits to properly compile-time swap I've only seen at -O0,
> which the new bits do properly.  If you can cite a particular
> version/arch that you know of where the bug arose, please let me
> know.

Ah, I failed to notice this required some new byteorder code!  Sorry.

>> The reason I introduced the constant version are precisely that at
>> least some versions of gcc at least on some architectures do NOT
>> handle the constant folding and actually put in endianness conversion
>> code for the constants instead of converting them at compile time.
>
> Which ones....-O0 builds perhaps?
>
>> Also you are breaking sparse checking with this patch as you remove
>> some of the necessary endianness conversions (e.g. your one liner in
>> mft.c which causes us to apply a binary 'not' operator on a little
>> endian which sparse complains about - in fact that is the reason the
>> endianness conversions are in there in the first place - I added them
>> because sparse was complaining about them).
>
> No, sparse does not complain about it.  Bitwise operations are just
> fine on types such as le16 etc.  Try running sparse again with
> my changes, there are no new warnings.

Interesting.  Sparse must have grown up then.  It used to complain  
(although I always thought it was complaining incorrectly given that  
binary bit operations are endianness agnostic).

>> Andrew, please do not apply this patch.

> I hope you change you mind.

Yes, you have convinced me.  (-:

Andrew, please feel free to apply the patch.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

