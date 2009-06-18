Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbZFRJoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbZFRJoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 05:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbZFRJn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 05:43:56 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:40100 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbZFRJnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 05:43:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f1h3zfVLIoR0G1p+cxaX89qcjImlMRPrwjz8jhgx5ohuUV4j08KGoitROQ9fQNGt2X
         3IgGSqUp90n5REoSP1YlAwfXag6IxmtlYDiLpNMYZ/KTj9jj1jW8O1TJ8c7BwtN5+3ss
         J6DgKfBVBLDym8XrWlylv2KvqWX+0wnsdBR2k=
Date: Thu, 18 Jun 2009 17:46:04 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       samr <sam@ravnborg.org>
Subject: Re: kbuild docs regression
Message-ID: <20090618094604.GC6133@cr0.nay.redhat.com>
References: <4A367744.2050207@oracle.com> <4A379AA6.9030508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A379AA6.9030508@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 03:14:14PM +0200, Jiri Slaby wrote:
>On 06/15/2009 06:31 PM, Randy Dunlap wrote:
>> make htmldocs
>> without using "O=dir" now (as of 2.6.30-git8) fails with
>> 
>>   DOCPROC Documentation/DocBook/deviceiobook.xml
>>   DOCPROC Documentation/DocBook/device-drivers.xml
>> exec /scripts/kernel-doc: No such file or directory
>> exec /scripts/kernel-doc: No such file or directory
>> make[1]: *** [Documentation/DocBook/deviceiobook.xml] Error 1
>> 
>> (+ more)
>> 
>> Using V=1 shows that SRCTREE is set but KBUILD_SRC is not set:
>
>Hmm, thanks, actually it's set, but it's empty :(. Is it expected, or is
>it a build-sys bug?

No, it is a bug of docproc. Patch below fixes it.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/scripts/basic/docproc.c b/scripts/basic/docproc.c
index 4c9523e..99ca7a6 100644
--- a/scripts/basic/docproc.c
+++ b/scripts/basic/docproc.c
@@ -385,7 +385,7 @@ int main(int argc, char *argv[])
 	if (!srctree)
 		srctree = getcwd(NULL, 0);
 	kernsrctree = getenv("KBUILD_SRC");
-	if (!kernsrctree)
+	if (!kernsrctree || !*kernsrctree)
 		kernsrctree = srctree;
 	if (argc != 3) {
 		usage();
