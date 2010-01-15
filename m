Return-Path: <linux-kernel-owner+w=401wt.eu-S1757794Ab0AOA1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab0AOA1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 19:27:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622Ab0AOA1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 19:27:06 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:42310 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab0AOA1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 19:27:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Bdotz8nS64adri/r2IQ4wTTEIocQkLhwYsPjIJxJKTKas1GmIY89sC2FhG5fAWUkRO
         QVoj8wZIsQn2WBCzB2T3OmFd18abh+udgD4gWzKXxYCxaFLWff7ANL+uuCcVHnta3vmh
         lr10qiJ+0uwz8bhbiTAAgRg4n0STQ2ccf/cFU=
Message-ID: <4B4FB766.1020805@gmail.com>
Date: Fri, 15 Jan 2010 01:31:34 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPICA: wrong acpi_parse_state assigned acpi_ps_init_scope()
 ?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assign the package end, not the last AML byte.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Is this right?

diff --git a/drivers/acpi/acpica/psscope.c b/drivers/acpi/acpica/psscope.c
index 2feca5c..a8dfe16 100644
--- a/drivers/acpi/acpica/psscope.c
+++ b/drivers/acpi/acpica/psscope.c
@@ -118,7 +118,7 @@ acpi_ps_init_scope(struct acpi_parse_state * parser_state,
 	scope->parse_scope.op = root_op;
 	scope->parse_scope.arg_count = ACPI_VAR_ARGS;
 	scope->parse_scope.arg_end = parser_state->aml_end;
-	scope->parse_scope.pkg_end = parser_state->aml_end;
+	scope->parse_scope.pkg_end = parser_state->pkg_end;
 
 	parser_state->scope = scope;
 	parser_state->start_op = root_op;
