Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbYDXCLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbYDXCLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 22:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYDXCLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 22:11:07 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:24119 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbYDXCLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 22:11:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=FgH6c0hnZvqmYyVdpLSgLz//uqPV8Kj8Pfp429iKwt1FnIbnBI6PbkOHDiqEXWFlgjXfirS/6vGJWmzaDEN0nAQzytf4ysp7Hdrvz7Q0WIswn4QOcOK5y3OUBIiyh/ID/8jhGbzO67WGQr9pApFN06H+MxlVM5su0lH1G78kIH4=
Message-ID: <86802c440804231911y51d2cf9bw50246a6435ae1f98@mail.gmail.com>
Date: Wed, 23 Apr 2008 19:11:02 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: michael@ellerman.id.au
Subject: Re: [PATCH] pci: let pci_device_shutdown to call pci_disable_msi
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>, "Greg KH" <greg@kroah.com>,
       "David Miller" <davem@davemloft.net>, "Jeff Garzik" <jeff@garzik.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Sathya Prakash" <sathya.prakash@lsi.com>
In-Reply-To: <86802c440804231822s7cc4e2c1vfdb7f40ae0580045@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_20301_28018326.1209003062792"
References: <200804222148.17530.yhlu.kernel@gmail.com>
	 <1208928277.9212.1.camel@concordia.ozlabs.ibm.com>
	 <m1hcdsoh1i.fsf@frodo.ebiederm.org>
	 <1208996273.9245.18.camel@concordia.ozlabs.ibm.com>
	 <86802c440804231822s7cc4e2c1vfdb7f40ae0580045@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_20301_28018326.1209003062792
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Apr 23, 2008 at 6:22 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> On Wed, Apr 23, 2008 at 5:17 PM, Michael Ellerman
>  <michael@ellerman.id.au> wrote:
>  >  But does that help us? What if the device driver in the 2nd kernel
>  >  assumes it's using INTX, when in fact MSI is enabled on the device. In
>  >  that case none of the MSI code will even be called AFAIK.
>
>  ok. for kdump case, if driver can not use msi (?), with pci=nomsi
>  we need to call pci_intx_for_msi(dev, 1) at beginning of second kernel.
>
>  will produce another patch about that case.

attached kernel should fix second kernel by kdump doesn't have msi
support problem.

anyway kexec path doesn't need attached one, because shutdown in first
kernel already did pci_msi_shutdown and it called pci_initx_for_msi

also long term should teach every driver call pci_intx_for_msi(dev, 1)?

YH

------=_Part_20301_28018326.1209003062792
Content-Type: text/x-patch; name=enable_intx_for_kdump.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ffep033d0
Content-Disposition: attachment; filename=enable_intx_for_kdump.patch

W1BBVENIXSBwY2kvaXJxOiBlbmFibGUgSU5UeCBpbiBwY2lfaW5pdAoKaW4gY2FzZSBzZWNvbmQg
a2VybmVsIHRoYXQgaXMgdXNlZCBieSBrZHVtcCBkb24ndCBoYXZlIE1TSSBzdXBwb3J0LgoKU2ln
bmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWhsdS5rZXJuZWxAZ21haWwuY29tPgoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvcGNpL21zaS5jIGIvZHJpdmVycy9wY2kvbXNpLmMKaW5kZXggMjY5MzhkYS4u
Y2EwNTcyNiAxMDA2NDQKLS0tIGEvZHJpdmVycy9wY2kvbXNpLmMKKysrIGIvZHJpdmVycy9wY2kv
bXNpLmMKQEAgLTI2OSwxMiArMjY5LDYgQEAgc3RhdGljIHN0cnVjdCBtc2lfZGVzYyogYWxsb2Nf
bXNpX2VudHJ5KHZvaWQpCiAJcmV0dXJuIGVudHJ5OwogfQogCi1zdGF0aWMgdm9pZCBwY2lfaW50
eF9mb3JfbXNpKHN0cnVjdCBwY2lfZGV2ICpkZXYsIGludCBlbmFibGUpCi17Ci0JaWYgKCEoZGV2
LT5kZXZfZmxhZ3MgJiBQQ0lfREVWX0ZMQUdTX01TSV9JTlRYX0RJU0FCTEVfQlVHKSkKLQkJcGNp
X2ludHgoZGV2LCBlbmFibGUpOwotfQotCiBzdGF0aWMgdm9pZCBfX3BjaV9yZXN0b3JlX21zaV9z
dGF0ZShzdHJ1Y3QgcGNpX2RldiAqZGV2KQogewogCWludCBwb3M7CmRpZmYgLS1naXQgYS9kcml2
ZXJzL3BjaS9wY2kuYyBiL2RyaXZlcnMvcGNpL3BjaS5jCmluZGV4IGU0NTQ4YWIuLmY1YjBlNTAg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvcGNpL3BjaS5jCisrKyBiL2RyaXZlcnMvcGNpL3BjaS5jCkBA
IC0xMzgxLDYgKzEzODEsMTMgQEAgcGNpX2ludHgoc3RydWN0IHBjaV9kZXYgKnBkZXYsIGludCBl
bmFibGUpCiAJfQogfQogCisvKiBpbiBjYXNlIHNlY29uZCBrZXJuZWwgZG9lc24ndCBoYXZlIE1T
SSBzdXBwb3J0IGJ1aWx0LWluICovCit2b2lkIHBjaV9pbnR4X2Zvcl9tc2koc3RydWN0IHBjaV9k
ZXYgKmRldiwgaW50IGVuYWJsZSkKK3sKKwlpZiAoIShkZXYtPmRldl9mbGFncyAmIFBDSV9ERVZf
RkxBR1NfTVNJX0lOVFhfRElTQUJMRV9CVUcpKQorCQlwY2lfaW50eChkZXYsIGVuYWJsZSk7Cit9
CisKIC8qKgogICogcGNpX21zaV9vZmYgLSBkaXNhYmxlcyBhbnkgbXNpIG9yIG1zaXggY2FwYWJp
bGl0aWVzCiAgKiBAZGV2OiB0aGUgUENJIGRldmljZSB0byBvcGVyYXRlIG9uCkBAIC0xNjM3LDYg
KzE2NDQsNyBAQCBzdGF0aWMgaW50IF9fZGV2aW5pdCBwY2lfaW5pdCh2b2lkKQogCXN0cnVjdCBw
Y2lfZGV2ICpkZXYgPSBOVUxMOwogCiAJd2hpbGUgKChkZXYgPSBwY2lfZ2V0X2RldmljZShQQ0lf
QU5ZX0lELCBQQ0lfQU5ZX0lELCBkZXYpKSAhPSBOVUxMKSB7CisJCXBjaV9pbnR4X2Zvcl9tc2ko
ZGV2LCAxKTsKIAkJcGNpX2ZpeHVwX2RldmljZShwY2lfZml4dXBfZmluYWwsIGRldik7CiAJfQog
CXJldHVybiAwOwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9wY2kuaCBiL2luY2x1ZGUvbGlu
dXgvcGNpLmgKaW5kZXggOGY1M2Y0Yi4uZDEwODBkMCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51
eC9wY2kuaAorKysgYi9pbmNsdWRlL2xpbnV4L3BjaS5oCkBAIC01OTIsNiArNTkyLDcgQEAgaW50
IF9fbXVzdF9jaGVjayBwY2lfc2V0X213aShzdHJ1Y3QgcGNpX2RldiAqZGV2KTsKIGludCBwY2lf
dHJ5X3NldF9td2koc3RydWN0IHBjaV9kZXYgKmRldik7CiB2b2lkIHBjaV9jbGVhcl9td2koc3Ry
dWN0IHBjaV9kZXYgKmRldik7CiB2b2lkIHBjaV9pbnR4KHN0cnVjdCBwY2lfZGV2ICpkZXYsIGlu
dCBlbmFibGUpOwordm9pZCBwY2lfaW50eF9mb3JfbXNpKHN0cnVjdCBwY2lfZGV2ICpkZXYsIGlu
dCBlbmFibGUpOwogdm9pZCBwY2lfbXNpX29mZihzdHJ1Y3QgcGNpX2RldiAqZGV2KTsKIGludCBw
Y2lfc2V0X2RtYV9tYXNrKHN0cnVjdCBwY2lfZGV2ICpkZXYsIHU2NCBtYXNrKTsKIGludCBwY2lf
c2V0X2NvbnNpc3RlbnRfZG1hX21hc2soc3RydWN0IHBjaV9kZXYgKmRldiwgdTY0IG1hc2spOwo=

------=_Part_20301_28018326.1209003062792--
