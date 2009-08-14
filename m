Return-Path: <linux-kernel-owner+w=401wt.eu-S1751259AbZHNEPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbZHNEPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 00:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbZHNEPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 00:15:00 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:3117 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbZHNEO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 00:14:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=FruUOwsgHL3EshSqzyguw87e8s8fuHpJ3Ae6uGw/40vE05f7WUIznnCQ/mgqSh2etT
         tg9QN8VCQm1mqj+Dg0DdgBRLgcDwp1Vu6ioLeEyCreZXQfsqNaJUs4MBmRFyJ4fDHDPc
         0Ns+ogzqciraUInTOYoh1B1wIpV0bYX1L+xtY=
MIME-Version: 1.0
Date: Fri, 14 Aug 2009 12:15:00 +0800
Message-ID: <3877989d0908132115n6d8c7caej4bc4c87ae7701cac@mail.gmail.com>
Subject: [RFC patch] need check TSC wrap unconditionally
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=000e0cd2dfceb610170471124bb6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd2dfceb610170471124bb6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi there,

we disabled tsc wrap check on any platform that has NOSTOP_TSC cpu. But this
will cause some real problem.For example, 1.CPU does has constant and
non_stop tsc, which means different CPU ticks at same rate in same domain,but
have been given different initial TSC value.Then at any given time,
CPUsare unsynchronized.
2. if those CPUs are sit in different domain..(multi-chassis cluster system?)

Please review. If make sense, please apply.

**The patch is enclosed in text attachment*
**Using web client to send the patch* *
**below is for review, please apply attached  patch*/

Thanks,
Luming

Signed-off-by: Yu Luming <luming.yu@intel.com>

 arch/x86/kernel/tsc_sync.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 027b5b4..312ba84 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -113,11 +113,6 @@ void __cpuinit check_tsc_sync_source(int cpu)
        if (unsynchronized_tsc())
                return;

-       if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE)) {
-               pr_info("Skipping synchronization checks as TSC is
reliable.\n");
-               return;
-       }
-
        pr_info("checking TSC synchronization [CPU#%d -> CPU#%d]:",
                smp_processor_id(), cpu);

@@ -171,7 +166,7 @@ void __cpuinit check_tsc_sync_target(void)
 {
        int cpus = 2;

-       if (unsynchronized_tsc() || boot_cpu_has(X86_FEATURE_TSC_RELIABLE))
+       if (unsynchronized_tsc())
                return;

        /*

--000e0cd2dfceb610170471124bb6
Content-Type: application/octet-stream; name=7
Content-Disposition: attachment; filename=7
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fyceou2e0

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC90c2Nfc3luYy5jIGIvYXJjaC94ODYva2VybmVs
L3RzY19zeW5jLmMKaW5kZXggMDI3YjViNC4uMzEyYmE4NCAxMDA2NDQKLS0tIGEvYXJjaC94ODYv
a2VybmVsL3RzY19zeW5jLmMKKysrIGIvYXJjaC94ODYva2VybmVsL3RzY19zeW5jLmMKQEAgLTEx
MywxMSArMTEzLDYgQEAgdm9pZCBfX2NwdWluaXQgY2hlY2tfdHNjX3N5bmNfc291cmNlKGludCBj
cHUpCiAJaWYgKHVuc3luY2hyb25pemVkX3RzYygpKQogCQlyZXR1cm47CiAKLQlpZiAoYm9vdF9j
cHVfaGFzKFg4Nl9GRUFUVVJFX1RTQ19SRUxJQUJMRSkpIHsKLQkJcHJfaW5mbygiU2tpcHBpbmcg
c3luY2hyb25pemF0aW9uIGNoZWNrcyBhcyBUU0MgaXMgcmVsaWFibGUuXG4iKTsKLQkJcmV0dXJu
OwotCX0KLQogCXByX2luZm8oImNoZWNraW5nIFRTQyBzeW5jaHJvbml6YXRpb24gW0NQVSMlZCAt
PiBDUFUjJWRdOiIsCiAJCXNtcF9wcm9jZXNzb3JfaWQoKSwgY3B1KTsKIApAQCAtMTcxLDcgKzE2
Niw3IEBAIHZvaWQgX19jcHVpbml0IGNoZWNrX3RzY19zeW5jX3RhcmdldCh2b2lkKQogewogCWlu
dCBjcHVzID0gMjsKIAotCWlmICh1bnN5bmNocm9uaXplZF90c2MoKSB8fCBib290X2NwdV9oYXMo
WDg2X0ZFQVRVUkVfVFNDX1JFTElBQkxFKSkKKwlpZiAodW5zeW5jaHJvbml6ZWRfdHNjKCkpCiAJ
CXJldHVybjsKIAogCS8qCg==
--000e0cd2dfceb610170471124bb6--
