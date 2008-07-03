Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbYGCMI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbYGCMI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbYGCMIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:08:48 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:64061 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194AbYGCMIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:08:47 -0400
Subject: x86_64: tss_struct layout does not match comments  !?
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 11:47:29 +0100
Message-Id: <1215082049.3026.15.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

the comments in the definition of tss_struct suggests is should be
cacheline aligned ( or 256 byte aligned ? ) :- 

|struct tss_struct {
|....
|	/*
|	 * Pad the TSS to be cacheline-aligned (size is 0x100):
|	 */
|	unsigned long		__cacheline_filler[35];
|	/*
|	 * .. and then another 0x100 bytes for the emergency kernel stack:
|	 */
|	unsigned long		stack[64];
|
|} __attribute__((packed));

However on a 64 bit build the size of tss_struct is 9136,
cacheline_filler is 280 and stack size is 512 at offset 8624.
None of which are cacheline aligned.

I'm guessing this isn't what was intended.

do you know what the original intention was ?

1. struct tss_struct{...} __cacheline_aligned;
or just
2. struct tss_struct {
...
long stack[64] __cacheline_aligned;
}

Richard


