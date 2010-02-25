Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab0BYG71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 01:59:27 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:4091 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424Ab0BYG7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 01:59:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nTyPkcFFF0q8k6vXYaR59/3Hs1ERWpkFuMJNGBvnsW/7ivXGXpEWSLdTER9++9w3SY
         MTPRyO1g5heYB+eynZtlmD+dQ3jKy6RiRCJJOJbJhIdodAngbBqahhYSI8Hz+G3XoL0N
         E0WiXIC3djqN9DPinKZYrwPdYkqS//ER24WcU=
MIME-Version: 1.0
In-Reply-To: <2375c9f91002242025n1ab73e18i5950aa4f14ea36db@mail.gmail.com>
References: <cover.1266907495.git.andre.goddard@gmail.com>
	 <a3a62a6cd7cc0ba011949396a1f2c7f9c32aa4b9.1266907496.git.andre.goddard@gmail.com>
	 <2375c9f91002241935k56dff805q57582d998b660889@mail.gmail.com>
	 <7b6bb4a51002242000x49f0b3bdncb40912bf18f90bb@mail.gmail.com>
	 <2375c9f91002242025n1ab73e18i5950aa4f14ea36db@mail.gmail.com>
Date: Thu, 25 Feb 2010 14:59:24 +0800
Message-ID: <2375c9f91002242259n2fabb190ic77d6ca603bd1df7@mail.gmail.com>
Subject: Re: [PATCH 6/6] mqueue: fix mq_open() file descriptor leak on 
	user-space processes
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: =?UTF-8?Q?Andr=C3=A9_Goddard_Rosa?= <andre.goddard@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Serge E . Hallyn" <serue@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016364eee10b7febc0480675266
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016364eee10b7febc0480675266
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 25, 2010 at 12:25 PM, Am=C3=A9rico Wang <xiyou.wangcong@gmail.c=
om> wrote:
> On Thu, Feb 25, 2010 at 12:00 PM, Xiaotian Feng <xtfeng@gmail.com> wrote:
>> 2010/2/25 Am=C3=A9rico Wang <xiyou.wangcong@gmail.com>:
>>> On Tue, Feb 23, 2010 at 3:04 PM, Andr=C3=A9 Goddard Rosa
>>> <andre.goddard@gmail.com> wrote:
>>>> It can be triggered by the following test program:
>>>>
>>>
>>> <snip>
>>>
>>>>
>>>> When not running valgrind, user-space program segfaults trying to exec=
ute
>>>> strerror(errno). With valgrind, it executes successfully and prints th=
e
>>>> 5 open files: stdin, stdout, stderr, pipe[0] and pipe[1].
>>>>
>>>> Signed-off-by: Andr=C3=A9 Goddard Rosa <andre.goddard@gmail.com>
>>>> ---
>>>
>>> The code has more than just this problem, could you please try
>>> my patch below?
>>>
>>> Thanks.
>>>
>>> ---------------------------->
>>>
>>> Clean up the failure path of sys_mq_open().
>>>
>>> Reorder the goto labels;
>>> Rename 'upsem' to 'upunlock';
>>> Remove some unused labels;
>>> Fix some wrong goto path.
>>>
>>
>> I think it's wrong to move dput after mntput
>
> Oh, this is to say mntget() should be called before lookup_one_len(),
> the original code seems wrong again...
>

How about the one below?
---------

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

--0016364eee10b7febc0480675266
Content-Type: text/plain; charset=US-ASCII; name="ipc-mqueue_c-cleanup-failure-path.diff"
Content-Disposition: attachment; 
	filename="ipc-mqueue_c-cleanup-failure-path.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g637j0ks0

ZGlmZiAtLWdpdCBhL2lwYy9tcXVldWUuYyBiL2lwYy9tcXVldWUuYwppbmRleCBjNzliZDU3Li42
ODI0NjUxIDEwMDY0NAotLS0gYS9pcGMvbXF1ZXVlLmMKKysrIGIvaXBjL21xdWV1ZS5jCkBAIC02
ODYsNyArNjg2LDcgQEAgU1lTQ0FMTF9ERUZJTkU0KG1xX29wZW4sIGNvbnN0IGNoYXIgX191c2Vy
ICosIHVfbmFtZSwgaW50LCBvZmxhZywgbW9kZV90LCBtb2RlLAogCXN0cnVjdCBmaWxlICpmaWxw
OwogCWNoYXIgKm5hbWU7CiAJc3RydWN0IG1xX2F0dHIgYXR0cjsKLQlpbnQgZmQsIGVycm9yOwor
CWludCBmZCwgZXJyb3IgPSAwOwogCXN0cnVjdCBpcGNfbmFtZXNwYWNlICppcGNfbnMgPSBjdXJy
ZW50LT5uc3Byb3h5LT5pcGNfbnM7CiAKIAlpZiAodV9hdHRyICYmIGNvcHlfZnJvbV91c2VyKCZh
dHRyLCB1X2F0dHIsIHNpemVvZihzdHJ1Y3QgbXFfYXR0cikpKQpAQCAtNzAxLDEzICs3MDEsMTMg
QEAgU1lTQ0FMTF9ERUZJTkU0KG1xX29wZW4sIGNvbnN0IGNoYXIgX191c2VyICosIHVfbmFtZSwg
aW50LCBvZmxhZywgbW9kZV90LCBtb2RlLAogCWlmIChmZCA8IDApCiAJCWdvdG8gb3V0X3B1dG5h
bWU7CiAKKwltbnRnZXQoaXBjX25zLT5tcV9tbnQpOwogCW11dGV4X2xvY2soJmlwY19ucy0+bXFf
bW50LT5tbnRfcm9vdC0+ZF9pbm9kZS0+aV9tdXRleCk7CiAJZGVudHJ5ID0gbG9va3VwX29uZV9s
ZW4obmFtZSwgaXBjX25zLT5tcV9tbnQtPm1udF9yb290LCBzdHJsZW4obmFtZSkpOwogCWlmIChJ
U19FUlIoZGVudHJ5KSkgewogCQllcnJvciA9IFBUUl9FUlIoZGVudHJ5KTsKLQkJZ290byBvdXRf
ZXJyOworCQlnb3RvIG91dF91bmxvY2s7CiAJfQotCW1udGdldChpcGNfbnMtPm1xX21udCk7CiAK
IAlpZiAob2ZsYWcgJiBPX0NSRUFUKSB7CiAJCWlmIChkZW50cnktPmRfaW5vZGUpIHsJLyogZW50
cnkgYWxyZWFkeSBleGlzdHMgKi8KQEAgLTczMSwyNCArNzMxLDIzIEBAIFNZU0NBTExfREVGSU5F
NChtcV9vcGVuLCBjb25zdCBjaGFyIF9fdXNlciAqLCB1X25hbWUsIGludCwgb2ZsYWcsIG1vZGVf
dCwgbW9kZSwKIAogCWlmIChJU19FUlIoZmlscCkpIHsKIAkJZXJyb3IgPSBQVFJfRVJSKGZpbHAp
OwotCQlnb3RvIG91dF9wdXRmZDsKKwkJZ290byBvdXQ7CiAJfQogCiAJZmRfaW5zdGFsbChmZCwg
ZmlscCk7Ci0JZ290byBvdXRfdXBzZW07CisJZ290byBvdXRfdW5sb2NrOwogCiBvdXQ6CiAJZHB1
dChkZW50cnkpOwotCW1udHB1dChpcGNfbnMtPm1xX21udCk7Ci1vdXRfcHV0ZmQ6Ci0JcHV0X3Vu
dXNlZF9mZChmZCk7Ci1vdXRfZXJyOgotCWZkID0gZXJyb3I7Ci1vdXRfdXBzZW06CitvdXRfdW5s
b2NrOgogCW11dGV4X3VubG9jaygmaXBjX25zLT5tcV9tbnQtPm1udF9yb290LT5kX2lub2RlLT5p
X211dGV4KTsKKwlpZiAoZXJyb3IpIHsKKwkJbW50cHV0KGlwY19ucy0+bXFfbW50KTsKKwkJcHV0
X3VudXNlZF9mZChmZCk7CisJfQogb3V0X3B1dG5hbWU6CiAJcHV0bmFtZShuYW1lKTsKLQlyZXR1
cm4gZmQ7CisJcmV0dXJuIGVycm9yOwogfQogCiBTWVNDQUxMX0RFRklORTEobXFfdW5saW5rLCBj
b25zdCBjaGFyIF9fdXNlciAqLCB1X25hbWUpCg==
--0016364eee10b7febc0480675266--
