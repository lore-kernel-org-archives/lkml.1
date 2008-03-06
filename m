Return-Path: <linux-kernel-owner+w=401wt.eu-S1760128AbYCFJLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128AbYCFJLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 04:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbYCFJLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 04:11:16 -0500
Received: from el-out-1112.google.com ([209.85.162.177]:8685 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679AbYCFJLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 04:11:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=S3dUS4AA3o0Vp16TLXo1pZkPWYubRtsRSaetYgCnTL2peWRJRxryUgVYNsWQ25qTmyLx575Zq9WRnax2MxFkH9ztdYFBEAGia320K6YUn+H02PTy//Ee0IRHo1y6Jtk6qbYFAYXcwJ+ZrYoVVFplR58svuAARZvUf+J61I67BIg=
Message-ID: <86802c440803060111t264caf0dwe4e1d167fa494b6b@mail.gmail.com>
Date: Thu, 6 Mar 2008 01:11:11 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86_64: fix amd_detect_cmp
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_22238_30190936.1204794671638"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_22238_30190936.1204794671638
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

[PATCH] x86_64: fix amd_detect_cmp

for system with apicid lifting, boot cpu apicid will be 4
got
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/4 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0

so try to offset apicid back before get phys_proc_id with bits shift.
then we can get correct socket ID

also remove remove cpu_data(0) reference.
because cpu_data(0) only be ready after smp_prepare_cpus with the assignment
from boot_cpu_data to current_cpu_data aka cpu_data(0).
and check_bugs()==>identify_cpu(&boot_cpu_data) is quite before than
smp_prepare_cpus.
so just use boot_cpu_id instead.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

------=_Part_22238_30190936.1204794671638
Content-Type: text/x-patch; name=fix_amd_detect_cmp.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdh3webh0
Content-Disposition: attachment; filename=fix_amd_detect_cmp.patch

W1BBVENIXSB4ODZfNjQ6IGZpeCBhbWRfZGV0ZWN0X2NtcAoKZm9yIHN5c3RlbSB3aXRoIGFwaWNp
ZCBsaWZ0aW5nLCBib290IGNwdSBhcGljaWQgd2lsbCBiZSA0CmdvdApDUFU6IEwxIEkgQ2FjaGU6
IDY0SyAoNjQgYnl0ZXMvbGluZSksIEQgY2FjaGUgNjRLICg2NCBieXRlcy9saW5lKQpDUFU6IEwy
IENhY2hlOiA1MTJLICg2NCBieXRlcy9saW5lKQpDUFUgMC80IC0+IE5vZGUgMApDUFU6IFBoeXNp
Y2FsIFByb2Nlc3NvciBJRDogMQpDUFU6IFByb2Nlc3NvciBDb3JlIElEOiAwCgpzbyB0cnkgdG8g
b2Zmc2V0IGFwaWNpZCBiYWNrIGJlZm9yZSBnZXQgcGh5c19wcm9jX2lkIHdpdGggYml0cyBzaGlm
dC4KdGhlbiB3ZSBjYW4gZ2V0IGNvcnJlY3Qgc29ja2V0IElECgphbHNvIHJlbW92ZSByZW1vdmUg
Y3B1X2RhdGEoMCkgcmVmZXJlbmNlLgpiZWNhdXNlIGNwdV9kYXRhKDApIG9ubHkgYmUgcmVhZHkg
YWZ0ZXIgc21wX3ByZXBhcmVfY3B1cyB3aXRoIHRoZSBhc3NpZ25tZW50CmZyb20gYm9vdF9jcHVf
ZGF0YSB0byBjdXJyZW50X2NwdV9kYXRhIGFrYSBjcHVfZGF0YSgwKS4KYW5kIGNoZWNrX2J1Z3Mo
KT09PmlkZW50aWZ5X2NwdSgmYm9vdF9jcHVfZGF0YSkgaXMgcXVpdGUgYmVmb3JlIHRoYW4gc21w
X3ByZXBhcmVfY3B1cy4Kc28ganVzdCB1c2UgYm9vdF9jcHVfaWQgaW5zdGVhZC4KClNpZ25lZC1v
ZmYtYnk6IFlpbmdoYWkgTHUgPHlobHUua2VybmVsQGdtYWlsLmNvbT4KCmRpZmYgLS1naXQgYS9h
cmNoL3g4Ni9rZXJuZWwvc2V0dXBfNjQuYyBiL2FyY2gveDg2L2tlcm5lbC9zZXR1cF82NC5jCmlu
ZGV4IGIwM2FkYWMuLmEzYzQzODUgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2tlcm5lbC9zZXR1cF82
NC5jCisrKyBiL2FyY2gveDg2L2tlcm5lbC9zZXR1cF82NC5jCkBAIC01NjYsNyArNTY2LDcgQEAg
c3RhdGljIHZvaWQgX19jcHVpbml0IGFtZF9kZXRlY3RfY21wKHN0cnVjdCBjcHVpbmZvX3g4NiAq
YykKIAkvKiBMb3cgb3JkZXIgYml0cyBkZWZpbmUgdGhlIGNvcmUgaWQgKGluZGV4IG9mIGNvcmUg
aW4gc29ja2V0KSAqLwogCWMtPmNwdV9jb3JlX2lkID0gYy0+cGh5c19wcm9jX2lkICYgKCgxIDw8
IGJpdHMpLTEpOwogCS8qIENvbnZlcnQgdGhlIEFQSUMgSUQgaW50byB0aGUgc29ja2V0IElEICov
Ci0JYy0+cGh5c19wcm9jX2lkID0gcGh5c19wa2dfaWQoYml0cyk7CisJYy0+cGh5c19wcm9jX2lk
ID0gKGMtPmFwaWNpZCAtIGJvb3RfY3B1X2lkKSA+PiBiaXRzOwogCiAjaWZkZWYgQ09ORklHX05V
TUEKIAlub2RlID0gYy0+cGh5c19wcm9jX2lkOwpAQCAtNTgzLDcgKzU4Myw3IEBAIHN0YXRpYyB2
b2lkIF9fY3B1aW5pdCBhbWRfZGV0ZWN0X2NtcChzdHJ1Y3QgY3B1aW5mb194ODYgKmMpCiAJCSAg
IElmIHRoYXQgZG9lc24ndCByZXN1bHQgaW4gYSB1c2FibGUgbm9kZSBmYWxsIGJhY2sgdG8gdGhl
CiAJCSAgIHBhdGggZm9yIHRoZSBwcmV2aW91cyBjYXNlLiAgKi8KIAotCQlpbnQgaHRfbm9kZWlk
ID0gYXBpY2lkIC0gKGNwdV9kYXRhKDApLnBoeXNfcHJvY19pZCA8PCBiaXRzKTsKKwkJaW50IGh0
X25vZGVpZCA9IGFwaWNpZCAtIGJvb3RfY3B1X2lkOwogCiAJCWlmIChodF9ub2RlaWQgPj0gMCAm
JgogCQkgICAgYXBpY2lkX3RvX25vZGVbaHRfbm9kZWlkXSAhPSBOVU1BX05PX05PREUpCg==
------=_Part_22238_30190936.1204794671638--
