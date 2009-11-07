Return-Path: <linux-kernel-owner+w=401wt.eu-S1751599AbZKGU7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbZKGU7M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 15:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZKGU7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 15:59:11 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:57322 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbZKGU7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 15:59:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=IfUutwM0wn+F992IsWlfI9v5AblYF9TQypQhYu6eT1+1sLUoDQfm4MMbgu7XCW0hsD
         DJHxYipgY7wqh1psW/VagSd7TRWpjRrLJsmSh1Nw03LJGfYtEpx0+8n3OTBUUSSwb71O
         MPJmGuhv6VDxs0cLFudAQWK2ixAVf0KvZh1oY=
Message-ID: <4AF5DF9F.5020208@tuffmail.co.uk>
Date: Sat, 07 Nov 2009 20:59:11 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel <linux-kernel@vger.kernel.org>, carmelo73@gmail.com,
       linux-kbuild@vger.kernel.org
Subject: [PATCH 0/10] module: Speed up symbol resolution during module loading
 (using binary search)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As requested by Mike Frysinger, this version of the series

1) generalizes the use of CONFIG_SYMBOL_PREFIX so that arbitrary symbol 
prefixes remain possible
2) uses CONFIG_SYMBOL_PREFIX to implement VMLINUX_SYMBOL() in the 
generic linker script, instead of relying on arch linker scripts to 
define it if needed.


I also changed the position of the patch which implements the above 
changes.  So it is possible to revert or drop the actual optimizations, 
without removing the cleanups and annoying Mike (or Rusty, or Tejun Heo, 
or miscellaneous fans of lib/bsearch.c :).

A clean revert may be useful if hash tables are added in future, to 
avoid the complexity of keeping hash tables + sorted tables + unsorted 
tables.  (This current series leaves module symbol tables unsorted).
