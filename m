Return-Path: <linux-kernel-owner+w=401wt.eu-S1752567AbYKGNNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbYKGNNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 08:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbYKGNMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 08:12:49 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:18947 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYKGNMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 08:12:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :x-google-sender-auth;
        b=V6aBP5H+0y4JkRwXQcYFb71OHUfAVK5VGYiuCEi8u6aYZBeerrWxZ28oZg4F3eTTaI
         YAeWag79IruFglchwTTassFc2nYGSCeHdWdXY+9GqLCtwkKRfvJ7m1FYFw1JOLQYCoQB
         HpQP6SMWPPEwW9/8zOqWXenZPJNJu5qNda5mA=
Message-ID: <5ff4a1e50811070512v410e623ax60e8a65b169f800@mail.gmail.com>
Date: Fri, 7 Nov 2008 13:12:47 +0000
From: "Matt Fleming" <mjf@gentoo.org>
To: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu, rostedt@goodmis.org
Subject: [PATCH] ftrace: Allow section alignment
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_27883_16227586.1226063567808"
X-Google-Sender-Auth: 6a520e886942ab10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_27883_16227586.1226063567808
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Provide a means of aligning the __mcount_loc section.

Signed-off-by: Matt Fleming <matthew.fleming@imgtec.com>
---
 scripts/recordmcount.pl |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 6b9fe3e..2d0bfa1 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -134,6 +134,7 @@ my $section_regex;  # Find the start of a section
 my $function_regex;    # Find the name of a function
                        #    (return offset and func name)
 my $mcount_regex;      # Find the call site to mcount (return offset)
+my $alignment;         # The .align value to use for $mcount_section

 if ($arch eq "x86") {
     if ($bits == 64) {
@@ -148,6 +149,7 @@ if ($arch eq "x86_64") {
     $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount([+-]0x[0-9a-zA-Z]+)?\$";
     $type = ".quad";
+    $alignment = 8;

     # force flags for this arch
     $ld .= " -m elf_x86_64";
@@ -160,6 +162,7 @@ if ($arch eq "x86_64") {
     $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
     $type = ".long";
+    $alignment = 4;

     # force flags for this arch
     $ld .= " -m elf_i386";
@@ -288,6 +291,7 @@ sub update_funcs
            open(FILE, ">$mcount_s") || die "can't create $mcount_s\n";
            $opened = 1;
            print FILE "\t.section $mcount_section,\"a\",\@progbits\n";
+           print FILE "\t.align $alignment\n";
        }
        printf FILE "\t%s %s + %d\n", $type, $ref_func, $offsets[$i] - $offset;
     }
--
1.5.6.4

------=_Part_27883_16227586.1226063567808
Content-Type: text/x-diff; name=0001-ftrace-Allow-section-alignment.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fn8ujm5v0
Content-Disposition: attachment;
 filename=0001-ftrace-Allow-section-alignment.patch

RnJvbSAyYTQwNWU3NTQ0NTdhNjc2MTU1ZmI4NmU2MmRhYzQzYzYwZWU0YmUwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXR0IEZsZW1pbmcgPG1hdHRoZXcuZmxlbWluZ0BpbWd0ZWMu
Y29tPgpEYXRlOiBGcmksIDcgTm92IDIwMDggMTI6NTU6MjIgKzAwMDAKU3ViamVjdDogW1BBVENI
XSBmdHJhY2U6IEFsbG93IHNlY3Rpb24gYWxpZ25tZW50CgpQcm92aWRlIGEgbWVhbnMgb2YgYWxp
Z25pbmcgdGhlIF9fbWNvdW50X2xvYyBzZWN0aW9uLgoKU2lnbmVkLW9mZi1ieTogTWF0dCBGbGVt
aW5nIDxtYXR0aGV3LmZsZW1pbmdAaW1ndGVjLmNvbT4KLS0tCiBzY3JpcHRzL3JlY29yZG1jb3Vu
dC5wbCB8ICAgIDQgKysrKwogMSBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDAgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvc2NyaXB0cy9yZWNvcmRtY291bnQucGwgYi9zY3JpcHRz
L3JlY29yZG1jb3VudC5wbAppbmRleCA2YjlmZTNlLi4yZDBiZmExIDEwMDc1NQotLS0gYS9zY3Jp
cHRzL3JlY29yZG1jb3VudC5wbAorKysgYi9zY3JpcHRzL3JlY29yZG1jb3VudC5wbApAQCAtMTM0
LDYgKzEzNCw3IEBAIG15ICRzZWN0aW9uX3JlZ2V4OwkjIEZpbmQgdGhlIHN0YXJ0IG9mIGEgc2Vj
dGlvbgogbXkgJGZ1bmN0aW9uX3JlZ2V4OwkjIEZpbmQgdGhlIG5hbWUgb2YgYSBmdW5jdGlvbgog
CQkJIyAgICAocmV0dXJuIG9mZnNldCBhbmQgZnVuYyBuYW1lKQogbXkgJG1jb3VudF9yZWdleDsJ
IyBGaW5kIHRoZSBjYWxsIHNpdGUgdG8gbWNvdW50IChyZXR1cm4gb2Zmc2V0KQorbXkgJGFsaWdu
bWVudDsJCSMgVGhlIC5hbGlnbiB2YWx1ZSB0byB1c2UgZm9yICRtY291bnRfc2VjdGlvbgogCiBp
ZiAoJGFyY2ggZXEgIng4NiIpIHsKICAgICBpZiAoJGJpdHMgPT0gNjQpIHsKQEAgLTE0OCw2ICsx
NDksNyBAQCBpZiAoJGFyY2ggZXEgIng4Nl82NCIpIHsKICAgICAkZnVuY3Rpb25fcmVnZXggPSAi
XihbMC05YS1mQS1GXSspXFxzKzwoLio/KT46IjsKICAgICAkbWNvdW50X3JlZ2V4ID0gIl5cXHMq
KFswLTlhLWZBLUZdKyk6LipcXHNtY291bnQoWystXTB4WzAtOWEtekEtWl0rKT9cJCI7CiAgICAg
JHR5cGUgPSAiLnF1YWQiOworICAgICRhbGlnbm1lbnQgPSA4OwogCiAgICAgIyBmb3JjZSBmbGFn
cyBmb3IgdGhpcyBhcmNoCiAgICAgJGxkIC49ICIgLW0gZWxmX3g4Nl82NCI7CkBAIC0xNjAsNiAr
MTYyLDcgQEAgaWYgKCRhcmNoIGVxICJ4ODZfNjQiKSB7CiAgICAgJGZ1bmN0aW9uX3JlZ2V4ID0g
Il4oWzAtOWEtZkEtRl0rKVxccys8KC4qPyk+OiI7CiAgICAgJG1jb3VudF9yZWdleCA9ICJeXFxz
KihbMC05YS1mQS1GXSspOi4qXFxzbWNvdW50XCQiOwogICAgICR0eXBlID0gIi5sb25nIjsKKyAg
ICAkYWxpZ25tZW50ID0gNDsKIAogICAgICMgZm9yY2UgZmxhZ3MgZm9yIHRoaXMgYXJjaAogICAg
ICRsZCAuPSAiIC1tIGVsZl9pMzg2IjsKQEAgLTI4OCw2ICsyOTEsNyBAQCBzdWIgdXBkYXRlX2Z1
bmNzCiAJICAgIG9wZW4oRklMRSwgIj4kbWNvdW50X3MiKSB8fCBkaWUgImNhbid0IGNyZWF0ZSAk
bWNvdW50X3NcbiI7CiAJICAgICRvcGVuZWQgPSAxOwogCSAgICBwcmludCBGSUxFICJcdC5zZWN0
aW9uICRtY291bnRfc2VjdGlvbixcImFcIixcQHByb2diaXRzXG4iOworCSAgICBwcmludCBGSUxF
ICJcdC5hbGlnbiAkYWxpZ25tZW50XG4iOwogCX0KIAlwcmludGYgRklMRSAiXHQlcyAlcyArICVk
XG4iLCAkdHlwZSwgJHJlZl9mdW5jLCAkb2Zmc2V0c1skaV0gLSAkb2Zmc2V0OwogICAgIH0KLS0g
CjEuNS42LjQKCg==
------=_Part_27883_16227586.1226063567808--
