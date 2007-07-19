Return-Path: <linux-kernel-owner+w=401wt.eu-S938027AbXGSOPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938027AbXGSOPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939193AbXGSOKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:10:30 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:19763 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939187AbXGSOK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:10:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=S9hhtyIbrwomabxAudOhHUqf8/JVxxL98WD/OGJgqmoGI1JIW4pryPH4LwGN4d5fsG/x7N2zWSj5Iq0BC8Ui0wpUB8NE8348r42qUgQSbmbhn51JipGDCPccD6LDRhk3BZTlRflAWwmqjhnV/p/n6A8WQqVCDlRKGDup6WfWUCk=
Message-ID: <44c63dc40707190710rcd97947jbb044cb22c73f11b@mail.gmail.com>
Date: Thu, 19 Jul 2007 23:10:26 +0900
From: barrios <barrioskmc@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: __pdflush have an unnecessary code ?
Cc: akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When pdflush kernel thread is died, Why do it store current jiffies in
when_i_went_to_sleep variable ?
IMHO, __pdflush function have an unnecessary code although it is trivial.
If my thought is wrong, please give me a answer.

---
 mm/pdflush.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/pdflush.c b/mm/pdflush.c
index 8f6ee07..96aa1da 100644
--- a/mm/pdflush.c
+++ b/mm/pdflush.c
@@ -153,7 +153,6 @@ static int __pdflush(struct pdflush_work *my_work)
                pdf = list_entry(pdflush_list.prev, struct pdflush_work, list);
                if (jiffies - pdf->when_i_went_to_sleep > 1 * HZ) {
                        /* Limit exit rate */
-                       pdf->when_i_went_to_sleep = jiffies;
                        break;                                  /* exeunt */
                }
        }
--
