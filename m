Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbXI0WSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbXI0WSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 18:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758664AbXI0WRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 18:17:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39080 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758497AbXI0WRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 18:17:49 -0400
Message-ID: <46FC2BFD.6070200@zytor.com>
Date: Thu, 27 Sep 2007 15:17:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: jkeating@redhat.com, Joerg Pommnitz <pommnitz@yahoo.com>,
       Jordan Crouse <jordan.crouse@amd.com>,
       Chuck Ebbert <cebbert@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: More E820 brokenness
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------050404080908040209060500"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050404080908040209060500
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

As luck would have it, it's not just an obscure Geode system which has a
broken E820 implementation.  Today I received a bug report about a Dell
system (XPS M1330) with broken E820.

Unfortunately, the workaround for the Geode breaks this system, because
x86-64 doesn't fall back to the e801/88 information like the i386 kernel
does.

I wonder if the relevant people could test out this patch to see how it
works on their respective system.  This patch reverts to 2.6.23-rc8
behaviour of simply truncating the map, but still makes e801/88 info
available to the kernel; this hopefully should match 2.6.22 behaviour.

I want to emphasize that this is seriously broken.  Using a partial e820
map could have disastrous results, since the kernel will have partial
memory map information and not know about reserved areas, etc.  Part of
me feels that the right thing to do is what the current git kernel does
-- either fall back to e801, or stop and error.

(Andi: I would particularly appreciate your opinion on this issue.)

	-hpa

--------------050404080908040209060500
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="diff"

ZGlmZiAtLWdpdCBhL2FyY2gvaTM4Ni9ib290L21lbW9yeS5jIGIvYXJjaC9pMzg2L2Jvb3Qv
bWVtb3J5LmMKaW5kZXggYmNjYWExYy4uODQ5MzliNyAxMDA2NDQKLS0tIGEvYXJjaC9pMzg2
L2Jvb3QvbWVtb3J5LmMKKysrIGIvYXJjaC9pMzg2L2Jvb3QvbWVtb3J5LmMKQEAgLTM0LDE3
ICszNCw3IEBAIHN0YXRpYyBpbnQgZGV0ZWN0X21lbW9yeV9lODIwKHZvaWQpCiAJCSAgICAg
ICI9bSIgKCpkZXNjKQogCQkgICAgOiAiRCIgKGRlc2MpLCAiYSIgKDB4ZTgyMCkpOwogCi0J
CS8qIFNvbWUgQklPU2VzIHN0b3AgcmV0dXJuaW5nIFNNQVAgaW4gdGhlIG1pZGRsZSBvZgot
CQkgICB0aGUgc2VhcmNoIGxvb3AuICBXZSBkb24ndCBrbm93IGV4YWN0bHkgaG93IHRoZSBC
SU9TCi0JCSAgIHNjcmV3ZWQgdXAgdGhlIG1hcCBhdCB0aGF0IHBvaW50LCB3ZSBtaWdodCBo
YXZlIGEKLQkJICAgcGFydGlhbCBtYXAsIHRoZSBmdWxsIG1hcCwgb3IgY29tcGxldGUgZ2Fy
YmFnZSwgc28KLQkJICAganVzdCByZXR1cm4gZmFpbHVyZS4gKi8KLQkJaWYgKGlkICE9IFNN
QVApIHsKLQkJCWNvdW50ID0gMDsKLQkJCWJyZWFrOwotCQl9Ci0KLQkJaWYgKGVycikKKwkJ
aWYgKGlkICE9IFNNQVAgfHwgZXJyKQogCQkJYnJlYWs7CiAKIAkJY291bnQrKzsK
--------------050404080908040209060500--
