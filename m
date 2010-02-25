Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab0BYDfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 22:35:06 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:52957 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758899Ab0BYDfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 22:35:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dxt0SZLCt4WRHBWsKNLALAIL8oJraCo50rmTOqroGbCzny5uThVDpsjrPeQqAVNKfs
         ycSkoJOwW8LBt8RLffXQURgiu6g36gynVNvHDgjID9YZc0zGY5KgK4SNKiiOu1n/FY1a
         ggGFfsAHWi+f39xTcmSTCfonG4D7zp/8TvFGQ=
MIME-Version: 1.0
In-Reply-To: <a3a62a6cd7cc0ba011949396a1f2c7f9c32aa4b9.1266907496.git.andre.goddard@gmail.com>
References: <cover.1266907495.git.andre.goddard@gmail.com>
	 <a3a62a6cd7cc0ba011949396a1f2c7f9c32aa4b9.1266907496.git.andre.goddard@gmail.com>
Date: Thu, 25 Feb 2010 11:35:00 +0800
Message-ID: <2375c9f91002241935k56dff805q57582d998b660889@mail.gmail.com>
Subject: Re: [PATCH 6/6] mqueue: fix mq_open() file descriptor leak on 
	user-space processes
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: =?UTF-8?Q?Andr=C3=A9_Goddard_Rosa?= <andre.goddard@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Serge E . Hallyn" <serue@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=00c09f8a4f6abbbec4048064772d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00c09f8a4f6abbbec4048064772d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 23, 2010 at 3:04 PM, Andr=C3=A9 Goddard Rosa
<andre.goddard@gmail.com> wrote:
> It can be triggered by the following test program:
>

<snip>

>
> When not running valgrind, user-space program segfaults trying to execute
> strerror(errno). With valgrind, it executes successfully and prints the
> 5 open files: stdin, stdout, stderr, pipe[0] and pipe[1].
>
> Signed-off-by: Andr=C3=A9 Goddard Rosa <andre.goddard@gmail.com>
> ---

The code has more than just this problem, could you please try
my patch below?

Thanks.

---------------------------->

Clean up the failure path of sys_mq_open().

Reorder the goto labels;
Rename 'upsem' to 'upunlock';
Remove some unused labels;
Fix some wrong goto path.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

--00c09f8a4f6abbbec4048064772d
Content-Type: text/plain; charset=US-ASCII; name="ipc-mqueue_c-cleanup-failure-path.diff"
Content-Disposition: attachment; 
	filename="ipc-mqueue_c-cleanup-failure-path.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g63082ub0

ZGlmZiAtLWdpdCBhL2lwYy9tcXVldWUuYyBiL2lwYy9tcXVldWUuYwppbmRleCBjNzliZDU3Li44
ZGVlN2EzIDEwMDY0NAotLS0gYS9pcGMvbXF1ZXVlLmMKKysrIGIvaXBjL21xdWV1ZS5jCkBAIC02
ODYsNyArNjg2LDcgQEAgU1lTQ0FMTF9ERUZJTkU0KG1xX29wZW4sIGNvbnN0IGNoYXIgX191c2Vy
ICosIHVfbmFtZSwgaW50LCBvZmxhZywgbW9kZV90LCBtb2RlLAogCXN0cnVjdCBmaWxlICpmaWxw
OwogCWNoYXIgKm5hbWU7CiAJc3RydWN0IG1xX2F0dHIgYXR0cjsKLQlpbnQgZmQsIGVycm9yOwor
CWludCBmZCwgZXJyb3IgPSAwOwogCXN0cnVjdCBpcGNfbmFtZXNwYWNlICppcGNfbnMgPSBjdXJy
ZW50LT5uc3Byb3h5LT5pcGNfbnM7CiAKIAlpZiAodV9hdHRyICYmIGNvcHlfZnJvbV91c2VyKCZh
dHRyLCB1X2F0dHIsIHNpemVvZihzdHJ1Y3QgbXFfYXR0cikpKQpAQCAtNzA1LDcgKzcwNSw3IEBA
IFNZU0NBTExfREVGSU5FNChtcV9vcGVuLCBjb25zdCBjaGFyIF9fdXNlciAqLCB1X25hbWUsIGlu
dCwgb2ZsYWcsIG1vZGVfdCwgbW9kZSwKIAlkZW50cnkgPSBsb29rdXBfb25lX2xlbihuYW1lLCBp
cGNfbnMtPm1xX21udC0+bW50X3Jvb3QsIHN0cmxlbihuYW1lKSk7CiAJaWYgKElTX0VSUihkZW50
cnkpKSB7CiAJCWVycm9yID0gUFRSX0VSUihkZW50cnkpOwotCQlnb3RvIG91dF9lcnI7CisJCWdv
dG8gb3V0X3VubG9jazsKIAl9CiAJbW50Z2V0KGlwY19ucy0+bXFfbW50KTsKIApAQCAtNzMxLDI0
ICs3MzEsMjIgQEAgU1lTQ0FMTF9ERUZJTkU0KG1xX29wZW4sIGNvbnN0IGNoYXIgX191c2VyICos
IHVfbmFtZSwgaW50LCBvZmxhZywgbW9kZV90LCBtb2RlLAogCiAJaWYgKElTX0VSUihmaWxwKSkg
ewogCQllcnJvciA9IFBUUl9FUlIoZmlscCk7Ci0JCWdvdG8gb3V0X3B1dGZkOworCQlnb3RvIG91
dDsKIAl9CiAKIAlmZF9pbnN0YWxsKGZkLCBmaWxwKTsKLQlnb3RvIG91dF91cHNlbTsKKwlnb3Rv
IG91dF91bmxvY2s7CiAKIG91dDoKLQlkcHV0KGRlbnRyeSk7CiAJbW50cHV0KGlwY19ucy0+bXFf
bW50KTsKLW91dF9wdXRmZDoKLQlwdXRfdW51c2VkX2ZkKGZkKTsKLW91dF9lcnI6Ci0JZmQgPSBl
cnJvcjsKLW91dF91cHNlbToKKwlkcHV0KGRlbnRyeSk7CitvdXRfdW5sb2NrOgogCW11dGV4X3Vu
bG9jaygmaXBjX25zLT5tcV9tbnQtPm1udF9yb290LT5kX2lub2RlLT5pX211dGV4KTsKKwlpZiAo
ZXJyb3IpCisJCXB1dF91bnVzZWRfZmQoZmQpOwogb3V0X3B1dG5hbWU6CiAJcHV0bmFtZShuYW1l
KTsKLQlyZXR1cm4gZmQ7CisJcmV0dXJuIGVycm9yOwogfQogCiBTWVNDQUxMX0RFRklORTEobXFf
dW5saW5rLCBjb25zdCBjaGFyIF9fdXNlciAqLCB1X25hbWUpCg==
--00c09f8a4f6abbbec4048064772d--
