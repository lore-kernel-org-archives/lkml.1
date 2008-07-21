Return-Path: <linux-kernel-owner+w=401wt.eu-S932465AbYGUFM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbYGUFM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 01:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932269AbYGUFMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 01:12:08 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:10877 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932279AbYGUFMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 01:12:07 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=SjxZnTLchAMI5BWPpuIA:9 a=-QotgZ_b5qaQHWKQUsacikkykbYA:4 a=vdZ6oZ5yp8sA:10 a=Edq-HUaVk0EA:10 a=Q4owxh72988A:10
Message-ID: <48841A92.4020301@sieb.net>
Date: Sun, 20 Jul 2008 22:11:46 -0700
From: Samuel Sieb <samuel@sieb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.15) Gecko/20080706 Fedora/1.1.10-1.fc9 pango-text SeaMonkey/1.1.10
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: kernel won't boot on a Cyrix MediaGXm (Geode )
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a computer here with a CPU that the BIOS identifies as:
Cyrix MediaGXm/Cx5530 Unicorn Revision 1.19.3B

kernel 2.6.14 identifies it as:
vendor_id	: Geode by NSC
cpu family	: 5
model		: 9
model name	: Geode(TM) Integrated Processor by National Semi
stepping	: 1

I can't boot any kernel later than 2.6.22 on it.  Anything later either 
hangs or gives random kernel panics while booting.  I tracked down the 
problem to a specific commit:

commit f25f64ed5bd3c2932493681bdfdb483ea707da0a
Author: Juergen Beisert <juergen@kreuzholzen.de>
Date:   Sun Jul 22 11:12:38 2007 +0200

     x86: Replace NSC/Cyrix specific chipset access macros by inlined 
functions.

Reversing the patch (compensating for kernel changes) let me boot a 
2.6.25 kernel.  I realize the patch is supposed to fix something that 
didn't work right, but I didn't have a problem before and I do now. :-)
