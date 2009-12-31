Return-Path: <linux-kernel-owner+w=401wt.eu-S1751470AbZLaLxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbZLaLxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 06:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbZLaLxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 06:53:46 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50398 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbZLaLxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 06:53:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=S1i9lRrgY79PeAmNYjtpbey1CbCpFQS0a4be4p390d1RRo6CQV92RfmYArozWkkM39
         tLENvaaes3gus/vig/jQJzNeyqbUam6adi6eKVZKspse/kvDJ3AmJZDOfKFJx+41R41/
         31Sgff7LID7eEVJL83Ki+h+pA93evL0jz5Rts=
Message-ID: <4B3C9186.3090904@gmail.com>
Date: Thu, 31 Dec 2009 12:56:54 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI: Fix &&/|| confusion in acpi_evaluate_string() (in comment)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This always evaluates to true.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/acpi/utils.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

It's between an #if 0 ... #endif.

diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index 811fec1..3495b43 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -312,7 +312,7 @@ acpi_evaluate_string(acpi_handle handle,
 	element = (acpi_object *) buffer.pointer;
 
 	if ((element->type != ACPI_TYPE_STRING)
-	    || (element->type != ACPI_TYPE_BUFFER)
+	    && (element->type != ACPI_TYPE_BUFFER)
 	    || !element->string.length) {
 		acpi_util_eval_error(handle, pathname, AE_BAD_DATA);
 		return AE_BAD_DATA;
