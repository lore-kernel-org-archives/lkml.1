Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbYLKG3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbYLKG3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 01:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbYLKG3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 01:29:03 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:41874 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbYLKG3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 01:29:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=YEYOxWdatRZm5OBuJWlnNljYJ+/rSUZKOXYBhgek2lHWfb1zIzOAnH6YrckJQ2tWS1
         gRzVT4h7ABhsYvSBmLYollJmlR6pEAgvM/4XvNxaAcrb9AEMfehL9xkkhqVimCdGzlmT
         aQh8HdTuG3qLl92b+Aa+3AhqVwhSMcRPG5Kbw=
Message-ID: <9cde8bff0812102228q38eda15esf8cf2e0ad70dbce@mail.gmail.com>
Date: Thu, 11 Dec 2008 15:28:59 +0900
From: "Nguyen Anh Quynh" <aquynh@gmail.com>
To: "Al Viro" <viro@zeniv.linux.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix calls to request_module()
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Kuniyasu Suzaki" <k.suzaki@aist.go.jp>
In-Reply-To: <20081211060041.GN28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_97007_17210902.1228976939280"
References: <9cde8bff0812101935j5ef56140k67035d892a868738@mail.gmail.com>
	 <20081211040118.GK28946@ZenIV.linux.org.uk>
	 <20081210201455.0c611484.akpm@linux-foundation.org>
	 <9cde8bff0812102023v60ce265bk394c420a29100b92@mail.gmail.com>
	 <20081211050023.GM28946@ZenIV.linux.org.uk>
	 <9cde8bff0812102142s5d58b8dcibe5d36a68e09f367@mail.gmail.com>
	 <20081211060041.GN28946@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_97007_17210902.1228976939280
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Dec 11, 2008 at 3:00 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Dec 11, 2008 at 02:42:28PM +0900, Nguyen Anh Quynh wrote:
>> > Ah, but that's different.  Take a look at that warning and think _why_
>> > it is given and what is it about.  Getting an untrusted string as
>> > format argument is a real security hole, but it has nothing to do
>> > with a pile of cases in your patch.
>>
>> Yes, clearly the warning is to warn us about potential format string
>> bugs. But I agree that there are a lot of false possitives.
>>
>> My patch is mainly to make gcc happy.
>
> Your patch is mostly obfuscating the places gcc does *not* warn about...
>
> Looking through it, only
> drivers/media/video/cx18/cx18-driver.c
> drivers/media/video/ivtv/ivtv-driver.c
> drivers/media/video/pvrusb2/pvrusb2-hdw.c
> drivers/media/video/zoran/zoran_card.c
> drivers/mtd/chips/gen_probe.c
> drivers/net/wireless/hostap/hostap_ioctl.c
> drivers/of/of_spi.c
> drivers/usb/storage/libusual.c
> fs/dquot.c
> fs/gfs2/locking.c
> net/ieee80211/ieee80211_wx.c
> sound/core/sound.c
>
> are not of <string literal> -> "%s", <string literal> variety.  Everything
> else has never generated a format warning.  At least trim the patch,
> removing the obviously useless parts.

Yes, initially I misunderstood these warnings.

So here is the patch, again, with only the "correct" warning fixed.

Signed-off-by: Nguyen Anh Quynh <aquynh@gmail.com>

Thanks,
Quynh


# diffstat fix-request_module-call.linus_git_tree.patch
 drivers/media/video/cx18/cx18-driver.c     |    2 +-
 drivers/media/video/ivtv/ivtv-driver.c     |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c  |    2 +-
 drivers/media/video/zoran/zoran_card.c     |    8 ++++----
 drivers/mtd/chips/gen_probe.c              |    2 +-
 drivers/net/wireless/hostap/hostap_ioctl.c |    2 +-
 drivers/of/of_spi.c                        |    2 +-
 drivers/usb/storage/libusual.c             |    2 +-
 fs/dquot.c                                 |    2 +-
 fs/gfs2/locking.c                          |    2 +-
 net/ieee80211/ieee80211_wx.c               |    2 +-
 sound/core/sound.c                         |    2 +-
 12 files changed, 15 insertions(+), 15 deletions(-)

------=_Part_97007_17210902.1228976939280
Content-Type: text/x-patch;
 name=fix-request_module-call.linus_git_tree.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fol13do50
Content-Disposition: attachment;
 filename=fix-request_module-call.linus_git_tree.patch

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gxOC9jeDE4LWRyaXZlci5jIGIvZHJp
dmVycy9tZWRpYS92aWRlby9jeDE4L2N4MTgtZHJpdmVyLmMKaW5kZXggNzg3NGQ5Ny4uODFmMGQ1
ZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby9jeDE4L2N4MTgtZHJpdmVyLmMKKysr
IGIvZHJpdmVycy9tZWRpYS92aWRlby9jeDE4L2N4MTgtZHJpdmVyLmMKQEAgLTU3Miw3ICs1NzIs
NyBAQCBzdGF0aWMgdTMyIGN4MThfcmVxdWVzdF9tb2R1bGUoc3RydWN0IGN4MTggKmN4LCB1MzIg
aHcsCiB7CiAJaWYgKChodyAmIGlkKSA9PSAwKQogCQlyZXR1cm4gaHc7Ci0JaWYgKHJlcXVlc3Rf
bW9kdWxlKG5hbWUpICE9IDApIHsKKwlpZiAocmVxdWVzdF9tb2R1bGUoIiVzIiwgbmFtZSkgIT0g
MCkgewogCQlDWDE4X0VSUigiRmFpbGVkIHRvIGxvYWQgbW9kdWxlICVzXG4iLCBuYW1lKTsKIAkJ
cmV0dXJuIGh3ICYgfmlkOwogCX0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vaXZ0
di9pdnR2LWRyaXZlci5jIGIvZHJpdmVycy9tZWRpYS92aWRlby9pdnR2L2l2dHYtZHJpdmVyLmMK
aW5kZXggYjY5Y2MxZC4uYTI2YWQ1OSAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby9p
dnR2L2l2dHYtZHJpdmVyLmMKKysrIGIvZHJpdmVycy9tZWRpYS92aWRlby9pdnR2L2l2dHYtZHJp
dmVyLmMKQEAgLTg1OSw3ICs4NTksNyBAQCBzdGF0aWMgdTMyIGl2dHZfcmVxdWVzdF9tb2R1bGUo
c3RydWN0IGl2dHYgKml0diwgdTMyIGh3LAogewogCWlmICgoaHcgJiBpZCkgPT0gMCkKIAkJcmV0
dXJuIGh3OwotCWlmIChyZXF1ZXN0X21vZHVsZShuYW1lKSAhPSAwKSB7CisJaWYgKHJlcXVlc3Rf
bW9kdWxlKCIlcyIsIG5hbWUpICE9IDApIHsKIAkJSVZUVl9FUlIoIkZhaWxlZCB0byBsb2FkIG1v
ZHVsZSAlc1xuIiwgbmFtZSk7CiAJCXJldHVybiBodyAmIH5pZDsKIAl9CmRpZmYgLS1naXQgYS9k
cml2ZXJzL21lZGlhL3ZpZGVvL3B2cnVzYjIvcHZydXNiMi1oZHcuYyBiL2RyaXZlcnMvbWVkaWEv
dmlkZW8vcHZydXNiMi9wdnJ1c2IyLWhkdy5jCmluZGV4IDViODFiYTQuLjZkNzVkM2MgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vcHZydXNiMi9wdnJ1c2IyLWhkdy5jCisrKyBiL2Ry
aXZlcnMvbWVkaWEvdmlkZW8vcHZydXNiMi9wdnJ1c2IyLWhkdy5jCkBAIC0xOTY3LDcgKzE5Njcs
NyBAQCBzdGF0aWMgdm9pZCBwdnIyX2hkd19zZXR1cF9sb3coc3RydWN0IHB2cjJfaGR3ICpoZHcp
CiAJaWYgKCFwdnIyX2hkd19kZXZfb2soaGR3KSkgcmV0dXJuOwogCiAJZm9yIChpZHggPSAwOyBp
ZHggPCBoZHctPmhkd19kZXNjLT5jbGllbnRfbW9kdWxlcy5jbnQ7IGlkeCsrKSB7Ci0JCXJlcXVl
c3RfbW9kdWxlKGhkdy0+aGR3X2Rlc2MtPmNsaWVudF9tb2R1bGVzLmxzdFtpZHhdKTsKKwkJcmVx
dWVzdF9tb2R1bGUoIiVzIiwgaGR3LT5oZHdfZGVzYy0+Y2xpZW50X21vZHVsZXMubHN0W2lkeF0p
OwogCX0KIAogCWlmICghaGR3LT5oZHdfZGVzYy0+ZmxhZ19ub19wb3dlcnVwKSB7CmRpZmYgLS1n
aXQgYS9kcml2ZXJzL21lZGlhL3ZpZGVvL3pvcmFuL3pvcmFuX2NhcmQuYyBiL2RyaXZlcnMvbWVk
aWEvdmlkZW8vem9yYW4vem9yYW5fY2FyZC5jCmluZGV4IGZhNWYyZjguLjU4NmVlN2QgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vem9yYW4vem9yYW5fY2FyZC5jCisrKyBiL2RyaXZl
cnMvbWVkaWEvdmlkZW8vem9yYW4vem9yYW5fY2FyZC5jCkBAIC0xNDM1LDcgKzE0MzUsNyBAQCBm
aW5kX3pyMzYwNTcgKHZvaWQpCiAJCX0KIAogCQlpZiAoaTJjX2RlY19uYW1lKSB7Ci0JCQlpZiAo
KHJlc3VsdCA9IHJlcXVlc3RfbW9kdWxlKGkyY19kZWNfbmFtZSkpIDwgMCkgeworCQkJaWYgKChy
ZXN1bHQgPSByZXF1ZXN0X21vZHVsZSgiJXMiLCBpMmNfZGVjX25hbWUpKSA8IDApIHsKIAkJCQlk
cHJpbnRrKDEsCiAJCQkJCUtFUk5fRVJSCiAJCQkJCSIlczogZmFpbGVkIHRvIGxvYWQgbW9kdWxl
ICVzOiAlZFxuIiwKQEAgLTE0NTUsNyArMTQ1NSw3IEBAIGZpbmRfenIzNjA1NyAodm9pZCkKIAkJ
fQogCiAJCWlmIChpMmNfZW5jX25hbWUpIHsKLQkJCWlmICgocmVzdWx0ID0gcmVxdWVzdF9tb2R1
bGUoaTJjX2VuY19uYW1lKSkgPCAwKSB7CisJCQlpZiAoKHJlc3VsdCA9IHJlcXVlc3RfbW9kdWxl
KCIlcyIsIGkyY19lbmNfbmFtZSkpIDwgMCkgewogCQkJCWRwcmludGsoMSwKIAkJCQkJS0VSTl9F
UlIKIAkJCQkJIiVzOiBmYWlsZWQgdG8gbG9hZCBtb2R1bGUgJXM6ICVkXG4iLApAQCAtMTQ3OCw3
ICsxNDc4LDcgQEAgZmluZF96cjM2MDU3ICh2b2lkKQogCQlpZiAoenItPmNhcmQudmlkZW9fY29k
ZWMgIT0gMCAmJgogCQkgICAgKGNvZGVjX25hbWUgPQogCQkgICAgIGNvZGVjaWRfdG9fbW9kdWxl
bmFtZSh6ci0+Y2FyZC52aWRlb19jb2RlYykpICE9IE5VTEwpIHsKLQkJCWlmICgocmVzdWx0ID0g
cmVxdWVzdF9tb2R1bGUoY29kZWNfbmFtZSkpIDwgMCkgeworCQkJaWYgKChyZXN1bHQgPSByZXF1
ZXN0X21vZHVsZSgiJXMiLCBjb2RlY19uYW1lKSkgPCAwKSB7CiAJCQkJZHByaW50aygxLAogCQkJ
CQlLRVJOX0VSUgogCQkJCQkiJXM6IGZhaWxlZCB0byBsb2FkIG1vZHVsZXMgJXM6ICVkXG4iLApA
QCAtMTQ4OCw3ICsxNDg4LDcgQEAgZmluZF96cjM2MDU3ICh2b2lkKQogCQlpZiAoenItPmNhcmQu
dmlkZW9fdmZlICE9IDAgJiYKIAkJICAgICh2ZmVfbmFtZSA9CiAJCSAgICAgY29kZWNpZF90b19t
b2R1bGVuYW1lKHpyLT5jYXJkLnZpZGVvX3ZmZSkpICE9IE5VTEwpIHsKLQkJCWlmICgocmVzdWx0
ID0gcmVxdWVzdF9tb2R1bGUodmZlX25hbWUpKSA8IDApIHsKKwkJCWlmICgocmVzdWx0ID0gcmVx
dWVzdF9tb2R1bGUoIiVzIiwgdmZlX25hbWUpKSA8IDApIHsKIAkJCQlkcHJpbnRrKDEsCiAJCQkJ
CUtFUk5fRVJSCiAJCQkJCSIlczogZmFpbGVkIHRvIGxvYWQgbW9kdWxlcyAlczogJWRcbiIsCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL210ZC9jaGlwcy9nZW5fcHJvYmUuYyBiL2RyaXZlcnMvbXRkL2No
aXBzL2dlbl9wcm9iZS5jCmluZGV4IGUyZGM5NjQuLjgxNGQ0ZjMgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvbXRkL2NoaXBzL2dlbl9wcm9iZS5jCisrKyBiL2RyaXZlcnMvbXRkL2NoaXBzL2dlbl9wcm9i
ZS5jCkBAIC0yMTIsNyArMjEyLDcgQEAgc3RhdGljIGlubGluZSBzdHJ1Y3QgbXRkX2luZm8gKmNm
aV9jbWRzZXRfdW5rbm93bihzdHJ1Y3QgbWFwX2luZm8gKm1hcCwKIAogCXByb2JlX2Z1bmN0aW9u
ID0gX19zeW1ib2xfZ2V0KHByb2JlbmFtZSk7CiAJaWYgKCFwcm9iZV9mdW5jdGlvbikgewotCQly
ZXF1ZXN0X21vZHVsZShwcm9iZW5hbWUgKyBzaXplb2YoTU9EVUxFX1NZTUJPTF9QUkVGSVgpIC0g
MSk7CisJCXJlcXVlc3RfbW9kdWxlKCIlcyIsIHByb2JlbmFtZSArIHNpemVvZihNT0RVTEVfU1lN
Qk9MX1BSRUZJWCkgLSAxKTsKIAkJcHJvYmVfZnVuY3Rpb24gPSBfX3N5bWJvbF9nZXQocHJvYmVu
YW1lKTsKIAl9CiAKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2hvc3RhcC9ob3N0
YXBfaW9jdGwuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2hvc3RhcC9ob3N0YXBfaW9jdGwuYwpp
bmRleCAzZjhiMWQ3Li5lYTAzOTkyIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9o
b3N0YXAvaG9zdGFwX2lvY3RsLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaG9zdGFwL2hv
c3RhcF9pb2N0bC5jCkBAIC0zMjk3LDcgKzMyOTcsNyBAQCBzdGF0aWMgaW50IHByaXNtMl9pb2N0
bF9zaXdlbmNvZGVleHQoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwKIAogCW9wcyA9IGllZWU4MDIx
MV9nZXRfY3J5cHRvX29wcyhhbGcpOwogCWlmIChvcHMgPT0gTlVMTCkgewotCQlyZXF1ZXN0X21v
ZHVsZShtb2R1bGUpOworCQlyZXF1ZXN0X21vZHVsZSgiJXMiLCBtb2R1bGUpOwogCQlvcHMgPSBp
ZWVlODAyMTFfZ2V0X2NyeXB0b19vcHMoYWxnKTsKIAl9CiAJaWYgKG9wcyA9PSBOVUxMKSB7CmRp
ZmYgLS1naXQgYS9kcml2ZXJzL29mL29mX3NwaS5jIGIvZHJpdmVycy9vZi9vZl9zcGkuYwppbmRl
eCBiZWQwZWQ2Li5hZDk2NDM3IDEwMDY0NAotLS0gYS9kcml2ZXJzL29mL29mX3NwaS5jCisrKyBi
L2RyaXZlcnMvb2Yvb2Zfc3BpLmMKQEAgLTgyLDcgKzgyLDcgQEAgdm9pZCBvZl9yZWdpc3Rlcl9z
cGlfZGV2aWNlcyhzdHJ1Y3Qgc3BpX21hc3RlciAqbWFzdGVyLCBzdHJ1Y3QgZGV2aWNlX25vZGUg
Km5wKQogCQlzcGktPmRldi5hcmNoZGF0YS5vZl9ub2RlID0gbmM7CiAKIAkJLyogUmVnaXN0ZXIg
dGhlIG5ldyBkZXZpY2UgKi8KLQkJcmVxdWVzdF9tb2R1bGUoc3BpLT5tb2RhbGlhcyk7CisJCXJl
cXVlc3RfbW9kdWxlKCIlcyIsIHNwaS0+bW9kYWxpYXMpOwogCQlyYyA9IHNwaV9hZGRfZGV2aWNl
KHNwaSk7CiAJCWlmIChyYykgewogCQkJZGV2X2VycigmbWFzdGVyLT5kZXYsICJzcGlfZGV2aWNl
IHJlZ2lzdGVyIGVycm9yICVzXG4iLApkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2Ivc3RvcmFnZS9s
aWJ1c3VhbC5jIGIvZHJpdmVycy91c2Ivc3RvcmFnZS9saWJ1c3VhbC5jCmluZGV4IGQ2MTdlOGEu
LmE0ODFlMDIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvdXNiL3N0b3JhZ2UvbGlidXN1YWwuYworKysg
Yi9kcml2ZXJzL3VzYi9zdG9yYWdlL2xpYnVzdWFsLmMKQEAgLTE4MCw3ICsxODAsNyBAQCBzdGF0
aWMgaW50IHVzdV9wcm9iZV90aHJlYWQodm9pZCAqYXJnKQogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7
CiAKIAltdXRleF9sb2NrKCZ1c3VfcHJvYmVfbXV0ZXgpOwotCXJjID0gcmVxdWVzdF9tb2R1bGUo
Ymlhc19uYW1lc1t0eXBlXSk7CisJcmMgPSByZXF1ZXN0X21vZHVsZSgiJXMiLCBiaWFzX25hbWVz
W3R5cGVdKTsKIAlzcGluX2xvY2tfaXJxc2F2ZSgmdXN1X2xvY2ssIGZsYWdzKTsKIAlpZiAocmMg
PT0gMCAmJiAoc3QtPmZscyAmIFVTVV9NT0RfRkxfUFJFU0VOVCkgPT0gMCkgewogCQkvKgpkaWZm
IC0tZ2l0IGEvZnMvZHF1b3QuYyBiL2ZzL2RxdW90LmMKaW5kZXggNWU5NTI2MS4uMzk4NDMwNyAx
MDA2NDQKLS0tIGEvZnMvZHF1b3QuYworKysgYi9mcy9kcXVvdC5jCkBAIC0xNjcsNyArMTY3LDcg
QEAgc3RhdGljIHN0cnVjdCBxdW90YV9mb3JtYXRfdHlwZSAqZmluZF9xdW90YV9mb3JtYXQoaW50
IGlkKQogCQlzcGluX3VubG9jaygmZHFfbGlzdF9sb2NrKTsKIAkJCiAJCWZvciAocW0gPSAwOyBt
b2R1bGVfbmFtZXNbcW1dLnFtX2ZtdF9pZCAmJiBtb2R1bGVfbmFtZXNbcW1dLnFtX2ZtdF9pZCAh
PSBpZDsgcW0rKyk7Ci0JCWlmICghbW9kdWxlX25hbWVzW3FtXS5xbV9mbXRfaWQgfHwgcmVxdWVz
dF9tb2R1bGUobW9kdWxlX25hbWVzW3FtXS5xbV9tb2RfbmFtZSkpCisJCWlmICghbW9kdWxlX25h
bWVzW3FtXS5xbV9mbXRfaWQgfHwgcmVxdWVzdF9tb2R1bGUoIiVzIiwgbW9kdWxlX25hbWVzW3Ft
XS5xbV9tb2RfbmFtZSkpCiAJCQlyZXR1cm4gTlVMTDsKIAogCQlzcGluX2xvY2soJmRxX2xpc3Rf
bG9jayk7CmRpZmYgLS1naXQgYS9mcy9nZnMyL2xvY2tpbmcuYyBiL2ZzL2dmczIvbG9ja2luZy5j
CmluZGV4IDUyMzI0M2EuLjdhOWRmN2YgMTAwNjQ0Ci0tLSBhL2ZzL2dmczIvbG9ja2luZy5jCisr
KyBiL2ZzL2dmczIvbG9ja2luZy5jCkBAIC0xNzcsNyArMTc3LDcgQEAgcmV0cnk6CiAJCWlmICgh
dHJ5ICYmIGNhcGFibGUoQ0FQX1NZU19NT0RVTEUpKSB7CiAJCQl0cnkgPSAxOwogCQkJbXV0ZXhf
dW5sb2NrKCZsbWhfbG9jayk7Ci0JCQlyZXF1ZXN0X21vZHVsZShwcm90b19uYW1lKTsKKwkJCXJl
cXVlc3RfbW9kdWxlKCIlcyIsIHByb3RvX25hbWUpOwogCQkJZ290byByZXRyeTsKIAkJfQogCQlw
cmludGsoS0VSTl9JTkZPICJHRlMyOiBjYW4ndCBmaW5kIHByb3RvY29sICVzXG4iLCBwcm90b19u
YW1lKTsKZGlmZiAtLWdpdCBhL25ldC9pZWVlODAyMTEvaWVlZTgwMjExX3d4LmMgYi9uZXQvaWVl
ZTgwMjExL2llZWU4MDIxMV93eC5jCmluZGV4IDk3MzgzMmQuLmRlNGJlMDMgMTAwNjQ0Ci0tLSBh
L25ldC9pZWVlODAyMTEvaWVlZTgwMjExX3d4LmMKKysrIGIvbmV0L2llZWU4MDIxMS9pZWVlODAy
MTFfd3guYwpAQCAtNjA4LDcgKzYwOCw3IEBAIGludCBpZWVlODAyMTFfd3hfc2V0X2VuY29kZWV4
dChzdHJ1Y3QgaWVlZTgwMjExX2RldmljZSAqaWVlZSwKIAogCW9wcyA9IGllZWU4MDIxMV9nZXRf
Y3J5cHRvX29wcyhhbGcpOwogCWlmIChvcHMgPT0gTlVMTCkgewotCQlyZXF1ZXN0X21vZHVsZSht
b2R1bGUpOworCQlyZXF1ZXN0X21vZHVsZSgiJXMiLCBtb2R1bGUpOwogCQlvcHMgPSBpZWVlODAy
MTFfZ2V0X2NyeXB0b19vcHMoYWxnKTsKIAl9CiAJaWYgKG9wcyA9PSBOVUxMKSB7CmRpZmYgLS1n
aXQgYS9zb3VuZC9jb3JlL3NvdW5kLmMgYi9zb3VuZC9jb3JlL3NvdW5kLmMKaW5kZXggNDRhNjli
Yi4uYzE0M2I5YyAxMDA2NDQKLS0tIGEvc291bmQvY29yZS9zb3VuZC5jCisrKyBiL3NvdW5kL2Nv
cmUvc291bmQuYwpAQCAtODgsNyArODgsNyBAQCBzdGF0aWMgdm9pZCBzbmRfcmVxdWVzdF9vdGhl
cihpbnQgbWlub3IpCiAJY2FzZSBTTkRSVl9NSU5PUl9USU1FUjoJCXN0ciA9ICJzbmQtdGltZXIi
OwlicmVhazsKIAlkZWZhdWx0OgkJCXJldHVybjsKIAl9Ci0JcmVxdWVzdF9tb2R1bGUoc3RyKTsK
KwlyZXF1ZXN0X21vZHVsZSgiJXMiLCBzdHIpOwogfQogCiAjZW5kaWYJLyogbW9kdWxhciBrZXJu
ZWwgKi8K
------=_Part_97007_17210902.1228976939280--
