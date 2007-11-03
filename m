Return-Path: <linux-kernel-owner+w=401wt.eu-S1758507AbXKCSdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507AbXKCSdn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 14:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755361AbXKCSdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 14:33:36 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:19946 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988AbXKCSdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 14:33:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type;
        b=WRLnfgXpqNLUbkr8MKZzp8+fJIFHFG0t4tDUEtajhSb8NDKTTJRuBAPjW7TK7xpS1/OA6Tm2gU7CrNVgtCQSPx14gNc5FvO93nUbuvb8NXTj0oU4EU1bLbQPA6BhPVQQF07uYLb9kHyQoaIjfeZ+CCQ3U0Jyc1bYemmeKmwqS2c=
Message-ID: <b3d3ecee0711031133h4d007032l890942301cdd7581@mail.gmail.com>
Date: Sun, 4 Nov 2007 00:33:33 +0600
From: "=?KOI8-R?B?4czFy9PBzsTSIOTVzsHF1w==?=" <alexander.dunaev@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: noauto option prevents codepages from being processed properly by smbfs
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_21413_29895684.1194114813103"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_21413_29895684.1194114813103
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
The below is my bugreport as suggested in REPORTING-BUGS:

1. noauto option prevents codepages from being processed properly by smbfs

2. I had the following line in my /etc/fstab :
//host/share     /path   smbfs
noauto,iocharset=koi8-r,codepage=cp866       0       0
Mounting such a share caused the following warning to be written to
the system log:
kernel: smbfs: Unrecognized mount option noauto

The warning is harmful, but the painful side effect was that other
options, e. g. iocharset and codepage, were ignored.  I originally had
several mounts to remote samba shares with Russian filenames that
include Cyrillic characters, and they displayed fine until I added
noauto to options (the boot was slow when the remote machine was
down).  After I've added noauto, the names have become unreadable
(charset problems).

The problem is probably that mount passes everything to
smbfs--according to mount(8), but noauto is not recognized by smbfs
and somewhy this option prevents all other optoins form being
processed properly.

3. modules smbfs

4. Linux version 2.6.21 (2.6.21-5) (root@phantom) (gcc version 4.1.3
20070629 (prerelease) (Debian 4.1.2-13)) #1 SMP Wed Jul 4 23:26:38
NOVST 2007

(Other items mentioned in REPORTING-BUGS are omitted as not necessary.)

The proposed patch is attached.

Please keep me in CC if possible.

Thanks,
-- 
Alexander Dunaev

------=_Part_21413_29895684.1194114813103
Content-Type: application/octet-stream; name=smbfs-noauto-patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f8kgoy5l0
Content-Disposition: attachment; filename=smbfs-noauto-patch

LS0tIGxpbnV4LXNvdXJjZS0yLjYuMjEub3JpZy9pbmNsdWRlL2xpbnV4L3NtYl9tb3VudC5oCTIw
MDctMDQtMjYgMTA6MDg6MzIuMDAwMDAwMDAwICswNzAwCisrKyBsaW51eC1zb3VyY2UtMi42LjIx
L2luY2x1ZGUvbGludXgvc21iX21vdW50LmgJMjAwNy0xMS0wMyAyMzozNjoyNC4wMDAwMDAwMDAg
KzA2MDAKQEAgLTQyLDYgKzQyLDcgQEAKICNkZWZpbmUgU01CX01PVU5UX0dJRAkJMHgwMDQwICAv
KiBVc2UgdXNlciBzcGVjaWZpZWQgZ2lkICovCiAjZGVmaW5lIFNNQl9NT1VOVF9GTU9ERQkJMHgw
MDgwICAvKiBVc2UgdXNlciBzcGVjaWZpZWQgZmlsZSBtb2RlICovCiAjZGVmaW5lIFNNQl9NT1VO
VF9ETU9ERQkJMHgwMTAwICAvKiBVc2UgdXNlciBzcGVjaWZpZWQgZGlyIG1vZGUgKi8KKyNkZWZp
bmUgU01CX01PVU5UX05PQVVUTwkweDAyMDAJLyogRG9uJ3QgbW91bnQgYXV0b21hdGljYWxseSAq
LwogCiBzdHJ1Y3Qgc21iX21vdW50X2RhdGFfa2VybmVsIHsKIAlpbnQgdmVyc2lvbjsKLS0tIGxp
bnV4LXNvdXJjZS0yLjYuMjEub3JpZy9mcy9zbWJmcy9pbm9kZS5jCTIwMDctMDQtMjYgMTA6MDg6
MzIuMDAwMDAwMDAwICswNzAwCisrKyBsaW51eC1zb3VyY2UtMi42LjIxL2ZzL3NtYmZzL2lub2Rl
LmMJMjAwNy0xMS0wMyAyMzozNzowMS4wMDAwMDAwMDAgKzA2MDAKQEAgLTM0OSw2ICszNDksNyBA
QAogCXsgImlvY2hhcnNldCIsCTAsICdpJyB9LAogCXsgImNvZGVwYWdlIiwJMCwgJ2MnIH0sCiAJ
eyAidHRsIiwJMCwgJ3QnIH0sCisJeyAibm9hdXRvIiwJU01CX01PVU5UX05PQVVUTywgMSB9LAog
CXsgTlVMTCwJCTAsIDB9CiB9OwogCg==
------=_Part_21413_29895684.1194114813103--
