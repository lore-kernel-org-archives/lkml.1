Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbZGMLh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbZGMLh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 07:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbZGMLhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 07:37:55 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:32987 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387AbZGMLhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 07:37:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=k3gplPRiM4mlJCieQwqSnuVymWt5tVqt+QSzaUdl3VGU5l4jupeEGjOwiwU0CZJAHo
         u4+cjn6tsESFDNXdC7TkP4LVNQF9FFfVfoyRFDepi4weT4rF7iGoc+plqOZnxLTYRzZV
         E3gLef+2Co2QlnGDMMcLoM3xEu6y/tDMhaNwY=
Message-ID: <4A5B1CEA.4070806@gmail.com>
Date: Mon, 13 Jul 2009 13:39:22 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Bernd Petrovitsch <bernd@firmix.at>
Subject: Re: [PATCH] hvsi: Keep index within state_names[]
References: <4A5A748D.1000109@gmail.com>
In-Reply-To: <4A5A748D.1000109@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep index within state_names[]

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
> Hmm, using "hp->state" before the check is somewhat disturbing.

Ok. How about this?

diff --git a/drivers/char/hvsi.c b/drivers/char/hvsi.c
index 2989056..cacb8c3 100644
--- a/drivers/char/hvsi.c
+++ b/drivers/char/hvsi.c
@@ -194,10 +194,12 @@ static inline void print_state(struct hvsi_struct *hp)
 		"HVSI_WAIT_FOR_MCTRL_RESPONSE",
 		"HVSI_FSP_DIED",
 	};
-	const char *name = state_names[hp->state];
+	const char *name;
 
-	if (hp->state > ARRAY_SIZE(state_names))
+	if (hp->state >= ARRAY_SIZE(state_names))
 		name = "UNKNOWN";
+	else
+		name = state_names[hp->state];
 
 	pr_debug("hvsi%i: state = %s\n", hp->index, name);
 #endif /* DEBUG */
