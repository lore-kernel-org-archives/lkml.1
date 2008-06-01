Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbYFAQSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbYFAQSB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 12:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbYFAQRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 12:17:50 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:37528 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195AbYFAQRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 12:17:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=MH3ljfoltukz611sDlGofTFh9dQRXWSKdj/EoRADN4U0sOPfXdc+zSsbj/q2KY74K+/Y0THG7FGkAUULgiSMF9tqGmw4NV5kQID3DkY+xa/AlRXMHQ+m2mONCQ1tvQ9AuzQj02XnCQ2p1wmL+ILvO7glmKd8BUxEvQd4OZTcmEc=
Message-ID: <4842CB8F.2000702@gmail.com>
Date: Sun, 01 Jun 2008 21:47:19 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: rostedt@goodmis.org, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3][RFC] ftrace: track dynamic ftrace update failures
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven/Ingo,

In dynamic ftrace any record which fails gets freed to be recycled. This
happens normally during (although not limited to) tracing of init functions.
In general, failures can happen due to multiple reason, such as external
patching of kernel functions, instrumentation of the mcount calls-sites,
hardware error etc. As an example, in the case of kprobes if a probe is
installed on the mcount call site (before being converted to NOP or after) then
eventually ftrace will detect it and free the corresponding record. Kprobes
however will keep on single-sepping the instruction it installed the probe on.

These patches prevent freeing of records which have failed (except for init
functions). This prevents re-recording of failed functions and allows tracking
them so that they can be listed using a new debugfs file -> 'failures'. The
main change here is preventing removal of ftrace records from ftace_hash. This
way records can be looked up by their 'ip' at any time.

--
Regards,
Abhishek Sagar
