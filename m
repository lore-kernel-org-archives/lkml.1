Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbZKUSE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbZKUSE1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 13:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756666AbZKUSE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 13:04:26 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:33503 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648AbZKUSEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 13:04:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UBeYndHMwMw4ad9dQl827fz5ltnav4izaQsDYDAxxH8QBrvCyYAcCegx4OQe3U0gmt
         frwEJsOtCC1iKAziVx185YQX179vB5POmnsL6PU71WJMbCLWZ+WB4qTu1+SyPDZ6DGxU
         JYc/TskRHyBL+qk5W5+3t7gbQVRb9qdVvpiAI=
MIME-Version: 1.0
In-Reply-To: <4e5e476b0911201150p7cbdfc20k4b8d02f07e16abc8@mail.gmail.com>
References: <20091116221827.GL13235@redhat.com>
	 <4e5e476b0911180820y5d99a81et6be7f6f94442d0d5@mail.gmail.com>
	 <20091118225626.GA2974@redhat.com>
	 <4e5e476b0911181535y4d73d381s14b54c6d787d2b46@mail.gmail.com>
	 <20091120141840.GA5872@redhat.com>
	 <4e5e476b0911200628g42a0ab6ftd65b68bff5d1aea3@mail.gmail.com>
	 <20091120150421.GC5872@redhat.com>
	 <4e5e476b0911201032j5319b012v5fd0a64ebfe11089@mail.gmail.com>
	 <20091120184257.GG5872@redhat.com>
	 <4e5e476b0911201150p7cbdfc20k4b8d02f07e16abc8@mail.gmail.com>
Date: Sat, 21 Nov 2009 18:57:47 +0100
Message-ID: <4e5e476b0911210957g5b099329u33fa6ec4d740f7d1@mail.gmail.com>
Subject: Re: [RFC] Block IO Controller V2 - some results
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Content-Type: multipart/mixed; boundary=001636c9283383643d0478e554aa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636c9283383643d0478e554aa
Content-Type: text/plain; charset=UTF-8

Hi Vivek,
On Fri, Nov 20, 2009 at 8:50 PM, Corrado Zoccolo <czoccolo@gmail.com> wrote:
> On Fri, Nov 20, 2009 at 7:42 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>
>> Should we also take into account the "cfqq->dispatched" request in
>> determining whether we should enable idling on deep queue random seeky
>> readers?
>
> Probably, but I think the most important thing is to do some averaging
> or hysteresis, so the completion of a single request doesn't cause the
> switch of a workload.

can you test the new version of the idling patch?
I register the fact that the queue had a large depth in a flag, that
is reset only when the idle times out (so at the end of the burst).
Idling is enabled if that flag is set (and think time is acceptable).
This should fix the switching behaviour you observed.

I decided to not count cfqq->dispatched to determine the depth.
In this way, when all queues in the system are random the idling is
enabled only if the requests queue builds up faster than it can be
consumed.

Thanks,
Corrado

--001636c9283383643d0478e554aa
Content-Type: application/octet-stream; 
	name="0002-cfq-iosched-idling-on-deep-seeky-sync-queues.patch"
Content-Disposition: attachment; 
	filename="0002-cfq-iosched-idling-on-deep-seeky-sync-queues.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g2aocnxm0

RnJvbSAwMGZkMjIxYWIxNmE0ZWI1OTdkZmY1YjIzZjA2M2U1NDNmNWQ5OWI4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBDb3JyYWRvIFpvY2NvbG8gPGNvcnJhZG9AZXQyLihub25lKT4K
RGF0ZTogRnJpLCAyMCBOb3YgMjAwOSAxNDo1NTo1NCArMDEwMApTdWJqZWN0OiBbUEFUQ0ggMi8y
XSBjZnEtaW9zY2hlZDogaWRsaW5nIG9uIGRlZXAgc2Vla3kgc3luYyBxdWV1ZXMKClNlZWt5IHN5
bmMgcXVldWVzIHdpdGggbGFyZ2UgZGVwdGggY2FuIGdhaW4gdW5mYWlybHkgYmlnIHNoYXJlIG9m
IGRpc2sKdGltZSwgYXQgdGhlIGV4cGVuc2Ugb2Ygb3RoZXIgc2Vla3kgcXVldWVzLiBUaGlzIHBh
dGNoIGVuc3VyZXMgdGhhdAppZGxpbmcgd2lsbCBiZSBlbmFibGVkIGZvciBxdWV1ZXMgd2l0aCBJ
L08gZGVwdGggYXQgbGVhc3QgNCwgYW5kIHNtYWxsCnRoaW5rIHRpbWUuIFRoZSBkZWNpc2lvbiB0
byBlbmFibGUgaWRsaW5nIGlzIHN0aWNreSwgdW50aWwgYW4gaWRsZQp3aW5kb3cgdGltZXMgb3V0
IHdpdGhvdXQgc2VlaW5nIG5ldyByZXF1ZXN0LgoKVGhlIHJlYXNvbmluZyBiZWhpbmQgdGhlIGRl
Y2lzaW9uIGlzIHRoYXQsIGlmIGFuIGFwcGxpY2F0aW9uIGlzIHVzaW5nCmxhcmdlIEkvTyBkZXB0
aCwgaXQgaXMgYWxyZWFkeSBvcHRpbWl6ZWQgdG8gbWFrZSBmdWxsIHV0aWxpemF0aW9uIG9mCnRo
ZSBoYXJkd2FyZSwgYW5kIHRoZXJlZm9yZSB3ZSByZXNlcnZlIGEgc2xpY2Ugb2YgZXhjbHVzaXZl
IHVzZSBmb3IgaXQuCgpTaWduZWQtb2ZmLWJ5OiBDb3JyYWRvIFpvY2NvbG8gPGN6b2Njb2xvQGdt
YWlsLmNvbT4KLS0tCiBibG9jay9jZnEtaW9zY2hlZC5jIHwgICAxMyArKysrKysrKysrKystCiAx
IGZpbGVzIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvYmxvY2svY2ZxLWlvc2NoZWQuYyBiL2Jsb2NrL2NmcS1pb3NjaGVkLmMKaW5kZXggMmEz
MDRmNC4uMzczZTgwZiAxMDA2NDQKLS0tIGEvYmxvY2svY2ZxLWlvc2NoZWQuYworKysgYi9ibG9j
ay9jZnEtaW9zY2hlZC5jCkBAIC0yNjAsNiArMjYwLDcgQEAgZW51bSBjZnFxX3N0YXRlX2ZsYWdz
IHsKIAlDRlFfQ0ZRUV9GTEFHX3NsaWNlX25ldywJLyogbm8gcmVxdWVzdHMgZGlzcGF0Y2hlZCBp
biBzbGljZSAqLwogCUNGUV9DRlFRX0ZMQUdfc3luYywJCS8qIHN5bmNocm9ub3VzIHF1ZXVlICov
CiAJQ0ZRX0NGUVFfRkxBR19jb29wLAkJLyogY2ZxcSBpcyBzaGFyZWQgKi8KKwlDRlFfQ0ZRUV9G
TEFHX2RlZXAsCQkvKiBzeW5jIGNmcXEgZXhwZXJpZW5jZWQgbGFyZ2UgZGVwdGggKi8KIH07CiAK
ICNkZWZpbmUgQ0ZRX0NGUVFfRk5TKG5hbWUpCQkJCQkJXApAQCAtMjg2LDYgKzI4Nyw3IEBAIENG
UV9DRlFRX0ZOUyhwcmlvX2NoYW5nZWQpOwogQ0ZRX0NGUVFfRk5TKHNsaWNlX25ldyk7CiBDRlFf
Q0ZRUV9GTlMoc3luYyk7CiBDRlFfQ0ZRUV9GTlMoY29vcCk7CitDRlFfQ0ZRUV9GTlMoZGVlcCk7
CiAjdW5kZWYgQ0ZRX0NGUVFfRk5TCiAKICNkZWZpbmUgY2ZxX2xvZ19jZnFxKGNmcWQsIGNmcXEs
IGZtdCwgYXJncy4uLikJXApAQCAtMjM1OSw4ICsyMzYxLDEyIEBAIGNmcV91cGRhdGVfaWRsZV93
aW5kb3coc3RydWN0IGNmcV9kYXRhICpjZnFkLCBzdHJ1Y3QgY2ZxX3F1ZXVlICpjZnFxLAogCiAJ
ZW5hYmxlX2lkbGUgPSBvbGRfaWRsZSA9IGNmcV9jZnFxX2lkbGVfd2luZG93KGNmcXEpOwogCisJ
aWYgKGNmcXEtPnF1ZXVlZFswXSArIGNmcXEtPnF1ZXVlZFsxXSA+PSA0KQorCQljZnFfbWFya19j
ZnFxX2RlZXAoY2ZxcSk7CisKIAlpZiAoIWF0b21pY19yZWFkKCZjaWMtPmlvYy0+bnJfdGFza3Mp
IHx8ICFjZnFkLT5jZnFfc2xpY2VfaWRsZSB8fAotCSAgICAoc2FtcGxlX3ZhbGlkKGNmcXEtPnNl
ZWtfc2FtcGxlcykgJiYgQ0ZRUV9TRUVLWShjZnFxKSkpCisJICAgICghY2ZxX2NmcXFfZGVlcChj
ZnFxKSAmJiBzYW1wbGVfdmFsaWQoY2ZxcS0+c2Vla19zYW1wbGVzKQorCSAgICAgJiYgQ0ZRUV9T
RUVLWShjZnFxKSkpCiAJCWVuYWJsZV9pZGxlID0gMDsKIAllbHNlIGlmIChzYW1wbGVfdmFsaWQo
Y2ljLT50dGltZV9zYW1wbGVzKSkgewogCQlpZiAoY2ljLT50dGltZV9tZWFuID4gY2ZxZC0+Y2Zx
X3NsaWNlX2lkbGUpCkBAIC0yODU4LDYgKzI4NjQsMTEgQEAgc3RhdGljIHZvaWQgY2ZxX2lkbGVf
c2xpY2VfdGltZXIodW5zaWduZWQgbG9uZyBkYXRhKQogCQkgKi8KIAkJaWYgKCFSQl9FTVBUWV9S
T09UKCZjZnFxLT5zb3J0X2xpc3QpKQogCQkJZ290byBvdXRfa2ljazsKKworCQkvKgorCQkgKiBR
dWV1ZSBkZXB0aCBmbGFnIGlzIHJlc2V0IG9ubHkgd2hlbiB0aGUgaWRsZSBkaWRuJ3Qgc3VjY2Vl
ZAorCQkgKi8KKwkJY2ZxX2NsZWFyX2NmcXFfZGVlcChjZnFxKTsKIAl9CiBleHBpcmU6CiAJY2Zx
X3NsaWNlX2V4cGlyZWQoY2ZxZCwgdGltZWRfb3V0KTsKLS0gCjEuNi4yLjUKCg==
--001636c9283383643d0478e554aa--
