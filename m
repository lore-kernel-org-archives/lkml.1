Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbXHVBO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbXHVBO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 21:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbXHVBOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 21:14:48 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:15719 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbXHVBOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 21:14:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=eNImBXb2CuiaZJGhbD5yhAuzXCcyB/nWMM7ZtUnzXZzsJ3qStyp7rXke5mqPMprmqcVwCWAhMbzg/EzoOWfO1TnopaBNc50rNsxaID8V85UMjTPVcDYFL0Dk+vTQHw/KT24W3j4pz9kJZb9vYc4mOZLEl1GIr9W3ORR2qA5VQH0=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] ver_linux is [censored]
Date: Wed, 22 Aug 2007 03:11:56 +0200
User-Agent: KMail/1.9.7
Cc: Alexey Dobriyan <adobriyan@sw.ru>, sam@ravnborg.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org
References: <20070821071938.GA17761@localhost.sw.ru> <9a8748490708211702q7ed2649ft978cea8ab07b63fa@mail.gmail.com> <20070822005236.GF21089@ftp.linux.org.uk>
In-Reply-To: <20070822005236.GF21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708220311.56736.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix ver_linux glibc version printing (for real this time)

Alexey Dobriyan reported that commit 
4a645d5ea65baaa5736bcb566673bf4a351b2ad8
broke ver_linux when glibc has a 3 digit 
version number, and proposed a patch.
Al Viro then suggested a simpler way to 
solve the problem which I've then simply 
put into patch form.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Al Viro <viro@ftp.linux.org.uk>
Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 scripts/ver_linux |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/scripts/ver_linux b/scripts/ver_linux
index 8f8df93..5a16bad 100755
--- a/scripts/ver_linux
+++ b/scripts/ver_linux
@@ -65,9 +65,8 @@ isdnctrl 2>&1 | grep version | awk \
 showmount --version 2>&1 | grep nfs-utils | awk \
 'NR==1{print "nfs-utils             ", $NF}'
 
-ls -l `ldd /bin/sh | awk '/libc/{print $3}'` | sed \
--e 's/\.so$//' | sed -e 's/>//' | \
-awk -F'[.-]' '{print "Linux C Library        "$(NF-1)"."$NF}'
+echo -n "Linux C Library        "
+sed -n -e '/^.*\/libc-\([^/]*\)\.so$/{s//\1/;p;q}' < /proc/self/maps
 
 ldd -v > /dev/null 2>&1 && ldd -v || ldd --version |head -n 1 | awk \
 'NR==1{print "Dynamic linker (ldd)  ", $NF}'


