Return-Path: <linux-kernel-owner+w=401wt.eu-S1758473AbXIQUzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbXIQUzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754967AbXIQUzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:55:37 -0400
Received: from pils.linux-kernel.at ([213.129.242.82]:22691 "EHLO
	mail.linux-kernel.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbXIQUzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:55:36 -0400
Message-ID: <46EEE8C1.5040506@linux-kernel.at>
Date: Mon, 17 Sep 2007 22:51:13 +0200
From: Oliver Falk <oliver@linux-kernel.at>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Linux on Alpha processors <axp-list@redhat.com>
CC: linux-kernel@vger.kernel.org, Jay Estabrook <jay.estabrook@hp.com>,
       ac-admin@lists.anotherbloody.com
Subject: Re: 2.6.23 alpha unistd.h changes
References: <46EEE483.4020209@linux-kernel.at>
In-Reply-To: <46EEE483.4020209@linux-kernel.at>
Content-Type: multipart/mixed;
 boundary="------------070706080706090801000000"
X-lkernAT-MailScanner-Information: Please contact the ISP for more information
X-lkernAT-MailScanner: Found to be clean
X-lkernAT-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-4.399, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -2.60)
X-MailScanner-From: oliver@linux-kernel.at
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070706080706090801000000
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Oliver Falk schrieb:
> Hi!
> 
> At Alphacore we used to patch the kernel headers for a while now; We
> added syscalls __NR_openat (447) until __NR_tee (466).
> 
> However, since 2.6.23 these syscall where added upstream, but with
> different syscall numbers; What happens is the following:
> 
> * glibc 2.6.90 compiled with 2.6.23 headers installed
> * kernel 2.6.21 (our patched headers in place, different syscall
> 'ordering'/numbers) installed
> 
> [root@tyskie ~]# uname -r; touch x; rm -f x
> 2.6.23-0.145.rc4.fc8
> rm: cannot remove `x': File exists
> 
> :-( I don't want to live without rm :-P and chmod doesn't work as well...
> 
> If I start 2.6.15, where these syscalls where not in place, it works
> just fine. If I install old glibc 2.6 (compiled against 2.6.21 headers)
> and kernel 2.6.21 also everything is fine.
> 
> Final test was now:
> * Boot kernel 2.6.23 and glibc 2.6.90 (compiled against 2.6.23 headers),
> also everything seems to work.
> 
> As these additions are quite new to upstream kernel, but at Alphacore we
> have patched it since a while now (I don't know about other Alpha ports;
> Debian folks may speak up now!), I would suggest to use the same
> 'ordering' of the syscalls upstream and add the new syscalls that we had
> not in place, but are now upstream to the end of our 'old' list.
> 
> I have attached our patch that we used for 2.6.21.
> 
> 
> Please let me know if that's fine everyone and keep me posted directly
> and only via m/l, as I might miss the mail then...

Attached patch should bring ordering back to what we had at AC.
systbls.S should be ordered as well, but from functional perspective, I
don't worry about that for now :-P

-of

--------------070706080706090801000000
Content-Type: application/octet-stream;
 name="unistd.h.old_syscall_ordering.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="unistd.h.old_syscall_ordering.patch"

LS0tIHVuaXN0ZC5oLm9sZF9zeXNjYWxsX29yZGVyaW5nCTIwMDctMDktMTcgMjI6Mzc6MTEu
MDAwMDAwMDAwICswMjAwCisrKyB1bmlzdGQuaAkyMDA3LTA5LTE3IDIyOjQyOjA2LjAwMDAw
MDAwMCArMDIwMApAQCAtNDAxLDMwICs0MDEsMzAgQEAKICNkZWZpbmUgX19OUl9pbm90aWZ5
X2luaXQJCTQ0NAogI2RlZmluZSBfX05SX2lub3RpZnlfYWRkX3dhdGNoCQk0NDUKICNkZWZp
bmUgX19OUl9pbm90aWZ5X3JtX3dhdGNoCQk0NDYKLSNkZWZpbmUgX19OUl9mZGF0YXN5bmMJ
CQk0NDcKLSNkZWZpbmUgX19OUl9rZXhlY19sb2FkCQkJNDQ4Ci0jZGVmaW5lIF9fTlJfbWln
cmF0ZV9wYWdlcwkJNDQ5Ci0jZGVmaW5lIF9fTlJfb3BlbmF0CQkJNDUwCi0jZGVmaW5lIF9f
TlJfbWtkaXJhdAkJCTQ1MQotI2RlZmluZSBfX05SX21rbm9kYXQJCQk0NTIKLSNkZWZpbmUg
X19OUl9mY2hvd25hdAkJCTQ1MwotI2RlZmluZSBfX05SX2Z1dGltZXNhdAkJCTQ1NAotI2Rl
ZmluZSBfX05SX2ZzdGF0YXQ2NAkJCTQ1NQotI2RlZmluZSBfX05SX3VubGlua2F0CQkJNDU2
Ci0jZGVmaW5lIF9fTlJfcmVuYW1lYXQJCQk0NTcKLSNkZWZpbmUgX19OUl9saW5rYXQJCQk0
NTgKLSNkZWZpbmUgX19OUl9zeW1saW5rYXQJCQk0NTkKLSNkZWZpbmUgX19OUl9yZWFkbGlu
a2F0CQkJNDYwCi0jZGVmaW5lIF9fTlJfZmNobW9kYXQJCQk0NjEKLSNkZWZpbmUgX19OUl9m
YWNjZXNzYXQJCQk0NjIKLSNkZWZpbmUgX19OUl9wc2VsZWN0NgkJCTQ2MwotI2RlZmluZSBf
X05SX3Bwb2xsCQkJNDY0Ci0jZGVmaW5lIF9fTlJfdW5zaGFyZQkJCTQ2NQotI2RlZmluZSBf
X05SX3NldF9yb2J1c3RfbGlzdAkJNDY2Ci0jZGVmaW5lIF9fTlJfZ2V0X3JvYnVzdF9saXN0
CQk0NjcKLSNkZWZpbmUgX19OUl9zcGxpY2UJCQk0NjgKLSNkZWZpbmUgX19OUl9zeW5jX2Zp
bGVfcmFuZ2UJCTQ2OQotI2RlZmluZSBfX05SX3RlZQkJCTQ3MAorI2RlZmluZSBfX05SX29w
ZW5hdAkJCTQ0NworI2RlZmluZSBfX05SX21rZGlyYXQJCQk0NDgKKyNkZWZpbmUgX19OUl9t
a25vZGF0CQkJNDQ5CisjZGVmaW5lIF9fTlJfZmNob3duYXQJCQk0NTAKKyNkZWZpbmUgX19O
Ul9mdXRpbWVzYXQJCQk0NTEKKyNkZWZpbmUgX19OUl91bmxpbmthdAkJCTQ1MgorI2RlZmlu
ZSBfX05SX3JlbmFtZWF0CQkJNDUzCisjZGVmaW5lIF9fTlJfbGlua2F0CQkJNDU0CisjZGVm
aW5lIF9fTlJfc3ltbGlua2F0CQkJNDU1CisjZGVmaW5lIF9fTlJfcmVhZGxpbmthdAkJCTQ1
NgorI2RlZmluZSBfX05SX2ZjaG1vZGF0CQkJNDU3CisjZGVmaW5lIF9fTlJfZmFjY2Vzc2F0
CQkJNDU4CisjZGVmaW5lIF9fTlJfcHNlbGVjdDYJCQk0NTkKKyNkZWZpbmUgX19OUl9wcG9s
bAkJCTQ2MAorI2RlZmluZSBfX05SX3Vuc2hhcmUJCQk0NjEKKyNkZWZpbmUgX19OUl9zZXRf
cm9idXN0X2xpc3QJCTQ2MgorI2RlZmluZSBfX05SX2dldF9yb2J1c3RfbGlzdAkJNDYzCisj
ZGVmaW5lIF9fTlJfc3BsaWNlCQkJNDY0CisjZGVmaW5lIF9fTlJfc3luY19maWxlX3Jhbmdl
CQk0NjUKKyNkZWZpbmUgX19OUl90ZWUJCQk0NjYKKyNkZWZpbmUgX19OUl9mZGF0YXN5bmMJ
CQk0NjcKKyNkZWZpbmUgX19OUl9rZXhlY19sb2FkCQkJNDY4CisjZGVmaW5lIF9fTlJfbWln
cmF0ZV9wYWdlcwkJNDY5CisjZGVmaW5lIF9fTlJfZnN0YXRhdDY0CQkJNDcwCiAjZGVmaW5l
IF9fTlJfdm1zcGxpY2UJCQk0NzEKICNkZWZpbmUgX19OUl9tb3ZlX3BhZ2VzCQkJNDcyCiAj
ZGVmaW5lIF9fTlJfZ2V0Y3B1CQkJNDczCg==
--------------070706080706090801000000--
