Return-Path: <linux-kernel-owner+w=401wt.eu-S1752203AbZEKFXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbZEKFXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 01:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbZEKFWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 01:22:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59654 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbZEKFWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 01:22:52 -0400
Message-ID: <4A07B534.8080606@zytor.com>
Date: Sun, 10 May 2009 22:18:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "vgoyal@redhat.com" <vgoyal@redhat.com>,
       "hbabu@us.ibm.com" <hbabu@us.ibm.com>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "Huang, Ying" <ying.huang@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "sam@ravnborg.org" <sam@ravnborg.org>
Subject: RFC: x86: relocatable kernel changes (revised spec)
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>	<m14ovwz8ua.fsf@fess.ebiederm.org> <4A03C3BB.3070401@intel.com> <m1tz3wgk3n.fsf@fess.ebiederm.org> <4A047E53.8040003@intel.com>
In-Reply-To: <4A047E53.8040003@intel.com>
Content-Type: multipart/mixed;
 boundary="------------040403060004040002050909"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040403060004040002050909
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Revised proposal to address Eric's comments.  This is intended to
provide full backwards compatibility while at the same time giving us
the future flexibility.

The intent will be to set by default:

	kernel_alignment	= 16 MB
	min_alignment		= log2(4K) or log2(2M)
	pref_address		= 16 MB

The reason to represent min_alignment as a logarithm is that I'm getting
very concerned about the diminishing space that is left without a
fundamental change to the initialized part of the header; specifically,
right now we rely on the signed byte at offset 0x201 to contain the
(additional) size of the header, which means end at 0x281 without a
major format change of some sort.

Comments appreciated.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


--------------040403060004040002050909
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="diff"

ZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24veDg2L2Jvb3QudHh0IGIvRG9jdW1lbnRhdGlv
bi94ODYvYm9vdC50eHQKaW5kZXggZTAyMDM2Ni4uY2NjMWJkNCAxMDA2NDQKLS0tIGEvRG9j
dW1lbnRhdGlvbi94ODYvYm9vdC50eHQKKysrIGIvRG9jdW1lbnRhdGlvbi94ODYvYm9vdC50
eHQKQEAgLTUwLDYgKzUwLDExIEBAIFByb3RvY29sIDIuMDg6CShLZXJuZWwgMi42LjI2KSBB
ZGRlZCBjcmMzMiBjaGVja3N1bSBhbmQgRUxGIGZvcm1hdAogUHJvdG9jb2wgMi4wOToJKEtl
cm5lbCAyLjYuMjYpIEFkZGVkIGEgZmllbGQgb2YgNjQtYml0IHBoeXNpY2FsCiAJCXBvaW50
ZXIgdG8gc2luZ2xlIGxpbmtlZCBsaXN0IG9mIHN0cnVjdAlzZXR1cF9kYXRhLgogCitQcm90
b2NvbCAyLjEwOgkoS2VybmVsIDIuNi4zMT8pIEEgcHJvdG9jb2wgZm9yIHJlbGF4ZWQgYWxp
Z25tZW50CisJIAliZXlvbmQgdGhlIGtlcm5lbF9hbGlnbm1lbnQgYWRkZWQsIG5ldyBpbml0
X3NpemUgYW5kCisJIAlwcmVmX2FkZHJlc3MgZmllbGRzLgorCSAJCisKICoqKiogTUVNT1JZ
IExBWU9VVAogCiBUaGUgdHJhZGl0aW9uYWwgbWVtb3J5IG1hcCBmb3IgdGhlIGtlcm5lbCBs
b2FkZXIsIHVzZWQgZm9yIEltYWdlIG9yCkBAIC0xNzMsNyArMTc4LDcgQEAgT2Zmc2V0CVBy
b3RvCU5hbWUJCU1lYW5pbmcKIDAyMkMvNAkyLjAzKwlyYW1kaXNrX21heAlIaWdoZXN0IGxl
Z2FsIGluaXRyZCBhZGRyZXNzCiAwMjMwLzQJMi4wNSsJa2VybmVsX2FsaWdubWVudCBQaHlz
aWNhbCBhZGRyIGFsaWdubWVudCByZXF1aXJlZCBmb3Iga2VybmVsCiAwMjM0LzEJMi4wNSsJ
cmVsb2NhdGFibGVfa2VybmVsIFdoZXRoZXIga2VybmVsIGlzIHJlbG9jYXRhYmxlIG9yIG5v
dAotMDIzNS8xCU4vQQlwYWQyCQlVbnVzZWQKKzAyMzUvMQkyLjEwKwltaW5fYWxpZ25tZW50
CU1pbmltdW0gYWxpZ25tZW50LCBhcyBhIHBvd2VyIG9mIDIKIDAyMzYvMglOL0EJcGFkMwkJ
VW51c2VkCiAwMjM4LzQJMi4wNisJY21kbGluZV9zaXplCU1heGltdW0gc2l6ZSBvZiB0aGUg
a2VybmVsIGNvbW1hbmQgbGluZQogMDIzQy80CTIuMDcrCWhhcmR3YXJlX3N1YmFyY2ggSGFy
ZHdhcmUgc3ViYXJjaGl0ZWN0dXJlCkBAIC0xODIsNiArMTg3LDggQEAgT2Zmc2V0CVByb3Rv
CU5hbWUJCU1lYW5pbmcKIDAyNEMvNAkyLjA4KwlwYXlsb2FkX2xlbmd0aAlMZW5ndGggb2Yg
a2VybmVsIHBheWxvYWQKIDAyNTAvOAkyLjA5KwlzZXR1cF9kYXRhCTY0LWJpdCBwaHlzaWNh
bCBwb2ludGVyIHRvIGxpbmtlZCBsaXN0CiAJCQkJb2Ygc3RydWN0IHNldHVwX2RhdGEKKzAy
NTgvOAkyLjEwKwlwcmVmX2FkZHJlc3MJUHJlZmVycmVkIGxvYWRpbmcgYWRkcmVzcworMDI2
MC80CTIuMTArCWluaXRfc2l6ZQlMaW5lYXIgbWVtb3J5IHJlcXVpcmVkIGR1cmluZyBpbml0
aWFsaXphdGlvbgogCiAoMSkgRm9yIGJhY2t3YXJkcyBjb21wYXRpYmlsaXR5LCBpZiB0aGUg
c2V0dXBfc2VjdHMgZmllbGQgY29udGFpbnMgMCwgdGhlCiAgICAgcmVhbCB2YWx1ZSBpcyA0
LgpAQCAtNDgyLDExICs0ODksMTUgQEAgUHJvdG9jb2w6CTIuMDMrCiAgIDB4MzdGRkZGRkYs
IHlvdSBjYW4gc3RhcnQgeW91ciByYW1kaXNrIGF0IDB4MzdGRTAwMDAuKQogCiBGaWVsZCBu
YW1lOglrZXJuZWxfYWxpZ25tZW50Ci1UeXBlOgkJcmVhZCAocmVsb2MpCitUeXBlOgkJcmVh
ZC9tb2RpZnkgKHJlbG9jKQogT2Zmc2V0L3NpemU6CTB4MjMwLzQKLVByb3RvY29sOgkyLjA1
KworUHJvdG9jb2w6CTIuMDUrIChyZWFkKSwgMi4xMCsgKG1vZGlmeSkKIAotICBBbGlnbm1l
bnQgdW5pdCByZXF1aXJlZCBieSB0aGUga2VybmVsIChpZiByZWxvY2F0YWJsZV9rZXJuZWwg
aXMgdHJ1ZS4pCisgIEFsaWdubWVudCB1bml0IHJlcXVpcmVkIGJ5IHRoZSBrZXJuZWwgKGlm
IHJlbG9jYXRhYmxlX2tlcm5lbCBpcworICB0cnVlLikgIFN0YXJ0aW5nIHdpdGggcHJvdG9j
b2wgdmVyc2lvbiAyLjEwLCB0aGlzIHJlZmxlY3RzIHRoZQorICBrZXJuZWwgYWxpZ25tZW50
IHByZWZlcnJlZCBmb3Igb3B0aW1hbCBwZXJmb3JtYW5jZSBhbmQgY2FuIGJlCisgIG1vZGlm
aWVkIGJ5IHRoZSBsb2FkZXI7IHNlZSB0aGUgbWluX2FsaWdubWVudCBhbmQgcHJlZl9hZGRy
ZXNzIGZpZWxkCisgIGJlbG93LgogCiBGaWVsZCBuYW1lOglyZWxvY2F0YWJsZV9rZXJuZWwK
IFR5cGU6CQlyZWFkIChyZWxvYykKQEAgLTQ5OCw2ICs1MDksMjIgQEAgUHJvdG9jb2w6CTIu
MDUrCiAgIEFmdGVyIGxvYWRpbmcsIHRoZSBib290IGxvYWRlciBtdXN0IHNldCB0aGUgY29k
ZTMyX3N0YXJ0IGZpZWxkIHRvCiAgIHBvaW50IHRvIHRoZSBsb2FkZWQgY29kZSwgb3IgdG8g
YSBib290IGxvYWRlciBob29rLgogCitGaWVsZCBuYW1lOgltaW5fYWxpZ25tZW50CitUeXBl
OgkJcmVhZCAocmVsb2MpCitPZmZzZXQvc2l6ZToJMHgyMzUvMQorUHJvdG9jb2w6CTIuMTAr
CisKKyAgVGhpcyBmaWVsZCwgaWYgbm9uemVybywgaW5kaWNhdGVzIGFzIGEgcG93ZXIgb2Yg
MiB0aGUgbWluaW11bQorICBhbGlnbm1lbnQgcmVxdWlyZWQsIGFzIG9wcG9zZWQgdG8gcHJl
ZmVycmVkLCBieSB0aGUga2VybmVsIHRvIGJvb3QuCisgIElmIGEgYm9vdCBsb2FkZXIgbWFr
ZXMgdXNlIG9mIHRoaXMgZmllbGQsIGl0IHNob3VsZCB1cGRhdGUgdGhlCisgIGtlcm5lbF9h
bGlnbm1lbnQgZmllbGQgd2l0aCB0aGUgYWxpZ25tZW50IHVuaXQgZGVzaXJlZDsgdHlwaWNh
bGx5OgorCisJa2VybmVsX2FsaWdubWVudCA9IDEgPDwgbWluX2FsaWdubWVudAorCisgIFRo
ZXJlIG1heSBiZSBhIGNvbnNpZGVyYWJsZSBwZXJmb3JtYW5jZSBjb3N0IHdpdGggYW4gZXhj
ZXNzaXZlbHkKKyAgbWlzYWxpZ25lZCBrZXJuZWwuICBUaGVyZWZvcmUsIGEgbG9hZGVyIHNo
b3VsZCB0eXBpY2FsbHkgdHJ5IGVhY2gKKyAgcG93ZXItb2YtdHdvIGFsaWdubWVudCBmcm9t
IGtlcm5lbF9hbGlnbm1lbnQgZG93biB0byB0aGlzIGFsaWdubWVudC4KKwogRmllbGQgbmFt
ZToJY21kbGluZV9zaXplCiBUeXBlOgkJcmVhZAogT2Zmc2V0L3NpemU6CTB4MjM4LzQKQEAg
LTU4Miw2ICs2MDksMjcgQEAgUHJvdG9jb2w6CTIuMDkrCiAgIHN1cmUgdG8gY29uc2lkZXIg
dGhlIGNhc2Ugd2hlcmUgdGhlIGxpbmtlZCBsaXN0IGFscmVhZHkgY29udGFpbnMKICAgZW50
cmllcy4KIAorRmllbGQgbmFtZToJcHJlZl9hZGRyZXNzCitUeXBlOgkJcmVhZCAocmVsb2Mp
CitPZmZzZXQvc2l6ZToJMHgyNTgvOAorUHJvdG9jb2w6CTIuMTArCisKKyAgVGhpcyBmaWVs
ZCwgaWYgbm9uemVybywgcmVwcmVzZW50cyBhIHByZWZlcnJlZCBsb2FkIGFkZHJlc3MgZm9y
IHRoZQorICBrZXJuZWwuICBBIHJlbG9jYXRpbmcgYm9vdGxvYWRlciBzaG91bGQgYXR0ZW1w
dCB0byBsb2FkIGF0IHRoaXMKKyAgYWRkcmVzcyBpZiBwb3NzaWJsZS4KKworCitGaWVsZCBu
YW1lOglpbml0X3NpemUKK1R5cGU6CQlyZWFkCitPZmZzZXQvc2l6ZToJMHgyNWMvNAorCisg
IFRoaXMgZmllbGQgaW5kaWNhdGVzIHRoZSBhbW91bnQgb2YgbGluZWFyIGNvbnRpZ3VvdXMg
bWVtb3J5IHN0YXJ0aW5nCisgIGF0IHRoZSBrZXJuZWwgbG9hZCBhZGRyZXNzIChyb3VuZGVk
IHVwIHRvIGtlcm5lbF9hbGlnbm1lbnQpIHRoYXQgdGhlCisgIGtlcm5lbCBuZWVkcyBiZWZv
cmUgaXQgaXMgY2FwYWJsZSBvZiBleGFtaW5pbmcgaXRzIG1lbW9yeSBtYXAuICBUaGlzCisg
IGlzIG5vdCB0aGUgc2FtZSB0aGluZyBhcyB0aGUgdG90YWwgYW1vdW50IG9mIG1lbW9yeSB0
aGUga2VybmVsIG5lZWRzCisgIHRvIGJvb3QsIGJ1dCBpdCBjYW4gYmUgdXNlZCBieSBhIHJl
bG9jYXRpbmcgYm9vdCBsb2FkZXIgdG8gaGVscAorICBzZWxlY3QgYSBzYWZlIGxvYWQgYWRk
cmVzcyBmb3IgdGhlIGtlcm5lbC4KKwogCiAqKioqIFRIRSBJTUFHRSBDSEVDS1NVTQogCg==
--------------040403060004040002050909--
