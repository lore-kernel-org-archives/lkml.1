Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbXDQCRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbXDQCRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 22:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbXDQCRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 22:17:45 -0400
Received: from fgwmail9.fujitsu.co.jp ([192.51.44.39]:47577 "EHLO
	fgwmail9.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbXDQCRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 22:17:44 -0400
Message-ID: <46242DD2.7030207@soft.fujitsu.com>
Date: Tue, 17 Apr 2007 11:15:46 +0900
From: izumi <izumi2005@soft.fujitsu.com>
User-Agent: Thunderbird 1.5.0.8 (Windows/20061025)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH][BUG] Fix possible NULL pointer access in 8250 serial driver
Content-Type: multipart/mixed;
 boundary="------------060705020807050903070109"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060705020807050903070109
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

I encountered the following kernel panic. The cause of this problem was
NULL pointer access in check_modem_status() in 8250.c. I confirmed
this problem is fixed by the attached patch, but I don't know this
is the correct fix.

sadc[4378]: NaT consumption 2216203124768 [1]
Modules linked in: binfmt_misc dm_mirror dm_mod thermal processor fan
container button sg e100 eepro100 mii ehci_hcd ohci_hcd

Pid: 4378, CPU 0, comm: sadc
psr : 00001210085a2010 ifs : 8000000000000289 ip : [<a000000100482071>]
Not tainted
ip is at check_modem_status+0xf1/0x360
unat: 0000000000000000 pfs : 0000000000000289 rsc : 0000000000000003
rnat: 800000000000cc18 bsps: 0000000000000000 pr : 0000000000aa6a99
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70033f
csd : 0000000000000000 ssd : 0000000000000000
b0 : a000000100481fb0 b6 : a0000001004822e0 b7 : a000000100477f20
f6 : 1003e2222222222222222 f7 : 0ffdba200000000000000
f8 : 100018000000000000000 f9 : 10002a000000000000000
f10 : 0fffdccccccccc8c00000 f11 : 1003e0000000000000000
r1 : a000000100b9af40 r2 : 0000000000000008 r3 : a000000100ad4e21
r8 : 00000000000000bb r9 : 0000000000000001 r10 : 0000000000000000
r11 : a000000100ad4d58 r12 : e0000000037b7df0 r13 : e0000000037b0000
r14 : 0000000000000001 r15 : 0000000000000018 r16 : a000000100ad4d6c
r17 : 0000000000000000 r18 : 0000000000000000 r19 : 0000000000000000
r20 : a00000010099bc88 r21 : 00000000000000bb r22 : 00000000000000bb
r23 : c003fffffc0ff3fe r24 : c003fffffc000000 r25 : 00000000000ff3fe
r26 : a0000001009b7ad0 r27 : 0000000000000001 r28 : a0000001009b7ad8
r29 : 0000000000000000 r30 : a0000001009b7ad0 r31 : a0000001009b7ad0

Call Trace:
[<a000000100013940>] show_stack+0x40/0xa0
sp=e0000000037b7810 bsp=e0000000037b1118
[<a0000001000145a0>] show_regs+0x840/0x880
sp=e0000000037b79e0 bsp=e0000000037b10c0
[<a0000001000368e0>] die+0x1c0/0x2c0
sp=e0000000037b79e0 bsp=e0000000037b1078
[<a000000100036a30>] die_if_kernel+0x50/0x80
sp=e0000000037b7a00 bsp=e0000000037b1048
[<a000000100037c40>] ia64_fault+0x11e0/0x1300
sp=e0000000037b7a00 bsp=e0000000037b0fe8
[<a00000010000bdc0>] ia64_leave_kernel+0x0/0x280
sp=e0000000037b7c20 bsp=e0000000037b0fe8
[<a000000100482070>] check_modem_status+0xf0/0x360
sp=e0000000037b7df0 bsp=e0000000037b0fa0
[<a000000100482300>] serial8250_get_mctrl+0x20/0xa0
sp=e0000000037b7df0 bsp=e0000000037b0f80
[<a000000100478170>] uart_read_proc+0x250/0x860
sp=e0000000037b7df0 bsp=e0000000037b0ee0
[<a0000001001c16d0>] proc_file_read+0x1d0/0x4c0
sp=e0000000037b7e10 bsp=e0000000037b0e80
[<a0000001001394b0>] vfs_read+0x1b0/0x300
sp=e0000000037b7e20 bsp=e0000000037b0e30
[<a000000100139cd0>] sys_read+0x70/0xe0
sp=e0000000037b7e20 bsp=e0000000037b0db0
[<a00000010000bc20>] ia64_ret_from_syscall+0x0/0x20
sp=e0000000037b7e30 bsp=e0000000037b0db0
[<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
sp=e0000000037b8000 bsp=e0000000037b0db0

Thanks,
Taku Izumi

--------------060705020807050903070109
Content-Type: text/plain;
 name="serial8250.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="serial8250.patch"

Rml4IHRoZSBwb3NzaWJsZSBOVUxMIHBvaW50ZXIgYWNjZXNzIGluIGNoZWNrX21vZGVtX3N0
YXR1cygpIGluDQo4MjUwLmMuIFRoZSBjaGVja19tb2RlbV9zdGF0dXMoKSB3b3VsZCBhY2Nl
c3MgJ2luZm8nIG1lbWJlciBvZg0KdWFydF9wb3J0IHN0cnVjdHVyZSwgYnV0IGl0IGlzIG5v
dCBpbml0aWFsaXplZCBiZWZvcmUgdWFydF9vcGVuKCkgaXMNCmNhbGxlZC4gVGhlIGNoZWNr
X21vZGVtX3N0YXR1cygpIGNhbiBiZSBjYWxsZWQgdGhyb3VnaA0KL3Byb2MvdHR5L2RyaXZl
ci9zZXJpYWwgYmVmb3JlIHVhcnRfb3BlbigpIGlzIGNhbGxlZC4NCg0KU2lnbmVkLW9mZi1i
eTogS2VuamkgS2FuZXNoaWdlIDxrYW5lc2hpZ2Uua2VuamlAanAuZnVqaXRzdS5jb20+DQpT
aWduZWQtb2ZmLWJ5OiBUYWt1IEl6dW1pIDxpenVtaTIwMDVAc29mdC5mdWppdHN1LmNvbT4N
Ci0tLQ0KIGRyaXZlcnMvc2VyaWFsLzgyNTAuYyB8ICAgIDMgKystDQogMSBmaWxlcyBjaGFu
Z2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0KSW5kZXg6IGxpbnV4LTIu
Ni4yMS1yYzUvZHJpdmVycy9zZXJpYWwvODI1MC5jDQo9PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQotLS0gbGlu
dXgtMi42LjIxLXJjNS5vcmlnL2RyaXZlcnMvc2VyaWFsLzgyNTAuYwkyMDA3LTAzLTI2IDA5
OjE0OjM3LjAwMDAwMDAwMCArMDkwMA0KKysrIGxpbnV4LTIuNi4yMS1yYzUvZHJpdmVycy9z
ZXJpYWwvODI1MC5jCTIwMDctMDQtMTMgMTI6MDY6NTIuMDAwMDAwMDAwICswOTAwDQpAQCAt
MTMxMCw3ICsxMzEwLDggQEANCiB7DQogCXVuc2lnbmVkIGludCBzdGF0dXMgPSBzZXJpYWxf
aW4odXAsIFVBUlRfTVNSKTsNCiANCi0JaWYgKHN0YXR1cyAmIFVBUlRfTVNSX0FOWV9ERUxU
QSAmJiB1cC0+aWVyICYgVUFSVF9JRVJfTVNJKSB7DQorCWlmIChzdGF0dXMgJiBVQVJUX01T
Ul9BTllfREVMVEEgJiYgdXAtPmllciAmIFVBUlRfSUVSX01TSSAmJg0KKwkgICAgdXAtPnBv
cnQuaW5mbyAhPSBOVUxMKSB7DQogCQlpZiAoc3RhdHVzICYgVUFSVF9NU1JfVEVSSSkNCiAJ
CQl1cC0+cG9ydC5pY291bnQucm5nKys7DQogCQlpZiAoc3RhdHVzICYgVUFSVF9NU1JfRERT
UikNCg==
--------------060705020807050903070109--

