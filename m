Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbZG1WsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbZG1WsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 18:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbZG1WsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 18:48:11 -0400
Received: from mail-bw0-f221.google.com ([209.85.218.221]:36637 "EHLO
	mail-bw0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbZG1WsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 18:48:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=NJh/I6wz6bqVVjWEmqM+MYnNBC++3gQjU4RUCzua+fBN1F9K7VOw4+dbWp7Jq3RXZZ
         QydEf7rsHJh1MDyi+XCe6PpaZctJOCUXpMWEads/pcxENMwrP19tShYvVEDDDc1Q+w7E
         aJiZ/rMP3jIHlN47mgkf5cTA3az+KAZhxsSGQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Avi Kivity <avi@redhat.com>
Subject: [PATCH] kvm: remove superfluous NULL pointer check in kvm_inject_pit_timer_irqs()
Date: Wed, 29 Jul 2009 00:46:38 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4-next-20090728-04869-gdae50fe-dirty; KDE/4.2.4; i686; ; )
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>, corbet@lwn.net, eteo@redhat.com,
       Julia Lawall <julia@diku.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907290046.40596.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] kvm: remove superfluous NULL pointer check in kvm_inject_pit_timer_irqs()

This takes care of the following entries from Dan's list:

arch/x86/kvm/i8254.c +714 kvm_inject_pit_timer_irqs(6) warning: variable derefenced in initializer 'vcpu'
arch/x86/kvm/i8254.c +714 kvm_inject_pit_timer_irqs(6) warning: variable derefenced before check 'vcpu'

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: corbet@lwn.net
Cc: eteo@redhat.com
Cc: Julia Lawall <julia@diku.dk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 arch/x86/kvm/i8254.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/arch/x86/kvm/i8254.c
===================================================================
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -713,7 +713,7 @@ void kvm_inject_pit_timer_irqs(struct kv
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_kpit_state *ps;
 
-	if (vcpu && pit) {
+	if (pit) {
 		int inject = 0;
 		ps = &pit->pit_state;
 
