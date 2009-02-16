Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbZBPO7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbZBPO7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 09:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbZBPO7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 09:59:22 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:14250 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbZBPO7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 09:59:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T/3ZmdGzHrwG/KdjSiJXYa5cGgTTL+pz7DwcwJ5rm1gwW0ofTqg9FireU+tT53/Zvf
         B+bpTWQSEIzOUfaK4CoKckbW1DbnFXi1BfS9YWprGWdBzhVQ1FeiOr0LcRCv2H2lGH3F
         JRfWUA58iYxga0/w6y9VLHU2RyhD5g0a6r4Dw=
MIME-Version: 1.0
In-Reply-To: <49996588.2040501@s5r6.in-berlin.de>
References: <ea11fea30902151039n447cc111medb9721a95af81a8@mail.gmail.com>
	 <49996588.2040501@s5r6.in-berlin.de>
Date: Mon, 16 Feb 2009 20:29:16 +0530
Message-ID: <ea11fea30902160659q58578152gea3f4da3821c8e0c@mail.gmail.com>
Subject: Re: [PATCH] Remove errors caught by checkpatch.pl in 
	kernel/utsname_sysctl.c
From: Manish Katiyar <mkatiyar@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors@vger.kernel.org, mkatiyar@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resending with changed changelog based on stefan's comments]

On Mon, Feb 16, 2009 at 6:39 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Manish Katiyar wrote:
>> --- a/kernel/utsname_sysctl.c
>> +++ b/kernel/utsname_sysctl.c
>> @@ -49,7 +49,7 @@ static int proc_do_uts_string(ctl_table *table, int
>> write, struct file *filp,
>>       int r;
>>       memcpy(&uts_table, table, sizeof(uts_table));
>>       uts_table.data = get_uts(table, write);
>> -     r = proc_dostring(&uts_table,write,filp,buffer,lenp, ppos);
>> +     r = proc_dostring(&uts_table, write, filp, buffer, lenp, ppos);
>>       put_uts(table, write, uts_table.data);
>>       return r;
>>  }
>> @@ -142,4 +142,4 @@ static int __init utsname_sysctl_init(void)
>>       return 0;
>>  }
>>
>> -__initcall(utsname_sysctl_init);
>> +device_initcall(utsname_sysctl_init);
>
> The changelog should note that this is a whitespace fix + initcall
> annotation change.
>
> That checkpatch was somehow involved in the creation of this patch is
> entirely uninteresting for the changelog.

Replace deprecated __initcall with equivalent device_initcall. Also
fix whitespaces.

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 kernel/utsname_sysctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/utsname_sysctl.c b/kernel/utsname_sysctl.c
index 3b34b35..d1dc4ca 100644
--- a/kernel/utsname_sysctl.c
+++ b/kernel/utsname_sysctl.c
@@ -49,7 +49,7 @@ static int proc_do_uts_string(ctl_table *table, int
write, struct file *filp,
 	int r;
 	memcpy(&uts_table, table, sizeof(uts_table));
 	uts_table.data = get_uts(table, write);
-	r = proc_dostring(&uts_table,write,filp,buffer,lenp, ppos);
+	r = proc_dostring(&uts_table, write, filp, buffer, lenp, ppos);
 	put_uts(table, write, uts_table.data);
 	return r;
 }
@@ -142,4 +142,4 @@ static int __init utsname_sysctl_init(void)
 	return 0;
 }

-__initcall(utsname_sysctl_init);
+device_initcall(utsname_sysctl_init);
-- 
1.5.4.3


Thanks -
Manish

> --
> Stefan Richter
> -=====-==--= --=- =----
> http://arcgraph.de/sr/
>
