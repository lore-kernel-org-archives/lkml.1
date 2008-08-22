Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbYHVDYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbYHVDYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 23:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYHVDY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 23:24:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:56339 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbYHVDYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 23:24:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=V61QMhxt82VfxpvGxOnquUSzEctsuWqvWix9EaZXoe12v01eUj8s71Khu2YL5SoPCP
         dwCw+887xNbX3LNZq7mfdNHB+qfZ0zCmxd1A7JETKxL1ufkfLPx2XF/XxFFPK3cKx08Q
         egtXEdxRQtRtJOK6n0XLtCLXwuP5hDXngPWVo=
Message-ID: <86802c440808212024v3ccd2a7ey6517c180464275f0@mail.gmail.com>
Date: Thu, 21 Aug 2008 20:24:24 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Joshua Hoblitt" <josh@hoblitt.com>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of 16gb of memory is usable
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com
In-Reply-To: <86802c440808211926k1ec5b2a2g2bec1b7faee7ebbb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_24880_6674366.1219375464274"
References: <86802c440808201849k6665c395x5a5b871eca55addd@mail.gmail.com>
	 <20080821233317.GE23377@hoblitt.com>
	 <20080822001047.GF23377@hoblitt.com>
	 <86802c440808211728r4b5a7a37w929c2dd68616361d@mail.gmail.com>
	 <20080822002952.GG23377@hoblitt.com>
	 <20080822010014.GH23377@hoblitt.com>
	 <20080822011055.GI23377@hoblitt.com>
	 <86802c440808211855h50ea65faudc169e48f83e18e2@mail.gmail.com>
	 <20080822021512.GJ23377@hoblitt.com>
	 <86802c440808211926k1ec5b2a2g2bec1b7faee7ebbb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_24880_6674366.1219375464274
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Aug 21, 2008 at 7:26 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Thu, Aug 21, 2008 at 7:15 PM, Joshua Hoblitt <josh@hoblitt.com> wrote:
>> On Thu, Aug 21, 2008 at 06:55:58PM -0700, Yinghai Lu wrote:
>> address sizes   : 38 bits physical, 48 bits virtual
>
> good, the root cause is your bios not set mask correctly...
>
> it should set var mtrr like
>
> [    0.429971]  MSR00000200: 00000000d0000000
> [    0.433305]  MSR00000201: 0000000ff0000800
> ==> [    0.433305]  MSR00000201: 0000003ff0000800
>
> [    0.436638]  MSR00000202: 00000000e0000000
> [    0.439971]  MSR00000203: 0000000fe0000800
> ==> [    0.439971]  MSR00000203: 0000003fe0000800
>
> [    0.443304]  MSR00000204: 0000000000000006
> [    0.446637]  MSR00000205: 0000000c00000800
> ==> [    0.446637]  MSR00000205: 0000003c00000800
>
> [    0.449970]  MSR00000206: 0000000400000006
> [    0.453303]  MSR00000207: 0000000fe0000800
> ==>[    0.453303]  MSR00000207: 0000003fe0000800
>
> [    0.456636]  MSR00000208: 0000000420000006
> [    0.459970]  MSR00000209: 0000000ff0000800
> ==> [    0.459970]  MSR00000209: 0000003ff0000800
>
> you may talk to your BIOS vendor or system vendor to request one new
> updated BIOS.
>

or please try attached workaround patch. hope it works.

Ingo,
if it works, we need to push it for 2.6.27

YH

------=_Part_24880_6674366.1219375464274
Content-Type: text/x-patch; name=work_aroun_mask.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fk68kljg0
Content-Disposition: attachment; filename=work_aroun_mask.patch

W1BBVENIXSB4ODY6IHdvcmthcm91biBtdHJyIG1hc2sgc2V0dGluZwoKU29tZSBCSU9TIGRvZXNu
J3Qgc2V0IG10cnIgbWFzayBjb3JyZWN0bHksIHdvcmthcm91bmQgaXQgYmUgcHJlZml4IDExMQoK
U2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWhsdS5rZXJuZWxAZ21haWwuY29tPgoKZGlmZiAt
LWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvbXRyci9nZW5lcmljLmMgYi9hcmNoL3g4Ni9rZXJu
ZWwvY3B1L210cnIvZ2VuZXJpYy5jCmluZGV4IDUwOWJkM2QuLmExN2Q1YmEgMTAwNjQ0Ci0tLSBh
L2FyY2gveDg2L2tlcm5lbC9jcHUvbXRyci9nZW5lcmljLmMKKysrIGIvYXJjaC94ODYva2VybmVs
L2NwdS9tdHJyL2dlbmVyaWMuYwpAQCAtMzc5LDYgKzM3OSw3IEBAIHN0YXRpYyB2b2lkIGdlbmVy
aWNfZ2V0X210cnIodW5zaWduZWQgaW50IHJlZywgdW5zaWduZWQgbG9uZyAqYmFzZSwKIAkJCSAg
ICAgdW5zaWduZWQgbG9uZyAqc2l6ZSwgbXRycl90eXBlICp0eXBlKQogewogCXVuc2lnbmVkIGlu
dCBtYXNrX2xvLCBtYXNrX2hpLCBiYXNlX2xvLCBiYXNlX2hpOworCXVuc2lnbmVkIGludCB0bXAs
IGhpOwogCiAJcmRtc3IoTVRSUnBoeXNNYXNrX01TUihyZWcpLCBtYXNrX2xvLCBtYXNrX2hpKTsK
IAlpZiAoKG1hc2tfbG8gJiAweDgwMCkgPT0gMCkgewpAQCAtMzkyLDggKzM5MywxOCBAQCBzdGF0
aWMgdm9pZCBnZW5lcmljX2dldF9tdHJyKHVuc2lnbmVkIGludCByZWcsIHVuc2lnbmVkIGxvbmcg
KmJhc2UsCiAJcmRtc3IoTVRSUnBoeXNCYXNlX01TUihyZWcpLCBiYXNlX2xvLCBiYXNlX2hpKTsK
IAogCS8qIFdvcmsgb3V0IHRoZSBzaGlmdGVkIGFkZHJlc3MgbWFzay4gKi8KLQltYXNrX2xvID0g
c2l6ZV9vcl9tYXNrIHwgbWFza19oaSA8PCAoMzIgLSBQQUdFX1NISUZUKQotCSAgICB8IG1hc2tf
bG8gPj4gUEFHRV9TSElGVDsKKwl0bXAgPSBtYXNrX2hpIDw8ICgzMiAtIFBBR0VfU0hJRlQpIHwg
bWFza19sbyA+PiBQQUdFX1NISUZUOworCW1hc2tfbG8gPSBzaXplX29yX21hc2sgfCB0bXA7CisJ
LyogZXhwZW5kIHRtcCB3aXRoIGhpZ2ggYml0cyB0byBhbGwgMXMqLworCWhpID0gZmxzKHRtcCk7
CisJaWYgKGhpID4gMCkgeworCQl0bXAgfD0gfigoMTw8KGhpIC0gMSkpIC0gMSk7CisKKwkJaWYg
KHRtcCAhPSBtYXNrX2xvKSB7CisJCQlXQVJOX09OKCJZb3UgQklPUyBtYXNrIHNldCBpcyB3cm9u
ZywgY29tcGxhaW4gdG8gdmVuZG9yXG4iKTsKKwkJCW1hc2tfbG8gPSB0bXA7CisJCX0KKwl9CiAK
IAkvKiBUaGlzIHdvcmtzIGNvcnJlY3RseSBpZiBzaXplIGlzIGEgcG93ZXIgb2YgdHdvLCBpLmUu
IGEKIAkgICBjb250aWd1b3VzIHJhbmdlLiAqLwo=
------=_Part_24880_6674366.1219375464274--
