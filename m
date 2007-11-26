Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbXKZNci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbXKZNci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 08:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbXKZNcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 08:32:31 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:23999 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbXKZNca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 08:32:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type;
        b=btqElQqKMWoBwcDJpFVD4++5KlvnqBvcPlImoIHpEsWVPYEnMm0C5vXvR1mrT9DKtAIFotPCf9WNBak58Xe9bxCA6XpZnmIPuWoAJARJBTCsOkcxelX0Bw6q7VkzEGKB2WqHehnmEB6f5oDDtpOZp0A8rfsW42r5F3LYZ4WS31A=
Message-ID: <474ACAB3.4080307@gmail.com>
Date: Mon, 26 Nov 2007 08:31:31 -0500
From: Russell Harmon <eatnumber1@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071118)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix for sched-cfs sysctl.
Content-Type: multipart/mixed;
 boundary="------------000004040503000807020002"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000004040503000807020002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This trivial patch fixes a compilation error that occurs when 
CONFIG_FAIR_GROUP_SCHED and !CONFIG_SMP.

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 678223a..8bebf25 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -330,7 +330,7 @@ static struct ctl_table kern_table[] = {
                .mode           = 644,
                .proc_handler   = &proc_dointvec,
        },
-#ifdef CONFIG_FAIR_GROUP_SCHED
+#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
        {
                .ctl_name       = CTL_UNNUMBERED,
                .procname       = "sched_min_bal_int_shares",


--------------000004040503000807020002
Content-Type: text/plain;
 name="fix-sched-cfs-sysctl.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-sched-cfs-sysctl.patch"

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 678223a..8bebf25 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -330,7 +330,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 644,
 		.proc_handler	= &proc_dointvec,
 	},
-#ifdef CONFIG_FAIR_GROUP_SCHED
+#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_min_bal_int_shares",

--------------000004040503000807020002--
