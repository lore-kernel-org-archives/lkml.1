Return-Path: <linux-kernel-owner+w=401wt.eu-S1757645AbYFBGir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645AbYFBGir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 02:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbYFBGii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 02:38:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:57788 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbYFBGih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:38:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=rNiotQ6GMEgwd8QMZjuOgTXRHV+kMV7hMI8m+p31RsTmB28XGfUPauegOH64i0W3bpVMyH1oh0zAoKUi6T3RaSbZMEWXgPSEd+VlyJtkEjlaO9LrLxqEU2meoI6MjD7mcY7FrDfun8Bdvp09yLWTNi922C3ZgSr3F/ESUfY8N94=
Message-ID: <eb3ff54b0806012338o74a3428fp668a84ea665adc30@mail.gmail.com>
Date: Mon, 2 Jun 2008 09:38:36 +0300
From: "Rami Rosen" <ramirose@gmail.com>
To: "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH net-2.6 1/2] [IPV4] [NETFILTER] Misc Cleanups.
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_9878_8040758.1212388716650"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_9878_8040758.1212388716650
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

	In this patch, these three fixes were made in net/ipv4/netfilter/ip_queue.c:
	
	1) No need to perform data_len = 0 in the switch command, since data_len
	   is initialized to 0 in the beginning of the method
,ipq_build_packet_message().
		
	2) We can reach nlmsg_failure only from one place; skb is sure to be NULL
	   when getting there; since skb is NULL, there is no need to check this fact
	   and call kfree_skb().
	
	3) Add #ifdef CONFIG_PROC_FS when removing the VFS entry,
 		 proc_net_remove(&init_net, IPQ_PROC_FS_NAME);
	

Regards,
Rami Rosen


Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_9878_8040758.1212388716650
Content-Type: text/plain; name=patch1.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fgyoweo40
Content-Disposition: attachment; filename=patch1.txt

ZGlmZiAtLWdpdCBhL25ldC9pcHY0L25ldGZpbHRlci9pcF9xdWV1ZS5jIGIvbmV0L2lwdjQvbmV0
ZmlsdGVyL2lwX3F1ZXVlLmMKaW5kZXggMjZhMzdjZS4uN2JjM2EyOSAxMDA2NDQKLS0tIGEvbmV0
L2lwdjQvbmV0ZmlsdGVyL2lwX3F1ZXVlLmMKKysrIGIvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwX3F1
ZXVlLmMKQEAgLTE1Niw3ICsxNTYsNiBAQCBpcHFfYnVpbGRfcGFja2V0X21lc3NhZ2Uoc3RydWN0
IG5mX3F1ZXVlX2VudHJ5ICplbnRyeSwgaW50ICplcnJwKQogCWNhc2UgSVBRX0NPUFlfTUVUQToK
IAljYXNlIElQUV9DT1BZX05PTkU6CiAJCXNpemUgPSBOTE1TR19TUEFDRShzaXplb2YoKnBtc2cp
KTsKLQkJZGF0YV9sZW4gPSAwOwogCQlicmVhazsKIAogCWNhc2UgSVBRX0NPUFlfUEFDS0VUOgpA
QCAtMjI0LDggKzIyMyw2IEBAIGlwcV9idWlsZF9wYWNrZXRfbWVzc2FnZShzdHJ1Y3QgbmZfcXVl
dWVfZW50cnkgKmVudHJ5LCBpbnQgKmVycnApCiAJcmV0dXJuIHNrYjsKIAogbmxtc2dfZmFpbHVy
ZToKLQlpZiAoc2tiKQotCQlrZnJlZV9za2Ioc2tiKTsKIAkqZXJycCA9IC1FSU5WQUw7CiAJcHJp
bnRrKEtFUk5fRVJSICJpcF9xdWV1ZTogZXJyb3IgY3JlYXRpbmcgcGFja2V0IG1lc3NhZ2VcbiIp
OwogCXJldHVybiBOVUxMOwpAQCAtNjEwLDcgKzYwNyw5IEBAIGNsZWFudXBfc3lzY3RsOgogCXVu
cmVnaXN0ZXJfc3lzY3RsX3RhYmxlKGlwcV9zeXNjdGxfaGVhZGVyKTsKICNlbmRpZgogCXVucmVn
aXN0ZXJfbmV0ZGV2aWNlX25vdGlmaWVyKCZpcHFfZGV2X25vdGlmaWVyKTsKKyNpZmRlZiBDT05G
SUdfUFJPQ19GUwogCXByb2NfbmV0X3JlbW92ZSgmaW5pdF9uZXQsIElQUV9QUk9DX0ZTX05BTUUp
OworI2VuZGlmCQogY2xlYW51cF9pcHFubDogX19tYXliZV91bnVzZWQKIAluZXRsaW5rX2tlcm5l
bF9yZWxlYXNlKGlwcW5sKTsKIAltdXRleF9sb2NrKCZpcHFubF9tdXRleCk7Cgo=
------=_Part_9878_8040758.1212388716650--
