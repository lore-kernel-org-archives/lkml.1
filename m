Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198Ab0BHLlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 06:41:20 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:47894 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab0BHLlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 06:41:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=o6DiSs1ygWMPsOASF+ZrPOPkNJIqqBO6b4IF5zytnHviXOzRDYwZUkwnp6iepYM9Ri
         NrwnlO8O+ndJsuDiT5uy8zEeiaV9nEujwrhRHO2cEzqVAjBsT4NkHKlbK7H1dAAKtSpn
         eOcEQgs6PWjtxNGws0Zh7vLh5bjvtL3t9Dldo=
MIME-Version: 1.0
Date: Mon, 8 Feb 2010 19:41:16 +0800
Message-ID: <628d1651002080341k34331712l55797971b3546ba4@mail.gmail.com>
Subject: [PATCH] security/smack/smack.h: Fix smk_known length
From: wzt wzt <wzt.wzt@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jmorris@namei.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in security/smack/smack.h:
struct smack_known {
        struct list_head        list;
        char                    smk_known[SMK_LABELLEN];
but in security/smack/smack_access.c
void smack_from_cipso(u32 level, char *cp, char *result)
{
        strncpy(result, final, SMK_MAXLEN);
}
miss '\0'.

Signed-off-by: wzt <wzt.wzt@gmail.com>
Cc: Jmorris <jmorris@namei.org>

diff --git a/security/smack/smack.h b/security/smack/smack.h
index c6e9aca..600474b 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -109,7 +109,7 @@ struct smk_netlbladdr {
  */
 struct smack_known {
        struct list_head        list;
-       char                    smk_known[SMK_LABELLEN];
+       char                    smk_known[SMK_LABELLEN + 1]; /*
smk_known + \0 */
        u32                     smk_secid;
        struct smack_cipso      *smk_cipso;
        spinlock_t              smk_cipsolock; /* for changing cipso map */
