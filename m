Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbZFAJCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbZFAJCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 05:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756287AbZFAJBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 05:01:55 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:59340 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351AbZFAJBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 05:01:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=fznroOzcFlCulG2lZGqmXPCblFlX/0RS9MtQPhYyJrUZ0LD8P2D6QO8P2TQhbIDjap
         aFNrLNLSvNe+LthptRHbhEn4JAIxpccULjCGvPXz2ABWwAimCB28sJ5QRHLUSU0hm6DH
         qcr97bcoGB26o679GPOuP1m5aTILDw5EpzFsA=
MIME-Version: 1.0
Date: Mon, 1 Jun 2009 17:01:53 +0800
Message-ID: <3877989d0906010201j438a08a8x559f62b0aed40696@mail.gmail.com>
Subject: [RFC patch] reset TSC at the begining of check_tsc_warp
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001636e1fcf7702b39046b45ad5f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636e1fcf7702b39046b45ad5f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

Without this patch, we always get kernel warning that TSC warp between CPUs,
and TSC is marked unstable due to check_tsc_sync_source failed if the CPUs
have the problem of not-synced initial TSC.

It hurts CPUs with constant-tsc feature, but with unsynced initial TSC value...

The downside is we could break perfect synced TSC with this patch.
Please review, test and apply.

**The patch is enclosed in text attachment*
**Using web client to send the patch* *
**below is c&p just for review, please apply attached  patch*/

Thanks,
Luming



Signed-off-by: Yu Luming <luming.yu@intel.com>

 tsc_sync.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index bf36328..190c1b0 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -46,6 +46,7 @@ static __cpuinit void check_tsc_warp(void)
 	cycles_t start, now, prev, end;
 	int i;

+	wrmsrl(MSR_IA32_TSC, 0);
 	rdtsc_barrier();
 	start = get_cycles();
 	rdtsc_barrier();

--001636e1fcf7702b39046b45ad5f
Content-Type: application/octet-stream; name="2.patch"
Content-Disposition: attachment; filename="2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fveya7y50

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC90c2Nfc3luYy5jIGIvYXJjaC94ODYva2VybmVs
L3RzY19zeW5jLmMKaW5kZXggYmYzNjMyOC4uMTkwYzFiMCAxMDA2NDQKLS0tIGEvYXJjaC94ODYv
a2VybmVsL3RzY19zeW5jLmMKKysrIGIvYXJjaC94ODYva2VybmVsL3RzY19zeW5jLmMKQEAgLTQ2
LDYgKzQ2LDcgQEAgc3RhdGljIF9fY3B1aW5pdCB2b2lkIGNoZWNrX3RzY193YXJwKHZvaWQpCiAJ
Y3ljbGVzX3Qgc3RhcnQsIG5vdywgcHJldiwgZW5kOwogCWludCBpOwogCisJd3Jtc3JsKE1TUl9J
QTMyX1RTQywgMCk7CiAJcmR0c2NfYmFycmllcigpOwogCXN0YXJ0ID0gZ2V0X2N5Y2xlcygpOwog
CXJkdHNjX2JhcnJpZXIoKTsK
--001636e1fcf7702b39046b45ad5f--
