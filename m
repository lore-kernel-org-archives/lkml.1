Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbYKBWXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbYKBWXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 17:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbYKBWXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 17:23:15 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:47695 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbYKBWXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 17:23:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:references:x-google-sender-auth;
        b=uSvNzuCqTKia8/C5EvImQnM1nL5Jrr4ql3TgC4gIqZwFGrocNb5N0BCsFIW3oeF4rW
         yn6id2iNFbYws0LPfoETi5hnNVheJQeILATidtw9A7iw9wrfajxhJyYifwugERyzdx/t
         yVbVoLQZaUssbaXAPGbYkKEDOsw2dU6vEqwY0=
Message-ID: <5ff4a1e50811021423l795dd059v3d1667fb4bc9539c@mail.gmail.com>
Date: Sun, 2 Nov 2008 22:23:13 +0000
From: "Matt Fleming" <mjf@gentoo.org>
To: "Will Newton" <will.newton@gmail.com>
Subject: Re: [PATCH 2/3] HPET: Enter hpet_interrupt_handler with interrupts disabled
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       venkatesh.pallipadi@intel.com
In-Reply-To: <87a5b0800811021335nfe6202fwc00681ec96d9816c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_34419_30611101.1225664593350"
References: <1225641860-6120-1-git-send-email-mjf@gentoo.org>
	 <1225641860-6120-2-git-send-email-mjf@gentoo.org>
	 <87a5b0800811021335nfe6202fwc00681ec96d9816c@mail.gmail.com>
X-Google-Sender-Auth: 77369b073d32b668
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_34419_30611101.1225664593350
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/11/2 Will Newton <will.newton@gmail.com>:
>
> Combining IRQF_DISABLED and IRQF_SHARED does not reliably disable
> interrupts in the handler. Perhaps IRQF_SHARED should be removed at
> the same time?
>

I didn't know that. Under what conditions is it unreliable?

I've attached a second attempt at this patch. It seems that the IRQ is
never shared anyway, so I followed your suggestion and removed
IRQF_SHARED. My machine seems to be running fine.

>From c445728f36de599770088e345fc03ef9fafd8470 Mon Sep 17 00:00:00 2001
From: Matt Fleming <mjf@gentoo.org>
Date: Sun, 2 Nov 2008 14:00:23 +0000
Subject: [PATCH 2/3] HPET: Enter hpet_interrupt_handler with interrupts disabled

Some functions that may be called from this handler require that
interrupts are disabled. Also, combining IRQF_DISABLED and
IRQF_SHARED does not reliably disable interrupts in a handler, so
remove IRQF_SHARED from the irq flags (this irq is not shared anyway).

Signed-off-by: Matt Fleming <mjf@gentoo.org>
---
 arch/x86/kernel/hpet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index f10f946..bfb17f4 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -445,7 +445,7 @@ static int hpet_setup_irq(struct hpet_dev *dev)
 {

        if (request_irq(dev->irq, hpet_interrupt_handler,
-                       IRQF_SHARED|IRQF_NOBALANCING, dev->name, dev))
+                       IRQF_DISABLED|IRQF_NOBALANCING, dev->name, dev))
                return -1;

        disable_irq(dev->irq);
--
1.5.6.4

------=_Part_34419_30611101.1225664593350
Content-Type: application/octet-stream;
 name=0002-HPET-Enter-hpet_interrupt_handler-with-interrupts-d.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fn290xlx0
Content-Disposition: attachment;
 filename=0002-HPET-Enter-hpet_interrupt_handler-with-interrupts-d.patch

RnJvbSBjNDQ1NzI4ZjM2ZGU1OTk3NzAwODhlMzQ1ZmMwM2VmOWZhZmQ4NDcwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXR0IEZsZW1pbmcgPG1qZkBnZW50b28ub3JnPgpEYXRlOiBT
dW4sIDIgTm92IDIwMDggMTQ6MDA6MjMgKzAwMDAKU3ViamVjdDogW1BBVENIIDIvM10gSFBFVDog
RW50ZXIgaHBldF9pbnRlcnJ1cHRfaGFuZGxlciB3aXRoIGludGVycnVwdHMgZGlzYWJsZWQKClNv
bWUgZnVuY3Rpb25zIHRoYXQgbWF5IGJlIGNhbGxlZCBmcm9tIHRoaXMgaGFuZGxlciByZXF1aXJl
IHRoYXQKaW50ZXJydXB0cyBhcmUgZGlzYWJsZWQuIEFsc28sIGNvbWJpbmluZyBJUlFGX0RJU0FC
TEVEIGFuZApJUlFGX1NIQVJFRCBkb2VzIG5vdCByZWxpYWJseSBkaXNhYmxlIGludGVycnVwdHMg
aW4gYSBoYW5kbGVyLCBzbwpyZW1vdmUgSVJRRl9TSEFSRUQgZnJvbSB0aGUgaXJxIGZsYWdzICh0
aGlzIGlycSBpcyBub3Qgc2hhcmVkIGFueXdheSkuCgpTaWduZWQtb2ZmLWJ5OiBNYXR0IEZsZW1p
bmcgPG1qZkBnZW50b28ub3JnPgotLS0KIGFyY2gveDg2L2tlcm5lbC9ocGV0LmMgfCAgICAyICst
CiAxIGZpbGVzIGNoYW5nZWQsIDEgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvaHBldC5jIGIvYXJjaC94ODYva2VybmVsL2hwZXQuYwpp
bmRleCBmMTBmOTQ2Li5iZmIxN2Y0IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvaHBldC5j
CisrKyBiL2FyY2gveDg2L2tlcm5lbC9ocGV0LmMKQEAgLTQ0NSw3ICs0NDUsNyBAQCBzdGF0aWMg
aW50IGhwZXRfc2V0dXBfaXJxKHN0cnVjdCBocGV0X2RldiAqZGV2KQogewogCiAJaWYgKHJlcXVl
c3RfaXJxKGRldi0+aXJxLCBocGV0X2ludGVycnVwdF9oYW5kbGVyLAotCQkJSVJRRl9TSEFSRUR8
SVJRRl9OT0JBTEFOQ0lORywgZGV2LT5uYW1lLCBkZXYpKQorCQkJSVJRRl9ESVNBQkxFRHxJUlFG
X05PQkFMQU5DSU5HLCBkZXYtPm5hbWUsIGRldikpCiAJCXJldHVybiAtMTsKIAogCWRpc2FibGVf
aXJxKGRldi0+aXJxKTsKLS0gCjEuNS42LjQKCg==
------=_Part_34419_30611101.1225664593350--
