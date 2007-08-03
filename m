Return-Path: <linux-kernel-owner+w=401wt.eu-S1764634AbXHCWjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764634AbXHCWjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 18:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764212AbXHCWiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 18:38:52 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:18332 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764134AbXHCWiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 18:38:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=UkGvC8Q9rJmslXgrNfGt60+Y6bIjnyJr+mTod0QWYo/trav2TcnuaDnSAgLSQyf/O0QM15uVQyJcz9z06z/r8Q9Zxp6/CKZb/ZKhYl07FAZWX2CjuGv4zSWYXzOXlNWGPjU8utFmIap2GFlNGlCiBh04yNc+QLfaDdl28rV2PFo=
Message-ID: <6278d2220708031538s4a57f126ybfa0486816de4401@mail.gmail.com>
Date: Fri, 3 Aug 2007 23:38:47 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: ICH8 CF timeout (regression)...
Cc: "Mark Lord" <lkml@rtr.ca>, jgarzik@pobox.com, linux-ide@vger.kernel.org,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <46B30651.9030505@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_76825_27130099.1186180727922"
References: <6278d2220708020348k26ac2293v648442f2281eca70@mail.gmail.com>
	 <46B20D6B.1060506@gmail.com>
	 <6278d2220708021411q17cdc151p79922e5dab74add4@mail.gmail.com>
	 <46B25DE1.4050105@rtr.ca>
	 <6278d2220708030322h2c779fa3o1e2e2d9c83ff62e8@mail.gmail.com>
	 <46B30651.9030505@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_76825_27130099.1186180727922
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Tejun,

On 03/08/07, Tejun Heo <htejun@gmail.com> wrote:
> Daniel J Blueman wrote:
> > The ICH8 south-bridge I have is the mobile variant and does come
> > equipped with native parallel IDE - see page 447:
> > http://download.intel.com/design/chipsets/datashts/31305603.pdf . I do
> > see 35MB/s with DMA enabled from my CF on the 1 in 15 times the
> > libata-kernel does work.
> >
> > I can dump off and decode the configuration registers for the timing
> > and bus master registers in the working and non-working libata cases,
> > and the legacy ATA working case and see what's different.
>
> Does the attached patch change anything?

This addresses the issue 100%!

Due to the differences between the ICH8 non-mobile and mobile
variants, I've cooked the change into a new initialisation structure
for the ICH8M in the attached patch, if that helps at all.

The changes thus affect (correct) behaviour on the ICH8M in IDE mode
only...so should be safe for inclusion. There may be a similar
situation with ICH9Ms also.

Thanks once again to all who helped!
  Daniel
-- 
Daniel J Blueman

------=_Part_76825_27130099.1186180727922
Content-Type: text/x-patch; name=ich8m-support.patch; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f4x988vd
Content-Disposition: attachment; filename="ich8m-support.patch"

ZGlmZiAtdXJOIGxpbnV4LTIuNi4yMy1yYzEub3JpZy9kcml2ZXJzL2F0YS9hdGFfcGlpeC5jIGxp
bnV4LTIuNi4yMy1yYzEvZHJpdmVycy9hdGEvYXRhX3BpaXguYwotLS0gbGludXgtMi42LjIzLXJj
MS5vcmlnL2RyaXZlcnMvYXRhL2F0YV9waWl4LmMJMjAwNy0wOC0wMyAyMToyOTowMi4wMDAwMDAw
MDAgKzAxMDAKKysrIGxpbnV4LTIuNi4yMy1yYzEvZHJpdmVycy9hdGEvYXRhX3BpaXguYwkyMDA3
LTA4LTAzIDIxOjI0OjUzLjAwMDAwMDAwMCArMDEwMApAQCAtMTI4LDcgKzEyOCw4IEBACiAJaWNo
Nl9zYXRhX2FoY2kJCT0gNywKIAlpY2g2bV9zYXRhX2FoY2kJCT0gOCwKIAlpY2g4X3NhdGFfYWhj
aQkJPSA5LAotCXBpaXhfcGF0YV9td2RtYQkJPSAxMCwJLyogUElJWDMgTVdETUEgb25seSAqLwor
CWljaDhtX3NhdGFfYWhjaQkJPSAxMCwKKwlwaWl4X3BhdGFfbXdkbWEJCT0gMTEsCS8qIFBJSVgz
IE1XRE1BIG9ubHkgKi8KIAogCS8qIGNvbnN0YW50cyBmb3IgbWFwcGluZyB0YWJsZSAqLwogCVAw
CQkJPSAwLCAgLyogcG9ydCAwICovCkBAIC0yMzIsNyArMjMzLDcgQEAKIAkvKiBTQVRBIENvbnRy
b2xsZXIgMiBJREUgKElDSDgpICovCiAJeyAweDgwODYsIDB4MjgyNSwgUENJX0FOWV9JRCwgUENJ
X0FOWV9JRCwgMCwgMCwgaWNoOF9zYXRhX2FoY2kgfSwKIAkvKiBNb2JpbGUgU0FUQSBDb250cm9s
bGVyIElERSAoSUNIOE0pICovCi0JeyAweDgwODYsIDB4MjgyOCwgUENJX0FOWV9JRCwgUENJX0FO
WV9JRCwgMCwgMCwgaWNoOF9zYXRhX2FoY2kgfSwKKwl7IDB4ODA4NiwgMHgyODI4LCBQQ0lfQU5Z
X0lELCBQQ0lfQU5ZX0lELCAwLCAwLCBpY2g4bV9zYXRhX2FoY2kgfSwKIAkvKiBTQVRBIENvbnRy
b2xsZXIgSURFIChJQ0g5KSAqLwogCXsgMHg4MDg2LCAweDI5MjAsIFBDSV9BTllfSUQsIFBDSV9B
TllfSUQsIDAsIDAsIGljaDhfc2F0YV9haGNpIH0sCiAJLyogU0FUQSBDb250cm9sbGVyIElERSAo
SUNIOSkgKi8KQEAgLTQyOCw3ICs0MjksMTkgQEAKIAkJLyogUE0gICBQUyAgIFNNICAgU1MgICAg
ICAgTUFQICovCiAJCXsgIFAwLCAgUDIsICBQMSwgIFAzIH0sIC8qIDAwYiAoaGFyZHdpcmVkIHdo
ZW4gaW4gQUhDSSkgKi8KIAkJeyAgUlYsICBSViwgIFJWLCAgUlYgfSwKLQkJeyAgSURFLCAgSURF
LCAgTkEsICBOQSB9LCAvKiAxMGIgKElERSBtb2RlKSAqLworCQl7IElERSwgSURFLCAgTkEsICBO
QSB9LCAvKiAxMGIgKElERSBtb2RlKSAqLworCQl7ICBSViwgIFJWLCAgUlYsICBSViB9LAorCX0s
Cit9OworCitzdGF0aWMgY29uc3Qgc3RydWN0IHBpaXhfbWFwX2RiIGljaDhtX21hcF9kYiA9IHsK
KwkubWFzayA9IDB4MywKKwkucG9ydF9lbmFibGUgPSAweDMsCisJLm1hcCA9IHsKKwkJLyogUE0g
ICBQUyAgIFNNICAgU1MgICAgICAgTUFQICovCisJCXsgIFAwLCAgUDIsICBQMSwgIFAzIH0sIC8q
IDAwYiAoaGFyZHdpcmVkIHdoZW4gaW4gQUhDSSkgKi8KKwkJeyAgUlYsICBSViwgIFJWLCAgUlYg
fSwKKwkJeyAgUDAsICBQMiwgSURFLCBJREUgfSwgLyogMTBiIChJREUgbW9kZSkgKi8KIAkJeyAg
UlYsICBSViwgIFJWLCAgUlYgfSwKIAl9LAogfTsKQEAgLTQzOSw2ICs0NTIsNyBAQAogCVtpY2g2
X3NhdGFfYWhjaV0JPSAmaWNoNl9tYXBfZGIsCiAJW2ljaDZtX3NhdGFfYWhjaV0JPSAmaWNoNm1f
bWFwX2RiLAogCVtpY2g4X3NhdGFfYWhjaV0JPSAmaWNoOF9tYXBfZGIsCisJW2ljaDhtX3NhdGFf
YWhjaV0JPSAmaWNoOG1fbWFwX2RiLAogfTsKIAogc3RhdGljIHN0cnVjdCBhdGFfcG9ydF9pbmZv
IHBpaXhfcG9ydF9pbmZvW10gPSB7CkBAIC01NDQsNyArNTU4LDE4IEBACiAJCS5wb3J0X29wcwk9
ICZwaWl4X3NhdGFfb3BzLAogCX0sCiAKLQkvKiBwaWl4X3BhdGFfbXdkbWE6IDEwOiAgUElJWDMg
TVdETUEgb25seSAqLworCS8qIGljaDhtX3NhdGFfYWhjaTogMTAgKi8KKwl7CisJCS5zaHQJCT0g
JnBpaXhfc2h0LAorCQkuZmxhZ3MJCT0gUElJWF9TQVRBX0ZMQUdTIHwgUElJWF9GTEFHX1NDUiB8
CisJCQkJICBQSUlYX0ZMQUdfQUhDSSwKKwkJLnBpb19tYXNrCT0gMHgxZiwJLyogcGlvMC00ICov
CisJCS5td2RtYV9tYXNrCT0gMHgwNywgLyogbXdkbWEwLTIgKi8KKwkJLnVkbWFfbWFzawk9IEFU
QV9VRE1BNiwKKwkJLnBvcnRfb3BzCT0gJnBpaXhfc2F0YV9vcHMsCisJfSwKKworCS8qIHBpaXhf
cGF0YV9td2RtYTogMTE6ICBQSUlYMyBNV0RNQSBvbmx5ICovCiAJewogCQkuc2h0CQk9ICZwaWl4
X3NodCwKIAkJLmZsYWdzCQk9IFBJSVhfUEFUQV9GTEFHUywK
------=_Part_76825_27130099.1186180727922--
