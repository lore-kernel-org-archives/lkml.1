Return-Path: <linux-kernel-owner+w=401wt.eu-S1760820AbXI0Xgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760820AbXI0Xgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 19:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759519AbXI0Xgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 19:36:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48683 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759532AbXI0Xgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 19:36:37 -0400
Message-ID: <46FC3E7C.7060600@zytor.com>
Date: Thu, 27 Sep 2007 16:36:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jordan Crouse <jordan.crouse@amd.com>
CC: jkeating@redhat.com, Joerg Pommnitz <pommnitz@yahoo.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: More E820 brokenness
References: <46FC2BFD.6070200@zytor.com> <20070927223336.GB4755@cosmic.amd.com> <46FC32FE.9070302@zytor.com> <20070927231552.GC4755@cosmic.amd.com> <46FC3C5A.2010902@zytor.com> <20070927233408.GD4755@cosmic.amd.com>
In-Reply-To: <20070927233408.GD4755@cosmic.amd.com>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------030001050308070701080203"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030001050308070701080203
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jordan Crouse wrote:
>>>
>> Oh bugger, looks like this one might be genuinely my fault after all.
>> The ID check in the new code is buggy.
>>
>> Can you please test this revised patch out (against current -git)?
> 
> 
> That looks the same as the previous patch you sent?
> 

Sorry, this is the right one...

	-hpa

--------------030001050308070701080203
Content-Type: text/x-patch;
 name="smap.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="smap.patch"

diff --git a/arch/i386/boot/memory.c b/arch/i386/boot/memory.c
index bccaa1c..2f37568 100644
--- a/arch/i386/boot/memory.c
+++ b/arch/i386/boot/memory.c
@@ -28,11 +28,10 @@ static int detect_memory_e820(void)
 
 	do {
 		size = sizeof(struct e820entry);
-		id = SMAP;
 		asm("int $0x15; setc %0"
-		    : "=am" (err), "+b" (next), "+d" (id), "+c" (size),
+		    : "=dm" (err), "+b" (next), "=a" (id), "+c" (size),
 		      "=m" (*desc)
-		    : "D" (desc), "a" (0xe820));
+		    : "D" (desc), "d" (SMAP), "a" (0xe820));
 
 		/* Some BIOSes stop returning SMAP in the middle of
 		   the search loop.  We don't know exactly how the BIOS

--------------030001050308070701080203--
