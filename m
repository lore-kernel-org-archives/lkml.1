Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbYLSKC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbYLSKC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 05:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbYLSKCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 05:02:48 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:32279 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbYLSKCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 05:02:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=qym38yUfe02+VlCUcfejfuWs2jDQkoo/JVo2PV9+o7Wn+Rkqc7o3Yt/osLV643+tJk
         Th/RMMhLy/0DNDiO70Jhj5PshTz5P0Y8OQ+q+qhDLFEF3fgBPHbDSMHdvy6JNK11dChf
         mw57FMy2HbEuAs7mz69wuokduRySwi3uUnP5s=
Message-ID: <aec7e5c30812190202g44020d6ao910f93264e7ccaaa@mail.gmail.com>
Date: Fri, 19 Dec 2008 19:02:46 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] clocksource: pass clocksource to read() callback
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
In-Reply-To: <20081219001121.bf985802.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_34503_3146266.1229680966342"
References: <20081211114802.17622.54609.sendpatchset@rx1.opensource.se>
	 <20081217175658.0706a07f.akpm@linux-foundation.org>
	 <aec7e5c30812182330u6e907867i971396923c167ddf@mail.gmail.com>
	 <20081218234725.4126d858.akpm@linux-foundation.org>
	 <20081219001121.bf985802.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_34503_3146266.1229680966342
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, Dec 19, 2008 at 5:11 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> It still blows up though.  Any call to get_cycles() goes:
>
> crypto/tcrypt.c: In function `test_cipher_cycles':
> crypto/tcrypt.c:107: error: too few arguments to function
> crypto/tcrypt.c:112: error: too few arguments to function
> crypto/tcrypt.c: In function `test_hash_cycles_digest':
> crypto/tcrypt.c:305: error: too few arguments to function
> crypto/tcrypt.c:311: error: too few arguments to function
> crypto/tcrypt.c: In function `test_hash_cycles':
> crypto/tcrypt.c:361: error: too few arguments to function
> crypto/tcrypt.c:375: error: too few arguments to function
>
> because this:
>
> arch/sparc/include/asm/timex_64.h:#define get_cycles()  tick_ops->get_tick()
>
> needs help.

Thanks for your help. I've now managed to build a sparc64 compiler and
make a fix. If it's ok with Dave then I think reverting the old
sparc64 hunks and go with a simple wrapper is the best, see the
attached patch.

/ magnus

------=_Part_34503_3146266.1229680966342
Content-Type: application/octet-stream;
 name=clocksource-pass-clocksource-to-read-callback-sparc64-fix-replacement.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fowo76um0
Content-Disposition: attachment;
 filename=clocksource-pass-clocksource-to-read-callback-sparc64-fix-replacement.patch

RnJvbTogTWFnbnVzIERhbW0gPGRhbW1AaWdlbC5jby5qcD4KClRoaXMgdW5icmVha3MgY2xvY2tz
b3VyY2UgcmVhZChjcykgb24gc3BhcmM2NC4gVGhlIG9sZCBzcGFyYzY0IGNvZGUgZ2V0cwpyZXZl
cnRlZCBhbmQgYSBzaW1wbGUgd3JhcHBlciBmdW5jdGlvbiBpcyB1c2VkIGluc3RlYWQuCgpTaWdu
ZWQtb2ZmLWJ5OiBNYWdudXMgRGFtbSA8ZGFtbUBpZ2VsLmNvLmpwPgotLS0KCiBhcmNoL3NwYXJj
L2luY2x1ZGUvYXNtL3RpbWVyXzY0LmggfCAgICAzICstLQogYXJjaC9zcGFyYy9rZXJuZWwvdGlt
ZV82NC5jICAgICAgIHwgICAyMSArKysrKysrKysrKysrLS0tLS0tLS0KIDIgZmlsZXMgY2hhbmdl
ZCwgMTQgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRpb25zKC0pCgotLS0gMDAwMi9hcmNoL3NwYXJj
L2luY2x1ZGUvYXNtL3RpbWVyXzY0LmgKKysrIHdvcmsvYXJjaC9zcGFyYy9pbmNsdWRlL2FzbS90
aW1lcl82NC5oCTIwMDgtMTItMTkgMTg6NTQ6NTguMDAwMDAwMDAwICswOTAwCkBAIC04LDEwICs4
LDkgQEAKIAogI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+CiAjaW5jbHVkZSA8bGludXgvaW5pdC5o
PgotI2luY2x1ZGUgPGxpbnV4L2Nsb2Nrc291cmNlLmg+CiAKIHN0cnVjdCBzcGFyYzY0X3RpY2tf
b3BzIHsKLQl1bnNpZ25lZCBsb25nICgqZ2V0X3RpY2spKHN0cnVjdCBjbG9ja3NvdXJjZSAqY3Mp
OworCXVuc2lnbmVkIGxvbmcgKCpnZXRfdGljaykodm9pZCk7CiAJaW50ICgqYWRkX2NvbXBhcmUp
KHVuc2lnbmVkIGxvbmcpOwogCXVuc2lnbmVkIGxvbmcgc29mdGludF9tYXNrOwogCXZvaWQgKCpk
aXNhYmxlX2lycSkodm9pZCk7Ci0tLSAwMDAyL2FyY2gvc3BhcmMva2VybmVsL3RpbWVfNjQuYwor
Kysgd29yay9hcmNoL3NwYXJjL2tlcm5lbC90aW1lXzY0LmMJMjAwOC0xMi0xOSAxODo1NDo1OC4w
MDAwMDAwMDAgKzA5MDAKQEAgLTEwNiw3ICsxMDYsNyBAQCBzdGF0aWMgdm9pZCB0aWNrX2luaXRf
dGljayh2b2lkKQogCXRpY2tfZGlzYWJsZV9pcnEoKTsKIH0KIAotc3RhdGljIHVuc2lnbmVkIGxv
bmcgdGlja19nZXRfdGljayhzdHJ1Y3QgY2xvY2tzb3VyY2UgKmNzKQorc3RhdGljIHVuc2lnbmVk
IGxvbmcgdGlja19nZXRfdGljayh2b2lkKQogewogCXVuc2lnbmVkIGxvbmcgcmV0OwogCkBAIC0y
MDgsNyArMjA4LDcgQEAgc3RhdGljIHZvaWQgc3RpY2tfaW5pdF90aWNrKHZvaWQpCiAJc3RpY2tf
ZGlzYWJsZV9pcnEoKTsKIH0KIAotc3RhdGljIHVuc2lnbmVkIGxvbmcgc3RpY2tfZ2V0X3RpY2so
c3RydWN0IGNsb2Nrc291cmNlICpjcykKK3N0YXRpYyB1bnNpZ25lZCBsb25nIHN0aWNrX2dldF90
aWNrKHZvaWQpCiB7CiAJdW5zaWduZWQgbG9uZyByZXQ7CiAKQEAgLTM1Miw3ICszNTIsNyBAQCBz
dGF0aWMgdm9pZCBoYnRpY2tfaW5pdF90aWNrKHZvaWQpCiAJaGJ0aWNrX2Rpc2FibGVfaXJxKCk7
CiB9CiAKLXN0YXRpYyB1bnNpZ25lZCBsb25nIGhidGlja19nZXRfdGljayhzdHJ1Y3QgY2xvY2tz
b3VyY2UgKmNzKQorc3RhdGljIHVuc2lnbmVkIGxvbmcgaGJ0aWNrX2dldF90aWNrKHZvaWQpCiB7
CiAJcmV0dXJuIF9faGJpcmRfcmVhZF9zdGljaygpICYgflRJQ0tfUFJJVl9CSVQ7CiB9CkBAIC03
OTksOSArNzk5LDkgQEAgdm9pZCBfX2RlbGF5KHVuc2lnbmVkIGxvbmcgbG9vcHMpCiB7CiAJdW5z
aWduZWQgbG9uZyBiY2xvY2ssIG5vdzsKIAotCWJjbG9jayA9IHRpY2tfb3BzLT5nZXRfdGljaygm
Y2xvY2tzb3VyY2VfdGljayk7CisJYmNsb2NrID0gdGlja19vcHMtPmdldF90aWNrKCk7CiAJZG8g
ewotCQlub3cgPSB0aWNrX29wcy0+Z2V0X3RpY2soJmNsb2Nrc291cmNlX3RpY2spOworCQlub3cg
PSB0aWNrX29wcy0+Z2V0X3RpY2soKTsKIAl9IHdoaWxlICgobm93LWJjbG9jaykgPCBsb29wcyk7
CiB9CiBFWFBPUlRfU1lNQk9MKF9fZGVsYXkpOwpAQCAtODEyLDYgKzgxMiwxMSBAQCB2b2lkIHVk
ZWxheSh1bnNpZ25lZCBsb25nIHVzZWNzKQogfQogRVhQT1JUX1NZTUJPTCh1ZGVsYXkpOwogCitz
dGF0aWMgY3ljbGVfdCBjbG9ja3NvdXJjZV90aWNrX3JlYWQoc3RydWN0IGNsb2Nrc291cmNlICpj
cykKK3sKKwlyZXR1cm4gdGlja19vcHMtPmdldF90aWNrKCk7Cit9CisKIHZvaWQgX19pbml0IHRp
bWVfaW5pdCh2b2lkKQogewogCXVuc2lnbmVkIGxvbmcgZnJlcSA9IHNwYXJjNjRfaW5pdF90aW1l
cnMoKTsKQEAgLTgyNSw3ICs4MzAsNyBAQCB2b2lkIF9faW5pdCB0aW1lX2luaXQodm9pZCkKIAlj
bG9ja3NvdXJjZV90aWNrLm11bHQgPQogCQljbG9ja3NvdXJjZV9oejJtdWx0KGZyZXEsCiAJCQkJ
ICAgIGNsb2Nrc291cmNlX3RpY2suc2hpZnQpOwotCWNsb2Nrc291cmNlX3RpY2sucmVhZCA9IHRp
Y2tfb3BzLT5nZXRfdGljazsKKwljbG9ja3NvdXJjZV90aWNrLnJlYWQgPSBjbG9ja3NvdXJjZV90
aWNrX3JlYWQ7CiAKIAlwcmludGsoImNsb2Nrc291cmNlOiBtdWx0WyV4XSBzaGlmdFslZF1cbiIs
CiAJICAgICAgIGNsb2Nrc291cmNlX3RpY2subXVsdCwgY2xvY2tzb3VyY2VfdGljay5zaGlmdCk7
CkBAIC04NDksNyArODU0LDcgQEAgdm9pZCBfX2luaXQgdGltZV9pbml0KHZvaWQpCiAKIHVuc2ln
bmVkIGxvbmcgbG9uZyBzY2hlZF9jbG9jayh2b2lkKQogewotCXVuc2lnbmVkIGxvbmcgdGlja3Mg
PSB0aWNrX29wcy0+Z2V0X3RpY2soJmNsb2Nrc291cmNlX3RpY2spOworCXVuc2lnbmVkIGxvbmcg
dGlja3MgPSB0aWNrX29wcy0+Z2V0X3RpY2soKTsKIAogCXJldHVybiAodGlja3MgKiB0aW1lcl90
aWNrc19wZXJfbnNlY19xdW90aWVudCkKIAkJPj4gU1BBUkM2NF9OU0VDX1BFUl9DWUNfU0hJRlQ7
CkBAIC04NTcsNiArODYyLDYgQEAgdW5zaWduZWQgbG9uZyBsb25nIHNjaGVkX2Nsb2NrKHZvaWQp
CiAKIGludCBfX2RldmluaXQgcmVhZF9jdXJyZW50X3RpbWVyKHVuc2lnbmVkIGxvbmcgKnRpbWVy
X3ZhbCkKIHsKLQkqdGltZXJfdmFsID0gdGlja19vcHMtPmdldF90aWNrKCZjbG9ja3NvdXJjZV90
aWNrKTsKKwkqdGltZXJfdmFsID0gdGlja19vcHMtPmdldF90aWNrKCk7CiAJcmV0dXJuIDA7CiB9
Cg==
------=_Part_34503_3146266.1229680966342--
