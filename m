Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbYC2AIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbYC2AIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 20:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbYC2AIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 20:08:09 -0400
Received: from lax-green-bigip-5.dreamhost.com ([208.113.200.5]:35187 "EHLO
	spaceymail-a1.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753063AbYC2AII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 20:08:08 -0400
Message-ID: <47ED8858.9000401@froyn.name>
Date: Sat, 29 Mar 2008 01:07:52 +0100
From: Ketil Froyn <ketil@froyn.name>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: unexpected rename() behaviour
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following behaviour was unexpected (tested on Debian/ext3):

$ echo 1 > 1
$ ln 1 2
$ cat 2
1
$ ./rename 2 1
$ echo $?
0
$ cat 2
1

The code for ./rename is simple:

---
/* compile: gcc -o rename rename.c */
#include <stdio.h>
int main(int argc, char *argv[]) { return rename(argv[1], argv[2]); }
---

I thought this must be wrong behaviour, but I have been unable to 
confirm what the correct result should be in this special case. rename() 
returns success, but the source file is intact, which seems odd. The 
"mv" command specifically checks for cases like this and calls 
unlink("2") instead of rename("2", "1"). Are all applications meant to 
do this? What standards describe what rename() should do in cases like this?

Regards,
Ketil Froyn
