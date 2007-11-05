Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbXKEIMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbXKEIMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 03:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbXKEIMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 03:12:44 -0500
Received: from ro-out-1112.google.com ([72.14.202.182]:58634 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbXKEIMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 03:12:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=el2qnpkOJe+YR8etJwLiVDCrwGelWxYLS1eLfMhrgHAWHlioPrkTivDAEVrlLhVSToc0ECi4SjgxvtWr8cOz2G1EgWjubnpJYPL2Kg3x8W0z/8tWpgWm5SfL5RKvp50E83kKXBbXa8mODUrzuV5K3HICGRRawhaTVmiBbUCPPfM=
Date: Mon, 5 Nov 2007 16:11:44 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [git Patch] Makefile: Remove ncscope.out when make mrproper
Message-ID: <20071105081144.GE2461@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20071105073233.GC2461@hacking> <20071105074137.GA26540@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071105074137.GA26540@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 08:41:37AM +0100, Sam Ravnborg wrote:

<snip>

>
>Hi WANG.
>
>ncscope.out is just a temporary file but I see why you like to have it covered.

Thanks. ;)

>How about modifying the rule to look like this:
>> -		  Module.symvers tags TAGS cscope*
>> +		  Module.symvers tags TAGS *cscope*
>
>Or is this to broad a pattern?
>
>	Sam

Yes, that is better. New patch below.


Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
Index: linux-2.6/Makefile
===================================================================
--- linux-2.6.orig/Makefile
+++ linux-2.6/Makefile
@@ -1073,7 +1073,7 @@ MRPROPER_DIRS  += include/config include
 MRPROPER_FILES += .config .config.old include/asm .version .old_version \
                   include/linux/autoconf.h include/linux/version.h      \
                   include/linux/utsrelease.h                            \
-		  Module.symvers tags TAGS cscope*
+		  Module.symvers tags TAGS *cscope*
 
 # clean - Delete most, but leave enough to build external modules
 #
