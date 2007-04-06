Return-Path: <linux-kernel-owner+w=401wt.eu-S933217AbXDFWoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217AbXDFWoa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 18:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933274AbXDFWo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 18:44:29 -0400
Received: from nn7.de ([85.214.94.156]:41388 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933217AbXDFWo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 18:44:28 -0400
Subject: Re: Linux 2.6.21-rc6 - regressions update
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
Content-Type: multipart/mixed; boundary="=-U99tMVoMsAcYm2a+/Y/8"
Date: Sat, 07 Apr 2007 00:44:20 +0200
Message-Id: <1175899460.5393.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-U99tMVoMsAcYm2a+/Y/8
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2007-04-05 at 19:50 -0700, Linus Torvalds wrote:
> Ok,
>  I don't think there really is anything very interesting here, but we're 
> hopefully whittling down the list of regressions, and fixing various 
> random other small issues while at it.
> 
> Some smallish MIPS updates, networking (and network driver) fixes, removal 
> of a long obsolete framebuffer driver, etc etc. The shortlog really tells 
> the story.
> 
> We should be getting close to a 2.6.21 release, so please update any 
> regression reports you've done,

regression update for 21-rc6:

1) all s2ram and NO_HZ related things seem to be resolved on my macbook
pro, also 
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y

don't break resume anymore.

2) However I am still having problems with
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_HPET=y
+CONFIG_HPET_MMAP=y
although the machine resumes, I've managed to get the attached oops.

3) Subject    : SATA breakage on resume
References : http://lkml.org/lkml/2007/3/7/233
Submitter  : Thomas Gleixner <tglx@linutronix.de>
             Soeren Sonnenburg <kernel@nn7.de>
Status     : unknown

I am still seeing these messages after a suspend/resume cycle (though
all devices work even after multiple suspend/resume cycles)

ATA: abnormal status 0x80 on port 0x000140df
ata3.01: revalidation failed (errno=-2)
ata3: failed to recover some devices, retrying in 5 secs
ata1.00: configured for UDMA/33
ATA: abnormal status 0x7F on port 0x000140df
ATA: abnormal status 0x7F on port 0x000140df
ata3.01: configured for UDMA/133

So that's been a big step forward...
Soeren
-- 
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962

--=-U99tMVoMsAcYm2a+/Y/8
Content-Disposition: attachment; filename=oops
Content-Type: text/plain; name=oops; charset=ISO-8859-15
Content-Transfer-Encoding: base64

Q1BVMSBpcyBkb3duDQpJbnRlbCBtYWNoaW5lIGNoZWNrIGFyY2hpdGVjdHVyZSBzdXBwb3J0ZWQu
DQpJbnRlbCBtYWNoaW5lIGNoZWNrIHJlcG9ydGluZyBlbmFibGVkIG9uIENQVSMwLg0KQmFjayB0
byBDIQ0KaXJxIDk6IG5vYm9keSBjYXJlZCAodHJ5IGJvb3Rpbmcgd2l0aCB0aGUgImlycXBvbGwi
IG9wdGlvbikNCiBbPGMwMTU0NDQ0Pl0gX19yZXBvcnRfYmFkX2lycSsweDI0LzB4OTANCiBbPGMw
MTU0NmRmPl0gbm90ZV9pbnRlcnJ1cHQrMHgyMmYvMHgyNjANCiBbPGMwMjY5NTJkPl0gYWNwaV9p
cnErMHhiLzB4MTQNCiBbPGMwMTUzOTA1Pl0gaGFuZGxlX0lSUV9ldmVudCsweDI1LzB4NjANCiBb
PGMwMTU1MzAwPl0gaGFuZGxlX2xldmVsX2lycSsweGUwLzB4MTEwDQogWzxjMDEwNmU4Yj5dIGRv
X0lSUSsweDNiLzB4ODANCiBbPGMwMTE5NjM3Pl0gc21wX2FwaWNfdGltZXJfaW50ZXJydXB0KzB4
NTcvMHg5MA0KIFs8YzAxMDRjNzM+XSBjb21tb25faW50ZXJydXB0KzB4MjMvMHgyOA0KIFs8YzAx
NDAwZDg+XSBfX2tmaWZvX3B1dCsweDc4LzB4OTANCiBbPGMwMTMwZDZkPl0gX19kb19zb2Z0aXJx
KzB4NmQvMHhmMA0KIFs8YzAxMzBlMjc+XSBkb19zb2Z0aXJxKzB4MzcvMHg0MA0KIFs8YzAxMzEw
OGE+XSBpcnFfZXhpdCsweDdhLzB4OTANCiBbPGMwMTE5NjM3Pl0gc21wX2FwaWNfdGltZXJfaW50
ZXJydXB0KzB4NTcvMHg5MA0KIFs8YzAxNDJkMzA+XSByZXRyaWdnZXJfbmV4dF9ldmVudCsweDAv
MHhiMA0KIFs8YzAxMDRkMzA+XSBhcGljX3RpbWVyX2ludGVycnVwdCsweDI4LzB4MzANCiBbPGMw
MTQyZDMwPl0gcmV0cmlnZ2VyX25leHRfZXZlbnQrMHgwLzB4YjANCiBbPGMwMTQwMDY4Pl0gX19r
Zmlmb19wdXQrMHg4LzB4OTANCiBbPGMwMTMwZmU1Pl0gb25fZWFjaF9jcHUrMHgzNS8weDYwDQog
WzxjMDE0MzUzOD5dIGNsb2NrX3dhc19zZXQrMHgxOC8weDIwDQogWzxjMDEzNWNkYz5dIHRpbWVr
ZWVwaW5nX3Jlc3VtZSsweDdjLzB4YTANCiBbPGMwMmFhYmUxPl0gX19zeXNkZXZfcmVzdW1lKzB4
MTEvMHg4MA0KIFs8YzAyYWIwYzc+XSBzeXNkZXZfcmVzdW1lKzB4NDcvMHg4MA0KIFs8YzAyYjBi
MDU+XSBkZXZpY2VfcG93ZXJfdXArMHg1LzB4MTANCiBbPGMwMTRmMTM2Pl0gc3VzcGVuZF9lbnRl
cisweDU2LzB4NjANCiBbPGMwMTRmMjVhPl0gZW50ZXJfc3RhdGUrMHgxMWEvMHgxYzANCiBbPGMw
MTRmM2JkPl0gc3RhdGVfc3RvcmUrMHhiZC8weGQwDQogWzxjMDE0ZjMwMD5dIHN0YXRlX3N0b3Jl
KzB4MC8weGQwDQogWzxjMDFiNTJjOT5dIHN1YnN5c19hdHRyX3N0b3JlKzB4MjkvMHg0MA0KIFs8
YzAxYjU0MzI+XSBzeXNmc193cml0ZV9maWxlKzB4YjIvMHgxMTANCiBbPGMwMTc1YTY2Pl0gdmZz
X3dyaXRlKzB4YTYvMHgxNDANCiBbPGMwMWI1MzgwPl0gc3lzZnNfd3JpdGVfZmlsZSsweDAvMHgx
MTANCiBbPGMwMTc2MTMxPl0gc3lzX3dyaXRlKzB4NDEvMHg3MA0KIFs8YzAxMDQyNjI+XSBzeXNl
bnRlcl9wYXN0X2VzcCsweDVmLzB4ODUNCiA9PT09PT09PT09PT09PT09PT09PT09PQ0KaGFuZGxl
cnM6DQpbPGMwMjY5NTIyPl0gKGFjcGlfaXJxKzB4MC8weDE0KQ0KRGlzYWJsaW5nIElSUSAjOQ0K
RW5hYmxpbmcgbm9uLWJvb3QgQ1BVcyAuLi4NClNNUCBhbHRlcm5hdGl2ZXM6IHN3aXRjaGluZyB0
byBTTVAgY29kZQ0K


--=-U99tMVoMsAcYm2a+/Y/8--
