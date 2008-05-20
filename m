Return-Path: <linux-kernel-owner+w=401wt.eu-S1764662AbYETUhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764662AbYETUhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 16:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759107AbYETUhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 16:37:41 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:50185 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758754AbYETUhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 16:37:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type:x-google-sender-auth;
        b=ceQktVKHpAw98zQnJOKosN7wQk/aawhws6dc+Myu4EvxJ/+PN/5TScNiDG4IOSr0pxRHsbfjefyTHMViAviabrkJXSEH+ApdPsNUyeeU+P2PR36J8VBn1U3BC15ieanLG6jNCBhGstkCONIH8yXg/UyjJIgBC5l93kVyGkRG9q0=
Message-ID: <3efb10970805201337g2212835bl9ca26a3031141ce2@mail.gmail.com>
Date: Tue, 20 May 2008 22:37:34 +0200
From: "Remy Bohmer" <linux@bohmer.net>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Compile bug in 2.6.24.8-rt7 on ARM
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_2645_8624103.1211315854875"
X-Google-Sender-Auth: c07c8707521c95a6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_2645_8624103.1211315854875
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Steven,

Now I started looking at compiling 2.6.24.7-rt8 for ARM, and I found
another compile problem... ;-))

This one:
 CC      arch/arm/kernel/process.o
arch/arm/kernel/process.c: In function 'cpu_idle':
arch/arm/kernel/process.c:175: error: implicit declaration of function
'trace_preempt_exit_idle'
arch/arm/kernel/process.c:180: error: implicit declaration of function
'trace_preempt_enter_idle'

These function do not appear to exist _anywhere_ in the kernel.
So these calls can safely be removed, I guess.

The offending patch can be found in the broken-out set under the name
arm-trace-preempt-idle.patch.
Attached you can find a fix for it (I expect that you will not need it)


Kind Regards,

Remy

------=_Part_2645_8624103.1211315854875
Content-Type: text/x-patch; name=fix-compile-error-trace-preempt.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fggy4u4u
Content-Disposition: attachment;
 filename=fix-compile-error-trace-preempt.patch

VGhpcyBwYXRjaCBmaXhlcyB0aGlzIGNvbXBpbGUgZXJyb3IgaW4gMi42LjI0LjctcnQ4OgogQ0Mg
ICAgICBhcmNoL2FybS9rZXJuZWwvcHJvY2Vzcy5vCmFyY2gvYXJtL2tlcm5lbC9wcm9jZXNzLmM6
IEluIGZ1bmN0aW9uICdjcHVfaWRsZSc6CmFyY2gvYXJtL2tlcm5lbC9wcm9jZXNzLmM6MTc1OiBl
cnJvcjogaW1wbGljaXQgZGVjbGFyYXRpb24gb2YgZnVuY3Rpb24gJ3RyYWNlX3ByZWVtcHRfZXhp
dF9pZGxlJwphcmNoL2FybS9rZXJuZWwvcHJvY2Vzcy5jOjE4MDogZXJyb3I6IGltcGxpY2l0IGRl
Y2xhcmF0aW9uIG9mIGZ1bmN0aW9uICd0cmFjZV9wcmVlbXB0X2VudGVyX2lkbGUnCgpTaWduZWQt
b2ZmLWJ5OiBSZW15IEJvaG1lciA8bGludXhAYm9obWVyLm5ldD4KLS0tCiBhcmNoL2FybS9rZXJu
ZWwvcHJvY2Vzcy5jIHwgICAgMiAtLQogMSBmaWxlIGNoYW5nZWQsIDIgZGVsZXRpb25zKC0pCgpJ
bmRleDogbGludXgtMi42LjI0L2FyY2gvYXJtL2tlcm5lbC9wcm9jZXNzLmMKPT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQot
LS0gbGludXgtMi42LjI0Lm9yaWcvYXJjaC9hcm0va2VybmVsL3Byb2Nlc3MuYwkyMDA4LTA1LTIw
IDIyOjA2OjMzLjAwMDAwMDAwMCArMDIwMAorKysgbGludXgtMi42LjI0L2FyY2gvYXJtL2tlcm5l
bC9wcm9jZXNzLmMJMjAwOC0wNS0yMCAyMjozMDozNy4wMDAwMDAwMDAgKzAyMDAKQEAgLTE3Miwx
MiArMTcyLDEwIEBAIHZvaWQgY3B1X2lkbGUodm9pZCkKIAkJCWlkbGUoKTsKIAkJbGVkc19ldmVu
dChsZWRfaWRsZV9lbmQpOwogCQlsb2NhbF9pcnFfZGlzYWJsZSgpOwotCQl0cmFjZV9wcmVlbXB0
X2V4aXRfaWRsZSgpOwogCQl0aWNrX25vaHpfcmVzdGFydF9zY2hlZF90aWNrKCk7CiAJCV9fcHJl
ZW1wdF9lbmFibGVfbm9fcmVzY2hlZCgpOwogCQlfX3NjaGVkdWxlKCk7CiAJCXByZWVtcHRfZGlz
YWJsZSgpOwotCQl0cmFjZV9wcmVlbXB0X2VudGVyX2lkbGUoKTsKIAkJbG9jYWxfaXJxX2VuYWJs
ZSgpOwogCX0KIH0K
------=_Part_2645_8624103.1211315854875--
