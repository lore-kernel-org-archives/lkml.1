Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbZFDKBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbZFDKBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 06:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbZFDKBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 06:01:39 -0400
Received: from mail-px0-f182.google.com ([209.85.216.182]:43089 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZFDKBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 06:01:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H15ZHuVL/NT4+NQ+8sYtNQIh1aEqEwBjx6gq8DW27pkLmvu6KgbEL/V6hjptCzr+G2
         ezY1pchtKVfZwwFoNSrUDZRy9W3RUYMVQU2EvB68XybZ4h+eTLqiibNd6QUwdjl8zB4i
         MixT4zd758DCl1LcmIQfsa9yFnf7CsiMV0KX4=
Date: Thu, 4 Jun 2009 17:56:23 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-kbuild@vger.kernel.org
Subject: Re: [Patch 1/2] kbuild: two trivial fixes for check headers
Message-ID: <20090604095623.GC7030@cr0.nay.redhat.com>
References: <20090604080406.7005.27662.sendpatchset@localhost.localdomain> <20090604091519.GA9571@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604091519.GA9571@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 11:15:19AM +0200, Sam Ravnborg wrote:
>On Thu, Jun 04, 2009 at 04:01:52AM -0400, Amerigo Wang wrote:
>> 
>> Remove a useless 'extern' in an exported header.
>> Fix a comment headers_check.pl.
>
>These two patches has nothing in commom.
>
>> 
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Cc: Sam Ravnborg <sam@ravnborg.org>
>> 
>> ------
>> diff --git a/include/mtd/jffs2-user.h b/include/mtd/jffs2-user.h
>> index fa94b0e..10dc7ef 100644
>> --- a/include/mtd/jffs2-user.h
>> +++ b/include/mtd/jffs2-user.h
>> @@ -18,7 +18,7 @@
>>  #undef je32_to_cpu
>>  #undef jemode_to_cpu
>>  
>> -extern int target_endian;
>> +int target_endian;
>
>You now declare a global variable named target_endian each time you include this file - which is wrong.

Hmmm, the script seems wrong, not the C code. :)
And the word 'prototype' is only for functions.

How about patch below?

Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index 56f90a4..11dc869 100644
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -2,7 +2,7 @@
 #
 # headers_check.pl execute a number of trivial consistency checks
 #
-# Usage: headers_check.pl dir [files...]
+# Usage: headers_check.pl dir arch [files...]
 # dir:   dir to look for included files
 # arch:  architecture
 # files: list of files to check
@@ -63,7 +63,7 @@ sub check_include
 
 sub check_prototypes
 {
-	if ($line =~ m/^\s*extern\b/) {
+	if ($line =~ m/^\s*extern\b.*\(.*\)/) {
 		printf STDERR "$filename:$lineno: extern's make no sense in userspace\n";
 	}
 }
