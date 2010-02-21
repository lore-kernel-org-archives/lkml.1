Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab0BUJvR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 04:51:17 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:15270 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab0BUJvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 04:51:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VVwi4KWmipa72xcLlA2zGB1mRLxzynKmUdt+oRO3/9RiQoUEnraitvJFKs5ywltkDv
         31FLvTsSVmNH3Sd0M8e6+q/OE9kRBAm6v7fHQBrcOqiBzTW9mNE8V9EJVGoP1vC16Wn3
         j0o3Z6slMQpfYchYGkXzAu4A32l7yyjeBly50=
MIME-Version: 1.0
In-Reply-To: <1266674268.18465.6.camel@jlt3.sipsolutions.net>
References: <1264740107.20211.53.camel@pasglop>
	 <1266485775.6539.6.camel@jlt3.sipsolutions.net>
	 <alpine.LFD.2.00.1002180825000.4141@localhost.localdomain>
	 <1266518735.3829.4.camel@jlt3.sipsolutions.net>
	 <2375c9f91002192313j3fb84acje4c286c4f86457f3@mail.gmail.com>
	 <1266656213.5347.0.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200106j56b0298ds1a425fde8983d988@mail.gmail.com>
	 <1266665331.12525.0.camel@jlt3.sipsolutions.net>
	 <20100220134447.GA3000@hack>
	 <1266674268.18465.6.camel@jlt3.sipsolutions.net>
Date: Sun, 21 Feb 2010 17:51:14 +0800
Message-ID: <2375c9f91002210151i6fe3f769k72a8a6a3485d8cf5@mail.gmail.com>
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: multipart/mixed; boundary=0016363b82cce3bc5104801941c7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016363b82cce3bc5104801941c7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 20, 2010 at 9:57 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2010-02-20 at 21:44 +0800, Am=C3=A9rico Wang wrote:
>
>> That message is displayed before shutting down the devices.
>>
>> To verify, you can add some printk() in the end of
>> __cpufreq_remove_dev(), or enable CONFIG_CPU_FREQ_DEBUG.
>
> That is already enabled.
>

Ok, I got it.

Could you test the patch below? Thanks!

----------------->

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

--0016363b82cce3bc5104801941c7
Content-Type: text/plain; charset=US-ASCII; name="drivers-cpufreq-fix-deadlock.diff"
Content-Disposition: attachment; 
	filename="drivers-cpufreq-fix-deadlock.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g5xnw8gd0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMgYi9kcml2ZXJzL2NwdWZyZXEv
Y3B1ZnJlcS5jCmluZGV4IDY3YmMyZWMuLmUxOTYwODQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY3B1
ZnJlcS9jcHVmcmVxLmMKKysrIGIvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEuYwpAQCAtMTExMyw2
ICsxMTEzLDggQEAgc3RhdGljIGludCBfX2NwdWZyZXFfcmVtb3ZlX2RldihzdHJ1Y3Qgc3lzX2Rl
dmljZSAqc3lzX2RldikKIAl1bnNpZ25lZCBpbnQgY3B1ID0gc3lzX2Rldi0+aWQ7CiAJdW5zaWdu
ZWQgbG9uZyBmbGFnczsKIAlzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKmRhdGE7CisJc3RydWN0IGtv
YmplY3QgKmtvYmo7CisJc3RydWN0IGNvbXBsZXRpb24gKmNtcDsKICNpZmRlZiBDT05GSUdfU01Q
CiAJc3RydWN0IHN5c19kZXZpY2UgKmNwdV9zeXNfZGV2OwogCXVuc2lnbmVkIGludCBqOwpAQCAt
MTE0MSwxMCArMTE0MywxMSBAQCBzdGF0aWMgaW50IF9fY3B1ZnJlcV9yZW1vdmVfZGV2KHN0cnVj
dCBzeXNfZGV2aWNlICpzeXNfZGV2KQogCQlkcHJpbnRrKCJyZW1vdmluZyBsaW5rXG4iKTsKIAkJ
Y3B1bWFza19jbGVhcl9jcHUoY3B1LCBkYXRhLT5jcHVzKTsKIAkJc3Bpbl91bmxvY2tfaXJxcmVz
dG9yZSgmY3B1ZnJlcV9kcml2ZXJfbG9jaywgZmxhZ3MpOwotCQlzeXNmc19yZW1vdmVfbGluaygm
c3lzX2Rldi0+a29iaiwgImNwdWZyZXEiKTsKKwkJa29iaiA9ICZzeXNfZGV2LT5rb2JqOwogCQlj
cHVmcmVxX2NwdV9wdXQoZGF0YSk7CiAJCWNwdWZyZXFfZGVidWdfZW5hYmxlX3JhdGVsaW1pdCgp
OwogCQl1bmxvY2tfcG9saWN5X3J3c2VtX3dyaXRlKGNwdSk7CisJCXN5c2ZzX3JlbW92ZV9saW5r
KGtvYmosICJjcHVmcmVxIik7CiAJCXJldHVybiAwOwogCX0KICNlbmRpZgpAQCAtMTE4MSw3ICsx
MTg0LDEwIEBAIHN0YXRpYyBpbnQgX19jcHVmcmVxX3JlbW92ZV9kZXYoc3RydWN0IHN5c19kZXZp
Y2UgKnN5c19kZXYpCiAJCQkJZGF0YS0+Z292ZXJub3ItPm5hbWUsIENQVUZSRVFfTkFNRV9MRU4p
OwogI2VuZGlmCiAJCQljcHVfc3lzX2RldiA9IGdldF9jcHVfc3lzZGV2KGopOwotCQkJc3lzZnNf
cmVtb3ZlX2xpbmsoJmNwdV9zeXNfZGV2LT5rb2JqLCAiY3B1ZnJlcSIpOworCQkJa29iaiA9ICZj
cHVfc3lzX2Rldi0+a29iajsKKwkJCXVubG9ja19wb2xpY3lfcndzZW1fd3JpdGUoY3B1KTsKKwkJ
CXN5c2ZzX3JlbW92ZV9saW5rKGtvYmosICJjcHVmcmVxIik7CisJCQlsb2NrX3BvbGljeV9yd3Nl
bV93cml0ZShjcHUpOwogCQkJY3B1ZnJlcV9jcHVfcHV0KGRhdGEpOwogCQl9CiAJfQpAQCAtMTE5
MiwxOSArMTE5OCwyMiBAQCBzdGF0aWMgaW50IF9fY3B1ZnJlcV9yZW1vdmVfZGV2KHN0cnVjdCBz
eXNfZGV2aWNlICpzeXNfZGV2KQogCWlmIChjcHVmcmVxX2RyaXZlci0+dGFyZ2V0KQogCQlfX2Nw
dWZyZXFfZ292ZXJub3IoZGF0YSwgQ1BVRlJFUV9HT1ZfU1RPUCk7CiAKLQlrb2JqZWN0X3B1dCgm
ZGF0YS0+a29iaik7CisJa29iaiA9ICZkYXRhLT5rb2JqOworCWNtcCA9ICZkYXRhLT5rb2JqX3Vu
cmVnaXN0ZXI7CisJdW5sb2NrX3BvbGljeV9yd3NlbV93cml0ZShjcHUpOworCWtvYmplY3RfcHV0
KGtvYmopOwogCiAJLyogd2UgbmVlZCB0byBtYWtlIHN1cmUgdGhhdCB0aGUgdW5kZXJseWluZyBr
b2JqIGlzIGFjdHVhbGx5CiAJICogbm90IHJlZmVyZW5jZWQgYW55bW9yZSBieSBhbnlib2R5IGJl
Zm9yZSB3ZSBwcm9jZWVkIHdpdGgKIAkgKiB1bmxvYWRpbmcuCiAJICovCiAJZHByaW50aygid2Fp
dGluZyBmb3IgZHJvcHBpbmcgb2YgcmVmY291bnRcbiIpOwotCXdhaXRfZm9yX2NvbXBsZXRpb24o
JmRhdGEtPmtvYmpfdW5yZWdpc3Rlcik7CisJd2FpdF9mb3JfY29tcGxldGlvbihjbXApOwogCWRw
cmludGsoIndhaXQgY29tcGxldGVcbiIpOwogCisJbG9ja19wb2xpY3lfcndzZW1fd3JpdGUoY3B1
KTsKIAlpZiAoY3B1ZnJlcV9kcml2ZXItPmV4aXQpCiAJCWNwdWZyZXFfZHJpdmVyLT5leGl0KGRh
dGEpOwotCiAJdW5sb2NrX3BvbGljeV9yd3NlbV93cml0ZShjcHUpOwogCiAJZnJlZV9jcHVtYXNr
X3ZhcihkYXRhLT5yZWxhdGVkX2NwdXMpOwo=
--0016363b82cce3bc5104801941c7--
