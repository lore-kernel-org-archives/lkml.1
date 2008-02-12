Return-Path: <linux-kernel-owner+w=401wt.eu-S1762527AbYBLTXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762527AbYBLTXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbYBLTXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:23:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40913 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbYBLTXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:23:13 -0500
Message-ID: <47B1F218.3090407@zytor.com>
Date: Tue, 12 Feb 2008 11:23:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Eric Piel <E.A.B.Piel@tudelft.nl>
CC: "Carlos R. Mafra" <crmafra@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.25-rc1] Strange regression with CONFIG_HZ_300=y
References: <47B0509E.1040100@gmail.com> <47B15834.6010704@tudelft.nl>
In-Reply-To: <47B15834.6010704@tudelft.nl>
Content-Type: multipart/mixed;
 boundary="------------080807000300020205030901"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080807000300020205030901
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Eric Piel wrote:
>>
>> The laptop is a Vaio VGN-FZ240E, core 2 duo T7250 @ 2.0 GHz and the 
>> kernel is x86_64.
> 
> Hi, it's great you found out the culprit commit because I was really 
> wondering where this bug was coming from...
> As a data point, my machine has a core 2 duo @ 1.2GHz and x86_64 arch. 
> Do you also have the tickless option activated? (it could play a role)
> 

I believe this patch should fix the problem.  Can you please verify?

Thanks,

	-hpa

--------------080807000300020205030901
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/kernel/timeconst.pl b/kernel/timeconst.pl
index 62b1287..4146803 100644
--- a/kernel/timeconst.pl
+++ b/kernel/timeconst.pl
@@ -339,7 +339,7 @@ sub output($@)
 	print "\n";
 
 	foreach $pfx ('HZ_TO_MSEC','MSEC_TO_HZ',
-		      'USEC_TO_HZ','HZ_TO_USEC') {
+		      'HZ_TO_USEC','USEC_TO_HZ') {
 		foreach $bit (32, 64) {
 			foreach $suf ('MUL', 'ADJ', 'SHR') {
 				printf "#define %-23s %s\n",

--------------080807000300020205030901--
