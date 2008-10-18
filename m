Return-Path: <linux-kernel-owner+w=401wt.eu-S1752086AbYJREyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbYJREyg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 00:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbYJREy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 00:54:28 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:30342 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbYJREy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 00:54:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mgv5/RcLGWx8XnqNh+JFLm/YK7vVB9+sZkXCzuUrLg/uydY7BevLsGTd9AwXov5NMw
         6WGhjiJPA6DsaCic5jiP/HPMKJg4LLL/bWZau/EyxJf6/6bKQXsXMjasiR9NX3dEIzdr
         WBjACJqrzt3Hbnho2W6HsWVCmgEQU/0MZ2aZs=
Date: Sat, 18 Oct 2008 00:54:31 -0400
From: "J.R. Mauro" <jrm8005@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Lindent and __user, etc.
Message-ID: <20081018045431.GA9358@localhost>
References: <3aaafc130810141027p660efb62p92c586b1c40a5e71@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3aaafc130810141027p660efb62p92c586b1c40a5e71@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a patch that outlines the basic idea. Obviously more types should
be added to catch more things that Lindent currently misses if this change seems
beneficial.


Make Lindent aware of sparse annotations and integer declarations

Signed-off by: J.R. Mauro <jrm8005@gmail.com>
--

--- Lindent	2008-10-17 18:16:56.000000000 -0400
+++ Lindent-mod	2008-10-18 00:37:49.000000000 -0400
@@ -1,5 +1,7 @@
 #!/bin/sh
 PARAM="-npro -kr -i8 -ts8 -sob -l80 -ss -ncs -cp1"
+CHECK="-T __user -T __kernel -T __safe -T __force -T __nocast -T __iomem"
+TYPES="-T s8 -T u8 -T s16 -T u16 -T s32 -T u32 -T s64 -T u64"
 RES=`indent --version`
 V1=`echo $RES | cut -d' ' -f3 | cut -d'.' -f1`
 V2=`echo $RES | cut -d' ' -f3 | cut -d'.' -f2`
@@ -15,4 +17,4 @@ elif [ $V1 -eq 2 ]; then
     fi
   fi
 fi
-indent $PARAM "$@"
+indent $PARAM $CHECK $TYPES "$@"
