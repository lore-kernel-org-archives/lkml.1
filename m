Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942Ab0AZTLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab0AZTLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 14:11:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777Ab0AZTLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 14:11:00 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:45138 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab0AZTLA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 14:11:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=k0O1Wonbd/VuCuA3Paue5Y2nebvgQ8WpdOCZzp5isHGpRY3XQCEVHqeGhzCnE18xEg
         ke35Cldf37wovqgs76is2upiKUTbraVFTnSro+Hq/33AE499tSHUknXpVfks+PM2KlLt
         Ly/DYggKHtA7sUy55J4p3wisI5uoCGwOSyT2o=
MIME-Version: 1.0
In-Reply-To: <4B5F0452.1080306@suse.cz>
References: <d65b1b151001191029o66794c24t228177a8ca544e44@mail.gmail.com>
	 <2375c9f91001191926hc80dc50mb264f757295c1337@mail.gmail.com>
	 <d65b1b151001200706k7a60eaf9le2a6cf4e1227bdad@mail.gmail.com>
	 <2375c9f91001251955s1dfc70f9p94054b7824a4c4b7@mail.gmail.com>
	 <4B5F0452.1080306@suse.cz>
Date: Tue, 26 Jan 2010 20:10:58 +0100
Message-ID: <d65b1b151001261110j6c0561a1ifba2da0077698e54@mail.gmail.com>
Subject: Re: [PATCH] Use full path to dnsdomainname and domainname in 
	scripts/mkcompile_h
From: Glenn Sommer <glemsom@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/26 Michal Marek <mmarek@suse.cz>:
> On 26.1.2010 04:55, Américo Wang wrote:
>> On Wed, Jan 20, 2010 at 11:06 PM, Glenn Sommer <glemsom@gmail.com> wrote:
>>> Alternatively, if we want it to be more flexible(and allow the above)
>>> - we should do something like:
>>>
>>> domainname_executable=`which domainname`
>>> if [ ! -z "$domainname_executable" ] && [ -x "$domainname_executable" ]; then
>>>
>
> (or 'if command -v domainname >/dev/null 2>&1; then domainname ...')
>
>
>> Yeah, this seems better for me.
>
> Me too. Glenn, could you send a complete patch doing this? I'll add it
> to the kbuild tree then.
>
> Thanks,
> Michal
>

Yeah, good idea with "command -v" ! :)
( note: `command -v` will return true if the executable is found -
else it will return false. )

mkcompile_h is changed slightly in 2.6.32. Here's my new proposed patch:


--- scripts/mkcompile_h.orig	2010-01-26 18:59:37.000000000 +0100
+++ scripts/mkcompile_h	2010-01-26 20:03:42.000000000 +0100
@@ -67,9 +67,9 @@
   echo \#define LINUX_COMPILE_BY \"`whoami`\"
   echo \#define LINUX_COMPILE_HOST \"`hostname | $UTS_TRUNCATE`\"

-  if [ -x /bin/dnsdomainname ]; then
+  if [ `command -v dnsdomainname 2> /dev/null` ]; then
     domain=`dnsdomainname 2> /dev/null`
-  elif [ -x /bin/domainname ]; then
+  elif [ `command -v domainname 2> /dev/null` ]; then
     domain=`domainname 2> /dev/null`
   fi

Signed-off-by: Glenn Sommer <glemsom@gmail.com>
