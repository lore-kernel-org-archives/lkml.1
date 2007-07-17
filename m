Return-Path: <linux-kernel-owner+w=401wt.eu-S1765684AbXGQRjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765684AbXGQRjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756957AbXGQRjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:39:48 -0400
Received: from nn7.de ([85.214.94.156]:48709 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbXGQRjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:39:47 -0400
Subject: Re: [PATCH] appletouch powersaving - please apply for 2.6.23-rc1
From: Soeren Sonnenburg <kernel@nn7.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-usb-devel@lists.sourceforge.net,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nicolas Boichat <nicolas@boichat.ch>,
       Michael Hanselmann <linux-kernel@hansmi.ch>,
       Peter Osterlund <petero2@telia.com>,
       Frank Arnold <frank@scirocco-5v-turbo.de>,
       Stelian Pop <stelian@popies.net>, Greg Kroah-Hartman <greg@kroah.com>
In-Reply-To: <1184677424.3773.87.camel@johannes.berg>
References: <1184656218.14051.43.camel@localhost>
	 <1184677424.3773.87.camel@johannes.berg>
Content-Type: multipart/mixed; boundary="=-/m7FZM0gzkuqNm2vjmAW"
Date: Tue, 17 Jul 2007 16:14:38 +0000
Message-Id: <1184688878.19909.37.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/m7FZM0gzkuqNm2vjmAW
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2007-07-17 at 15:03 +0200, Johannes Berg wrote:
> Hi,
> 
> Good stuff :)
> 
> > +	int                     idlecount;      /* number of empty packets */
> 
> should probably use tabs here.

fixed.

> > +	size = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
> > +			       ATP_GEYSER3_MODE_WRITE_REQUEST_ID,
> > +			       USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> > +			       ATP_GEYSER3_MODE_REQUEST_VALUE,
> > +			       ATP_GEYSER3_MODE_REQUEST_INDEX, &data, 8, 5000);
> > +	<eol>
> 
> trailing whitespace.

fixed
 
> > +	input_report_key(dev->input, BTN_LEFT, dev->data[dev->datalen-1] & 1);
> > +
> 
> 
> > @@ -449,10 +511,19 @@ static void atp_complete(struct urb* urb)
> >  
> >  		/* reset the accumulator on release */
> >  		memset(dev->xy_acc, 0, sizeof(dev->xy_acc));
> > -	}
> >  
> > -	input_report_key(dev->input, BTN_LEFT,
> > -			 !!dev->data[dev->datalen - 1]);
> 
> Any hint as to why you move this? The different test, yes, ok, you
> explained that, but moving it?

OK, Sven Anders also asked why the move... and well the reason was that
when I was trying to figure out what goes wrong I memset everything
including dev->data to zero which required the move ...

Anyway as there is no goto/return inbetween I fail to see that this will
make any difference. So I moved the code back down where it was. 

The new patch containing these cleanups is attached.

Best,
Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.

--=-/m7FZM0gzkuqNm2vjmAW
Content-Disposition: attachment; filename=appletouch2.patch
Content-Transfer-Encoding: base64
Content-Type: text/x-patch; name=appletouch2.patch; charset=ISO-8859-15

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5wdXQvbW91c2UvYXBwbGV0b3VjaC5jIGIvZHJpdmVycy9p
bnB1dC9tb3VzZS9hcHBsZXRvdWNoLmMNCmluZGV4IGUzMjE1MjYuLjM0YzFlY2EgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL2lucHV0L21vdXNlL2FwcGxldG91Y2guYw0KKysrIGIvZHJpdmVycy9pbnB1
dC9tb3VzZS9hcHBsZXRvdWNoLmMNCkBAIC0xNTUsNiArMTU1LDggQEAgc3RydWN0IGF0cCB7DQog
CWludAkJCXh5X2FjY1tBVFBfWFNFTlNPUlMgKyBBVFBfWVNFTlNPUlNdOw0KIAlpbnQJCQlvdmVy
Zmxvd3dhcm47CS8qIG92ZXJmbG93IHdhcm5pbmcgcHJpbnRlZD8gKi8NCiAJaW50CQkJZGF0YWxl
bjsJLyogc2l6ZSBvZiBhbiBVU0IgdXJiIHRyYW5zZmVyICovDQorCWludAkJCWlkbGVjb3VudDsg
ICAgICAvKiBudW1iZXIgb2YgZW1wdHkgcGFja2V0cyAqLw0KKwlzdHJ1Y3Qgd29ya19zdHJ1Y3Qg
ICAgICB3b3JrOw0KIH07DQogDQogI2RlZmluZSBkYmdfZHVtcChtc2csIHRhYikgXA0KQEAgLTIw
OCw2ICsyMTAsNjMgQEAgc3RhdGljIGlubGluZSBpbnQgYXRwX2lzX2dleXNlcl8zKHN0cnVjdCBh
dHAgKmRldikNCiAJCShwcm9kdWN0SWQgPT0gR0VZU0VSNF9KSVNfUFJPRFVDVF9JRCk7DQogfQ0K
IA0KKy8qDQorICogQnkgZGVmYXVsdCBHZXlzZXIgMyBkZXZpY2Ugc2VuZHMgc3RhbmRhcmQgVVNC
IEhJRCBtb3VzZQ0KKyAqIHBhY2tldHMgKFJlcG9ydCBJRCAyKS4gVGhpcyBjb2RlIGNoYW5nZXMg
ZGV2aWNlIG1vZGUsIHNvIGl0DQorICogc2VuZHMgcmF3IHNlbnNvciByZXBvcnRzIChSZXBvcnQg
SUQgNSkuDQorICovDQorc3RhdGljIGludCBhdHBfZ2V5c2VyM19pbml0KHN0cnVjdCB1c2JfZGV2
aWNlICp1ZGV2KQ0KK3sNCisJY2hhciBkYXRhWzhdOw0KKwlpbnQgc2l6ZTsNCisJaW50IGk7DQor
DQorCXNpemUgPSB1c2JfY29udHJvbF9tc2codWRldiwgdXNiX3JjdmN0cmxwaXBlKHVkZXYsIDAp
LA0KKwkJCQlBVFBfR0VZU0VSM19NT0RFX1JFQURfUkVRVUVTVF9JRCwNCisJCQkJVVNCX0RJUl9J
TiB8IFVTQl9UWVBFX0NMQVNTIHwgVVNCX1JFQ0lQX0lOVEVSRkFDRSwNCisJCQkJQVRQX0dFWVNF
UjNfTU9ERV9SRVFVRVNUX1ZBTFVFLA0KKwkJCQlBVFBfR0VZU0VSM19NT0RFX1JFUVVFU1RfSU5E
RVgsICZkYXRhLCA4LCA1MDAwKTsNCisNCisJaWYgKHNpemUgIT0gOCkgew0KKwkJcHJpbnRrKCJh
cHBsZXRvdWNoIGF0cF9nZXlzZXIzX2luaXQgUkVBRCBlcnJvclxuIik7DQorCQlmb3IgKGk9MDsg
aTw4OyBpKyspDQorCQkJcHJpbnRrKCJhcHBsZXRvdWNoWyVkXTogJWRcbiIsIGksIChpbnQpIGRh
dGFbaV0pOw0KKw0KKwkJZXJyKCJDb3VsZCBub3QgZG8gbW9kZSByZWFkIHJlcXVlc3QgZnJvbSBk
ZXZpY2UiDQorCQkgICAgIiAoR2V5c2VyIDMgbW9kZSkiKTsNCisJCXJldHVybiAtRUlPOw0KKwl9
DQorDQorCS8qIEFwcGx5IHRoZSBtb2RlIHN3aXRjaCAqLw0KKwlkYXRhWzBdID0gQVRQX0dFWVNF
UjNfTU9ERV9WRU5ET1JfVkFMVUU7DQorDQorCXNpemUgPSB1c2JfY29udHJvbF9tc2codWRldiwg
dXNiX3NuZGN0cmxwaXBlKHVkZXYsIDApLA0KKwkJCQlBVFBfR0VZU0VSM19NT0RFX1dSSVRFX1JF
UVVFU1RfSUQsDQorCQkJCVVTQl9ESVJfT1VUIHwgVVNCX1RZUEVfQ0xBU1MgfCBVU0JfUkVDSVBf
SU5URVJGQUNFLA0KKwkJCQlBVFBfR0VZU0VSM19NT0RFX1JFUVVFU1RfVkFMVUUsDQorCQkJCUFU
UF9HRVlTRVIzX01PREVfUkVRVUVTVF9JTkRFWCwgJmRhdGEsIDgsIDUwMDApOw0KKw0KKwlpZiAo
c2l6ZSAhPSA4KSB7DQorCQlwcmludGsoImFwcGxldG91Y2ggYXRwX2dleXNlcjNfaW5pdCBXUklU
RSBlcnJvclxuIik7DQorCQlmb3IgKGk9MDsgaTw4OyBpKyspDQorCQkJcHJpbnRrKCJhcHBsZXRv
dWNoWyVkXTogJWRcbiIsIGksIChpbnQpIGRhdGFbaV0pOw0KKwkJZXJyKCJDb3VsZCBub3QgZG8g
bW9kZSB3cml0ZSByZXF1ZXN0IHRvIGRldmljZSINCisJCSAgICAiIChHZXlzZXIgMyBtb2RlKSIp
Ow0KKwkJcmV0dXJuIC1FSU87DQorCX0NCisJcmV0dXJuIDA7DQorfQ0KKw0KKy8qIFJlaW5pdGlh
bGlzZSB0aGUgZGV2aWNlIGlmIGl0J3MgYSBnZXlzZXIgMyAqLw0KK3N0YXRpYyB2b2lkIGF0cF9y
ZWluaXQoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0KK3sNCisJc3RydWN0IGF0cCAqZGV2ID0g
Y29udGFpbmVyX29mKHdvcmssIHN0cnVjdCBhdHAsIHdvcmspOw0KKwlzdHJ1Y3QgdXNiX2Rldmlj
ZSAqdWRldiA9IGRldi0+dWRldjsNCisNCisJZGV2LT5pZGxlY291bnQgPSAwOw0KKwlhdHBfZ2V5
c2VyM19pbml0KHVkZXYpOw0KK30NCisNCiBzdGF0aWMgaW50IGF0cF9jYWxjdWxhdGVfYWJzKGlu
dCAqeHlfc2Vuc29ycywgaW50IG5iX3NlbnNvcnMsIGludCBmYWN0LA0KIAkJCSAgICAgaW50ICp6
LCBpbnQgKmZpbmdlcnMpDQogew0KQEAgLTQ0OSwxMSArNTA4LDIxIEBAIHN0YXRpYyB2b2lkIGF0
cF9jb21wbGV0ZShzdHJ1Y3QgdXJiKiB1cmIpDQogDQogCQkvKiByZXNldCB0aGUgYWNjdW11bGF0
b3Igb24gcmVsZWFzZSAqLw0KIAkJbWVtc2V0KGRldi0+eHlfYWNjLCAwLCBzaXplb2YoZGV2LT54
eV9hY2MpKTsNCi0JfQ0KIA0KLQlpbnB1dF9yZXBvcnRfa2V5KGRldi0+aW5wdXQsIEJUTl9MRUZU
LA0KLQkJCSAhIWRldi0+ZGF0YVtkZXYtPmRhdGFsZW4gLSAxXSk7DQorCQkvKiBHZXlzZXIgMyB3
aWxsIGNvbnRpbnVlIHRvIHNlbmQgcGFja2V0cyBjb250aW51YWxseSBhZnRlcg0KKwkJICAgdGhl
IGZpcnN0IHRvdWNoIHVubGVzcyByZWluaXRpYWxpc2VkLiBEbyBzbyBpZiBpdCdzIGJlZW4NCisJ
CSAgIGlkbGUgZm9yIGEgd2hpbGUgaW4gb3JkZXIgdG8gYXZvaWQgd2FraW5nIHRoZSBrZXJuZWwg
dXANCisJCSAgIHNldmVyYWwgaHVuZHJlZCB0aW1lcyBhIHNlY29uZCAqLw0KKwkJaWYgKGF0cF9p
c19nZXlzZXJfMyhkZXYpKSB7DQorCQkJZGV2LT5pZGxlY291bnQrKzsNCisJCQlpZiAoZGV2LT5p
ZGxlY291bnQgPT0gMTApIHsNCisJCQkJZGV2LT52YWxpZD0wOw0KKwkJCQlzY2hlZHVsZV93b3Jr
ICgmZGV2LT53b3JrKTsNCisJCQl9DQorCQl9DQorCX0NCiANCisJaW5wdXRfcmVwb3J0X2tleShk
ZXYtPmlucHV0LCBCVE5fTEVGVCwgZGV2LT5kYXRhW2Rldi0+ZGF0YWxlbi0xXSAmIDEpOw0KIAlp
bnB1dF9zeW5jKGRldi0+aW5wdXQpOw0KIA0KIGV4aXQ6DQpAQCAtNTI4LDQwICs1OTcsMTAgQEAg
c3RhdGljIGludCBhdHBfcHJvYmUoc3RydWN0IHVzYl9pbnRlcmZhY2UgKmlmYWNlLCBjb25zdCBz
dHJ1Y3QgdXNiX2RldmljZV9pZCAqaWQNCiAJCWRldi0+ZGF0YWxlbiA9IDgxOw0KIA0KIAlpZiAo
YXRwX2lzX2dleXNlcl8zKGRldikpIHsNCi0JCS8qDQotCQkgKiBCeSBkZWZhdWx0IEdleXNlciAz
IGRldmljZSBzZW5kcyBzdGFuZGFyZCBVU0IgSElEIG1vdXNlDQotCQkgKiBwYWNrZXRzIChSZXBv
cnQgSUQgMikuIFRoaXMgY29kZSBjaGFuZ2VzIGRldmljZSBtb2RlLCBzbyBpdA0KLQkJICogc2Vu
ZHMgcmF3IHNlbnNvciByZXBvcnRzIChSZXBvcnQgSUQgNSkuDQotCQkgKi8NCi0JCWNoYXIgZGF0
YVs4XTsNCi0JCWludCBzaXplOw0KLQ0KLQkJc2l6ZSA9IHVzYl9jb250cm9sX21zZyh1ZGV2LCB1
c2JfcmN2Y3RybHBpcGUodWRldiwgMCksDQotCQkJQVRQX0dFWVNFUjNfTU9ERV9SRUFEX1JFUVVF
U1RfSUQsDQotCQkJVVNCX0RJUl9JTiB8IFVTQl9UWVBFX0NMQVNTIHwgVVNCX1JFQ0lQX0lOVEVS
RkFDRSwNCi0JCQlBVFBfR0VZU0VSM19NT0RFX1JFUVVFU1RfVkFMVUUsDQotCQkJQVRQX0dFWVNF
UjNfTU9ERV9SRVFVRVNUX0lOREVYLCAmZGF0YSwgOCwgNTAwMCk7DQotDQotCQlpZiAoc2l6ZSAh
PSA4KSB7DQotCQkJZXJyKCJDb3VsZCBub3QgZG8gbW9kZSByZWFkIHJlcXVlc3QgZnJvbSBkZXZp
Y2UiDQotCQkJCQkJCSIgKEdleXNlciAzIG1vZGUpIik7DQorCQkvKiBzd2l0Y2ggdG8gcmF3IHNl
bnNvciBtb2RlICovDQorCQlpZiAoYXRwX2dleXNlcjNfaW5pdCh1ZGV2KSkNCiAJCQlnb3RvIGVy
cl9mcmVlX2RldnM7DQotCQl9DQotDQotCQkvKiBBcHBseSB0aGUgbW9kZSBzd2l0Y2ggKi8NCi0J
CWRhdGFbMF0gPSBBVFBfR0VZU0VSM19NT0RFX1ZFTkRPUl9WQUxVRTsNCi0NCi0JCXNpemUgPSB1
c2JfY29udHJvbF9tc2codWRldiwgdXNiX3NuZGN0cmxwaXBlKHVkZXYsIDApLA0KLQkJCUFUUF9H
RVlTRVIzX01PREVfV1JJVEVfUkVRVUVTVF9JRCwNCi0JCQlVU0JfRElSX09VVCB8IFVTQl9UWVBF
X0NMQVNTIHwgVVNCX1JFQ0lQX0lOVEVSRkFDRSwNCi0JCQlBVFBfR0VZU0VSM19NT0RFX1JFUVVF
U1RfVkFMVUUsDQotCQkJQVRQX0dFWVNFUjNfTU9ERV9SRVFVRVNUX0lOREVYLCAmZGF0YSwgOCwg
NTAwMCk7DQogDQotCQlpZiAoc2l6ZSAhPSA4KSB7DQotCQkJZXJyKCJDb3VsZCBub3QgZG8gbW9k
ZSB3cml0ZSByZXF1ZXN0IHRvIGRldmljZSINCi0JCQkJCQkJIiAoR2V5c2VyIDMgbW9kZSkiKTsN
Ci0JCQlnb3RvIGVycl9mcmVlX2RldnM7DQotCQl9DQogCQlwcmludGsoImFwcGxldG91Y2ggR2V5
c2VyIDMgaW5pdGVkLlxuIik7DQogCX0NCiANCkBAIC02MzYsNiArNjc1LDggQEAgc3RhdGljIGlu
dCBhdHBfcHJvYmUoc3RydWN0IHVzYl9pbnRlcmZhY2UgKmlmYWNlLCBjb25zdCBzdHJ1Y3QgdXNi
X2RldmljZV9pZCAqaWQNCiAJLyogc2F2ZSBvdXIgZGF0YSBwb2ludGVyIGluIHRoaXMgaW50ZXJm
YWNlIGRldmljZSAqLw0KIAl1c2Jfc2V0X2ludGZkYXRhKGlmYWNlLCBkZXYpOw0KIA0KKwlJTklU
X1dPUksoJmRldi0+d29yaywgYXRwX3JlaW5pdCk7DQorDQogCXJldHVybiAwOw0KIA0KICBlcnJf
ZnJlZV9idWZmZXI6DQpAQCAtNjU2LDYgKzY5Nyw3IEBAIHN0YXRpYyB2b2lkIGF0cF9kaXNjb25u
ZWN0KHN0cnVjdCB1c2JfaW50ZXJmYWNlICppZmFjZSkNCiANCiAJdXNiX3NldF9pbnRmZGF0YShp
ZmFjZSwgTlVMTCk7DQogCWlmIChkZXYpIHsNCisJCWNhbmNlbF93b3JrX3N5bmMoJmRldi0+d29y
ayk7DQogCQl1c2Jfa2lsbF91cmIoZGV2LT51cmIpOw0KIAkJaW5wdXRfdW5yZWdpc3Rlcl9kZXZp
Y2UoZGV2LT5pbnB1dCk7DQogCQl1c2JfYnVmZmVyX2ZyZWUoZGV2LT51ZGV2LCBkZXYtPmRhdGFs
ZW4sDQo=


--=-/m7FZM0gzkuqNm2vjmAW--
