Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbZEUQnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbZEUQnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 12:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbZEUQm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 12:42:57 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:54797 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZEUQm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 12:42:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xoAIOYoSdw1tYRqULIKO3axXF3boZdCzUwHdwAoucWmMqRktV6uQ6pL9bIQjdv/F/8
         pgTAvmZjoXcFbqaTXczDF1UrtSWzfvV3ylFpeA8X0EILLSwEf+qf6P+PObH4hCCP+CWW
         DZzgrO0oh1YU2tuFho8nZ4QgDfJeJe2UeX0V4=
Message-ID: <4A15848E.5030403@gmail.com>
Date: Thu, 21 May 2009 18:42:54 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: jmorris@namei.org, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] smack:beyond ARRAY_SIZE of data
References: <4A141F83.10102@gmail.com> <4A1483E0.1030303@schaufler-ca.com>
In-Reply-To: <4A1483E0.1030303@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not go beyond ARRAY_SIZE of data

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
>> -	if (count < SMK_NETLBLADDRMIN || count > SMK_NETLBLADDRMAX)
>> +	if (count < SMK_NETLBLADDRMIN || count >= SMK_NETLBLADDRMAX)
>>   
> 
> There is a problem here, but this won't fix it. The buffer needs to be
> allocated bigger than the potential contents (should be
> SMK_NETLBLADDRMAX + 1 instead of SMK_NETLBLADDRMAX. Your patch will clip
> the last byte off of a maximum length specification.

Ok, how about this?

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index e03a7e1..10a4604 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -775,7 +775,7 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 	struct sockaddr_in newname;
 	char smack[SMK_LABELLEN];
 	char *sp;
-	char data[SMK_NETLBLADDRMAX];
+	char data[SMK_NETLBLADDRMAX + 1];
 	char *host = (char *)&newname.sin_addr.s_addr;
 	int rc;
 	struct netlbl_audit audit_info;

