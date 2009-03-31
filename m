Return-Path: <linux-kernel-owner+w=401wt.eu-S1761483AbZCaCl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483AbZCaCl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 22:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754269AbZCaClR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 22:41:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:35130 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbZCaClR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 22:41:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IcEYbHdP18/FrcBOzPM3PsxGbC3hXkhzODYhnXEuuBKf/0vMH6cH/soLacuIo4uxa3
         xIXvp7L3G7MCsCUWeVlGcZaPCuMBdr4EztwCHnDWLCuxgHn9i3jXm63hpodJbw0BQNUm
         s5V1UjZ/b582YB1zytCPNWcLV4aRXNJXLmRu8=
MIME-Version: 1.0
In-Reply-To: <20090330163317.a273a46a.akpm@linux-foundation.org>
References: <ea11fea30903222016j1d16372ct2dfd6004452e0531@mail.gmail.com> 
	<20090330163317.a273a46a.akpm@linux-foundation.org>
Date: Tue, 31 Mar 2009 08:11:00 +0530
Message-ID: <ea11fea30903301941p3a5a71c2l816df9a3d8341183@mail.gmail.com>
Subject: Re: [PATCH] : Add dev-id and inode number for debugging in 
	init_special_inode in fs/inode.c
From: Manish Katiyar <mkatiyar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: trivial@kernel.org, Andreas Dilger <adilger@sun.com>, mkatiyar@gmail.com,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=00163646d08c02a0700466612230
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00163646d08c02a0700466612230
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 31, 2009 at 5:03 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 23 Mar 2009 08:46:12 +0530
> Manish Katiyar <mkatiyar@gmail.com> wrote:
>
>> Hi Andrew,
>>
>> Below patch adds device-id and inode number for better debugging.
>>
>> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
>> ---
>> =A0fs/inode.c | =A0 =A05 +++--
>> =A01 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/inode.c b/fs/inode.c
>> index 913ab2d..f75e9a4 100644
>> --- a/fs/inode.c
>> +++ b/fs/inode.c
>> @@ -1540,7 +1540,8 @@ void init_special_inode(struct inode *inode,
>> umode_t mode, dev_t rdev)
>> =A0 =A0 =A0 else if (S_ISSOCK(mode))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode->i_fop =3D &bad_sock_fops;
>> =A0 =A0 =A0 else
>> - =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_DEBUG "init_special_inode: bogus i=
_mode (%o)\n",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mode);
>> + =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_DEBUG "init_special_inode: bogus i=
_mode (%o) for"
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " inode %s=
:%lu\n", mode, inode->i_sb->s_id,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode->i_i=
no);
>> =A0}
>> =A0EXPORT_SYMBOL(init_special_inode);
>
> I don't think this is really a trivial patch. =A0Please cc linux-kernel
> unless the patch is really really trivail.
>
> The changelog falied to give any reason for making this change. =A0It
> should have done so! =A0I cannot work out the rationale from looking at
> the code change.

Hi Andrew,
[resending it with updated changelog and ccing linux-kernel]

Below patch adds device-id and inode number for better debugging. This
was suggested by Andreas in one of the threads
http://article.gmane.org/gmane.comp.file-systems.ext4/12062 .

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/inode.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 913ab2d..f75e9a4 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1540,7 +1540,8 @@ void init_special_inode(struct inode *inode,
umode_t mode, dev_t rdev)
 	else if (S_ISSOCK(mode))
 		inode->i_fop =3D &bad_sock_fops;
 	else
-		printk(KERN_DEBUG "init_special_inode: bogus i_mode (%o)\n",
-		       mode);
+		printk(KERN_DEBUG "init_special_inode: bogus i_mode (%o) for"
+				  " inode %s:%lu\n", mode, inode->i_sb->s_id,
+				  inode->i_ino);
 }
 EXPORT_SYMBOL(init_special_inode);
--=20
1.5.4.3



PS: I have also attached the patch, in case it gets word wrapped.

Thanks -
Manish

>
>
>
>

--00163646d08c02a0700466612230
Content-Type: text/x-diff; charset=US-ASCII; 
	name="0001-Add-dev-id-and-inode-number-for-debugging-in-init_sp.patch"
Content-Disposition: attachment; 
	filename="0001-Add-dev-id-and-inode-number-for-debugging-in-init_sp.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fsxzp4mn0

RnJvbSAyNWQyZGRjMDMzNmYxZjgyODUzMjQ3NTY2MmUxMTRiYmQyM2Y0NzhhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYW5pc2ggS2F0aXlhciA8bWthdGl5YXJAZ21haWwuY29tPgpE
YXRlOiBNb24sIDIzIE1hciAyMDA5IDA4OjA4OjA1ICswNTMwClN1YmplY3Q6IFtQQVRDSF0gQWRk
IGRldi1pZCBhbmQgaW5vZGUgbnVtYmVyIGZvciBkZWJ1Z2dpbmcgaW4gaW5pdF9zcGVjaWFsX2lu
b2RlCgoKU2lnbmVkLW9mZi1ieTogTWFuaXNoIEthdGl5YXIgPG1rYXRpeWFyQGdtYWlsLmNvbT4K
LS0tCiBmcy9pbm9kZS5jIHwgICAgNSArKystLQogMSBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlv
bnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvaW5vZGUuYyBiL2ZzL2lub2Rl
LmMKaW5kZXggOTEzYWIyZC4uZjc1ZTlhNCAxMDA2NDQKLS0tIGEvZnMvaW5vZGUuYworKysgYi9m
cy9pbm9kZS5jCkBAIC0xNTQwLDcgKzE1NDAsOCBAQCB2b2lkIGluaXRfc3BlY2lhbF9pbm9kZShz
dHJ1Y3QgaW5vZGUgKmlub2RlLCB1bW9kZV90IG1vZGUsIGRldl90IHJkZXYpCiAJZWxzZSBpZiAo
U19JU1NPQ0sobW9kZSkpCiAJCWlub2RlLT5pX2ZvcCA9ICZiYWRfc29ja19mb3BzOwogCWVsc2UK
LQkJcHJpbnRrKEtFUk5fREVCVUcgImluaXRfc3BlY2lhbF9pbm9kZTogYm9ndXMgaV9tb2RlICgl
bylcbiIsCi0JCSAgICAgICBtb2RlKTsKKwkJcHJpbnRrKEtFUk5fREVCVUcgImluaXRfc3BlY2lh
bF9pbm9kZTogYm9ndXMgaV9tb2RlICglbykgZm9yIgorCQkJCSAgIiBpbm9kZSAlczolbHVcbiIs
IG1vZGUsIGlub2RlLT5pX3NiLT5zX2lkLAorCQkJCSAgaW5vZGUtPmlfaW5vKTsKIH0KIEVYUE9S
VF9TWU1CT0woaW5pdF9zcGVjaWFsX2lub2RlKTsKLS0gCjEuNS40LjMKCg==
--00163646d08c02a0700466612230--
