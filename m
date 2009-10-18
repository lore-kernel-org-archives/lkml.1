Return-Path: <linux-kernel-owner+w=401wt.eu-S932096AbZJRW5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbZJRW5l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 18:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbZJRW5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 18:57:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:62235 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbZJRW5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 18:57:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZzwBAwnPQKnGQO7uC6TKxXkwMuys8/1Tz2hQYwmmlSFlfQh72Wd5C5BsCuxOxGqePj
         aSx8PtjO1IYiKJyiu44wtAe+90JPmDHI/0VNNvQJrW3revxwcNlH5TBU35vx7w1X9cx9
         2DMkWcoVUHER/G0xkn4QmUg8l9ldfkbYUJI90=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org,
       Felipe Contreras <felipe.contreras@gmail.com>,
       Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Myron Stowe <myron.stowe@hp.com>, linux-acpi@vger.kernel.org
Subject: [PATCH 4/7] acpi: processor: fix section mismatch
Date: Mon, 19 Oct 2009 01:54:31 +0300
Message-Id: <1255906474-25091-5-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: drivers/acpi/processor.o(.text+0x99a): Section mismatch in
reference from the function acpi_processor_add() to the function
.cpuinit.text:acpi_processor_power_init()

acpi_processor_add replaced acpi_processor_start which had __cpuinit.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/acpi/processor_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index c567b46..ec742a4 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -770,7 +770,7 @@ static struct notifier_block acpi_cpu_notifier =
 	    .notifier_call = acpi_cpu_soft_notify,
 };
 
-static int acpi_processor_add(struct acpi_device *device)
+static int __cpuinit acpi_processor_add(struct acpi_device *device)
 {
 	struct acpi_processor *pr = NULL;
 	int result = 0;
-- 
1.6.5.1

