Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbZCIQgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbZCIQgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 12:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZCIQg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 12:36:26 -0400
Received: from b-mail.com.ua ([195.68.202.242]:61784 "EHLO b-mail.com.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbZCIQg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 12:36:26 -0400
X-Greylist: delayed 932 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Mar 2009 12:36:25 EDT
Message-ID: <49B54210.5040709@lebon.org.ua>
Date: Mon, 09 Mar 2009 18:21:36 +0200
From: Mikhail Zolotaryov <lebon@lebon.org.ua>
User-Agent: Thunderbird 2.0.0.19 (X11/20090209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linuxppc-dev@ozlabs.org, jwboyer@linux.vnet.ibm.com
Subject: [PATCH] powerpc 4xx: DDR0_14[REDUC] decoded incorrectly
Content-Type: multipart/mixed;
 boundary="------------020603000204070401090307"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020603000204070401090307
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

according to the PPC440EPx Embedded Processor User Manual (rev 1.14) 
DDR0_14[REDUC] bit has the following meaning:

REDUC - Enable the half data path feature of the controller
0 = Standard operation using full 64/72-bit memory bus
1 = Memory data path width is 32/40 bits

However, "1" is decoded as 64 bit (8 byte), "0" - as 32 bit (4 byte) bus 
by the kernel code. My understanding is this is not correct - patch 
attached.



--------------020603000204070401090307
Content-Type: text/plain;
 name="patch-ibm4xx_denali_fixup_memsize.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="patch-ibm4xx_denali_fixup_memsize.patch"

LS0tIGxpbnV4Lm9yaWcvYXJjaC9wb3dlcnBjL2Jvb3QvNHh4LmMJMjAwOS0wMy0wOSAxNzo1
NTowMS4wMDAwMDAwMDAgKzAyMDAKKysrIGxpbnV4L2FyY2gvcG93ZXJwYy9ib290LzR4eC5j
CTIwMDktMDMtMDkgMTc6NTg6MDcuMDAwMDAwMDAwICswMjAwCkBAIC0xOTMsOSArMTkzLDkg
QEAKIAl2YWwgPSBTRFJBTTBfUkVBRChERFIwXzE0KTsKIAogCWlmIChERFJfR0VUX1ZBTCh2
YWwsIEREUl9SRURVQywgRERSX1JFRFVDX1NISUZUKSkKLQkJZHBhdGggPSA4OyAvKiA2NCBi
aXRzICovCi0JZWxzZQogCQlkcGF0aCA9IDQ7IC8qIDMyIGJpdHMgKi8KKwllbHNlCisJCWRw
YXRoID0gODsgLyogNjQgYml0cyAqLwogCiAJLyogZ2V0IGFkZHJlc3MgcGlucyAocm93cykg
Ki8KICAJdmFsID0gU0RSQU0wX1JFQUQoRERSMF80Mik7Cg==
--------------020603000204070401090307--
