Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbYBDGOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbYBDGOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 01:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYBDGOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 01:14:04 -0500
Received: from smtp-out.google.com ([216.239.45.13]:27409 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbYBDGOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 01:14:03 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:mime-version:content-type;
	b=pEMJT5odPI+8UUK3zNAZQBzI+Tg9RVCPtcTtev/pSWPjnP9T5qctQyttyHxUusWty
	SxRuc9gPqHqlGIMIAslyA==
Message-ID: <3f1a065b0802032213j713fe551t9a0642ea2b83994@mail.gmail.com>
Date: Sun, 3 Feb 2008 22:13:53 -0800
From: "Russell Leidich" <rml@google.com>
To: "Andi Kleen" <andi@firstfloor.org>,
       "Torsten Kaiser" <just.for.lkml@googlemail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>, valdis.kletnieks@vt.edu
Subject: [PATCH] Remove Barcelona Thermal Throttling
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_3227_12485041.1202105633918"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_3227_12485041.1202105633918
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

All,

You can imagine my dismay when I recently learned that, after all our
collective effort, hardware thermal throttling does not work reliably
on Barcelona, according to AMD.  Due to NDA restrictions, I am unable
to provide further details.

But the effort has not been a waste; whenever AMD manages to make a
reliable hardware thermal sensor, this code should "just work" along
with all the other northbridge initialization associated with the
device IDs in k8_northbridges[].

This patch Blacklists Barcelona as non-hardware-thermal-throttlable
(in addition to RevF, which was already blacklisted).  On the
recommendation of my colleagues, it also contains these politeness
enhancements: (1) warns the user if the CPU is _not_ blacklisted, but
the BIOS neglected to enable thermal throttling (as a safety measure)
and (2) uses the PCI_SLOT macro instead of the more obnoxious
shift-right-by-3 to compute PCI device numbers.

This patch assumes that it is being applied _after_ my previous patch
has already been integrated.  I mailed out that patch on 1/17/2008
with subject "Re: [PATCH] AMD Thermal Interrupt Support".
-- 
Russell Leidich

------=_Part_3227_12485041.1202105633918
Content-Type: text/plain; name=patch.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fc8mn64j0
Content-Disposition: attachment; filename=patch.txt

U2lnbmVkLW9mZi1ieTogUnVzc2VsbCBMZWlkaWNoIDxybWxAZ29vZ2xlLmNvbT4KLS0tIGxpbnV4
LTIuNi4yNC1yYzUub3JpZy9hcmNoL3g4Ni9rZXJuZWwvY3B1L21jaGVjay9tY2VfYW1kXzY0CTIw
MDgtMDItMDMgMjE6MTc6NTguMTg2NjEzMDAwIC0wODAwCisrKyBsaW51eC0yLjYuMjQtcmM1L2Fy
Y2gveDg2L2tlcm5lbC9jcHUvbWNoZWNrL21jZV9hbWRfNjQuYwkyMDA4LTAyLTAzIDIxOjUxOjM4
LjgxMDk4OTAwMCAtMDgwMApAQCAtNzQyLDEzICs3NDIsMjAgQEAgc3RhdGljIHZvaWQgc21wX3Ro
ZXJtYWxfbm9ydGhicmlkZ2VfaW5pdAogCQkgKi8KIAkJcGNpX3JlYWRfY29uZmlnX2R3b3JkKGs4
X25vcnRoYnJpZGdlc1tuYl9udW1dLAogCQkJCQlUSEVSTV9DVExfRjNYNjQsICZ0aGVybV9jdGxf
ZjN4NjQpOwotCQl0aGVybV9jdGxfZjN4NjQgfD0gUFNMX0FQSUNfSElfRU4gfCBIVENfRU47CisJ
CXRoZXJtX2N0bF9mM3g2NCB8PSBQU0xfQVBJQ19ISV9FTjsKIAkJdGhlcm1fY3RsX2YzeDY0ICY9
ICh+UFNMX0FQSUNfTE9fRU4pOwogCQlwY2lfd3JpdGVfY29uZmlnX2R3b3JkKGs4X25vcnRoYnJp
ZGdlc1tuYl9udW1dLAogCQkJCQlUSEVSTV9DVExfRjNYNjQsIHRoZXJtX2N0bF9mM3g2NCk7Ci0J
CXByaW50ayhLRVJOX0lORk8gIkNQVSB0aGVybWFsIHRocm90dGxpbmcgaW50ZXJydXB0cyBlbmFi
bGVkIGluICIKLQkJCSJQQ0kgYnVzIDB4MCwgZGV2aWNlIDB4JXgsIGZ1bmN0aW9uIDB4MywgcmVn
aXN0ZXIgMHg2NC4iCi0JCQkiXG4iLCBrOF9ub3J0aGJyaWRnZXNbbmJfbnVtXS0+ZGV2Zm4gPj4g
Myk7CisJCWlmICh0aGVybV9jdGxfZjN4NjQgJiBIVENfRU4pCisJCQlwcmludGsoS0VSTl9JTkZP
ICJDUFUgdGhlcm1hbCB0aHJvdHRsaW5nIGludGVycnVwdHMgIgorCQkJCSJlbmFibGVkIGluIFBD
SSBidXMgMHgwLCBkZXZpY2UgMHgleCwgZnVuY3Rpb24gIgorCQkJCSIweDMsIHJlZ2lzdGVyIDB4
NjQuXG4iLAorCQkJCVBDSV9TTE9UKGs4X25vcnRoYnJpZGdlc1tuYl9udW1dLT5kZXZmbikpOwor
CQllbHNlCisJCQlwcmludGsoS0VSTl9XQVJOSU5HICJDUFUgdGhlcm1hbCB0aHJvdHRsaW5nIGRp
c2FibGVkIGJ5IgorCQkJCSIgdGhlIEJJT1MgaW4gUENJIGJ1cyAweDAsIGRldmljZSAweCV4LCAi
CisJCQkJImZ1bmN0aW9uIDB4MywgcmVnaXN0ZXIgMHg2NCwgYml0IDB4MC5cbiIsCisJCQkJUENJ
X1NMT1Qoazhfbm9ydGhicmlkZ2VzW25iX251bV0tPmRldmZuKSk7CiAJfQogfQogCkBAIC04MzUs
NyArODQyLDcgQEAgc3RhdGljIHZvaWQgc21wX3RoZXJtYWxfZWFybHlfdGhyb3R0bGVfYwogICog
Y29ycmVzcG9uZGluZyBBUElDIGluaXRpYWxpemF0aW9uIG9uIGVhY2ggY29yZS4KICAqCiAgKiBE
dWUgdG8gYW4gZXJyYXR1bSBpbnZvbHZpbmcgdGhlIHRoZXJtYWwgc2Vuc29yLCB0aGlzIGNvZGUg
ZG9lcyBub3Qgd29yayBvbgotICogYW55IENQVSBwcmlvciB0byBGYW1pbHkgMHgxMC4KKyAqIENQ
VXMgd2l0aCBjZXJ0YWluIG5vcnRoYnJpZGdlIGRldmljZSBJRHMsIGFzIGNvZGVkIGJlbG93Lgog
ICovCiBzdGF0aWMgaW50IHNtcF90aGVybWFsX2ludGVycnVwdF9pbml0KHZvaWQpCiB7CkBAIC04
NDQsMTMgKzg1MSwxNSBAQCBzdGF0aWMgaW50IHNtcF90aGVybWFsX2ludGVycnVwdF9pbml0KHZv
CiAJaWYgKG51bV9rOF9ub3J0aGJyaWRnZXMgPT0gMCkKIAkJZ290byBvdXQ7CiAJLyoKLQkgKiBJ
ZiBhbnkgb2YgdGhlIG5vcnRoYnJpZGdlcyBoYXMgUENJIElEIDB4MTEwMywgdGhlbiBpdHMgdGhl
cm1hbAotCSAqIGhhcmR3YXJlIHN1ZmZlcnMgZnJvbSBhbiBlcnJhdHVtIHdoaWNoIHByZXZlbnRz
IHRoaXMgY29kZSBmcm9tCi0JICogd29ya2luZywgc28gYWJvcnQuICAoVGhpcyBpbXBsaWVzIHRo
YXQgaXQgb25seSB3b3JrcyBvbiBGYW1pbHkKLQkgKiAweDEwLikKKwkgKiBJZiBhbnkgb2YgdGhl
IG5vcnRoYnJpZGdlcyBoYXMgYW55IG9mIHRoZSBkZXZpY2UgSURzIGluIHRoZSBmb2xsb3dpbmcK
KwkgKiBsb29wLCB0aGVuIHRoZSBoYXJkd2FyZSBzdWZmZXJzIGZyb20gYW4gZXJyYXR1bSB3aGlj
aCBwcmV2ZW50cworCSAqIHRoaXMgY29kZSBmcm9tIHdvcmtpbmcsIHNvIGFib3J0LgogCSAqLwog
CWZvciAobmJfbnVtID0gMDsgbmJfbnVtIDwgbnVtX2s4X25vcnRoYnJpZGdlczsgbmJfbnVtKysp
IHsKLQkJaWYgKChrOF9ub3J0aGJyaWRnZXNbbmJfbnVtXS0+ZGV2aWNlKSA9PSAweDExMDMpCisJ
CV9fdTMyIGRldmljZV9pZDsKKworCQlkZXZpY2VfaWQgPSBrOF9ub3J0aGJyaWRnZXNbbmJfbnVt
XS0+ZGV2aWNlOworCQlpZiAoKGRldmljZV9pZCA9PSAweDExMDMpIHx8IChkZXZpY2VfaWQgPT0g
MHgxMjAzKSkKIAkJCWdvdG8gb3V0OwogCX0KIAkvKgo=
------=_Part_3227_12485041.1202105633918--
