Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbYCCMDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbYCCMDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYCCMC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:02:58 -0500
Received: from gv-out-0910.google.com ([216.239.58.188]:11383 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYCCMC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:02:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=Zi3W+wz2fN/duhy6XfriIS7jziF2eWLGd+b+dLgOMyov91rNQ4PRl3C/2nBGDaEhQiRRVVykT9bc4+meCeKJ9zcwfF+jR4yW+XQ4he0I5bR8aJ1AJsdiOnwP0mnHKJXr/kZK9h5fz6K2s01xEgCiiVapl+H9WcIRdePQjRAXdgY=
Message-ID: <b647ffbd0803030402t3a0a9acej75bc92be39db5204@mail.gmail.com>
Date: Mon, 3 Mar 2008 13:02:51 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: yi.y.yang@intel.com
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are dealocked when cpu is set to offline
Cc: "Ingo Molnar" <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080303115652.GA9257@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_2035_1011718.1204545771292"
References: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com>
	 <b647ffbd0803030354s268089fo8e5b8f647ada0aae@mail.gmail.com>
	 <20080303115652.GA9257@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_2035_1011718.1204545771292
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 03/03/2008, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
>
>  >                 per_cpu(watchdog_task, hotcpu) = NULL;
>  > +               mlseep(1);
>
>
> that wont build very well ...

yeah, I forgot to mention that it's not even compile-tested :-/
I re-created it from scratch instead of looking for the original one.

please, this one (again, not compile-tested)

--- softlockup-prev-2.c 2008-03-03 12:38:36.000000000 +0100
+++ softlockup.c        2008-03-03 13:00:20.000000000 +0100
@@ -294,6 +294,7 @@ cpu_callback(struct notifier_block *nfb,
        case CPU_DEAD_FROZEN:
                p = per_cpu(watchdog_task, hotcpu);
                per_cpu(watchdog_task, hotcpu) = NULL;
+               msleep(1);
                kthread_stop(p);
                break;
 #endif /* CONFIG_HOTPLUG_CPU */


-- 
Best regards,
Dmitry Adamushko

------=_Part_2035_1011718.1204545771292
Content-Type: text/x-patch; name=softlockup-debug-2.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdczer44
Content-Disposition: attachment; filename=softlockup-debug-2.patch

LS0tIHNvZnRsb2NrdXAtcHJldi0yLmMJMjAwOC0wMy0wMyAxMjozODozNi4wMDAwMDAwMDAgKzAx
MDAKKysrIHNvZnRsb2NrdXAuYwkyMDA4LTAzLTAzIDEzOjAwOjIwLjAwMDAwMDAwMCArMDEwMApA
QCAtMjk0LDYgKzI5NCw3IEBAIGNwdV9jYWxsYmFjayhzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKm5m
YiwKIAljYXNlIENQVV9ERUFEX0ZST1pFTjoKIAkJcCA9IHBlcl9jcHUod2F0Y2hkb2dfdGFzaywg
aG90Y3B1KTsKIAkJcGVyX2NwdSh3YXRjaGRvZ190YXNrLCBob3RjcHUpID0gTlVMTDsKKwkJbXNs
ZWVwKDEpOwogCQlrdGhyZWFkX3N0b3AocCk7CiAJCWJyZWFrOwogI2VuZGlmIC8qIENPTkZJR19I
T1RQTFVHX0NQVSAqLwo=
------=_Part_2035_1011718.1204545771292--
