Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbZCUXGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbZCUXGI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 19:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755420AbZCUXFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 19:05:54 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:56146 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbZCUXFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 19:05:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=G4/GRZf71rRmK05VHadp9BX9Wj+ro0cMUuLeWkAUyFVIK7k739QiRsttKJWoDzPrai
         ZMy1vUXMRGvJSqeuV5q1qHgiI1DS0eMxctnu8dxEEaNEqYTEUOyZS7gmiUrRaLzAwHMv
         GdVqjNjQyAFX8zd0aL/poPwKRKWtsVlKn/jC4=
Message-ID: <49C572CC.6090704@gmail.com>
Date: Sat, 21 Mar 2009 20:05:48 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090321)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: Dave Airlie <airlied@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Error: freeing invalid memtype
References: <49C03208.6050603@gmail.com> <1237399938.4529.208.camel@localhost.localdomain>
In-Reply-To: <1237399938.4529.208.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pallipadi, Venkatesh wrote:
> Kevin,
> 
> Can you please send me the output of
> # cat /debug/x86/pat_memtype_list
> 
> (with debugfs mounted at /debug) as soon as you login into X and also
> when you start seeing these errors with etracer and glxinfo.
> 

Here is the output before attempting to run glxinfo:

---------------------------------------
PAT memtype list:
uncached-minus @ 0x4fff0000-0x4fff1000
uncached-minus @ 0x4fff0000-0x4fff1000
uncached-minus @ 0x4fff0000-0x4fff4000
uncached-minus @ 0x4fff8000-0x4fff9000
write-combining @ 0xb0000000-0xb8000000
write-combining @ 0xb0000000-0xb8000000
write-combining @ 0xb0000000-0xb8000000
uncached-minus @ 0xcfef0000-0xcff00000
uncached-minus @ 0xcfef0000-0xcff00000
uncached-minus @ 0xcfef0000-0xcff00000
uncached-minus @ 0xcfef0000-0xcff00000
uncached-minus @ 0xcfef0000-0xcff00000
uncached-minus @ 0xcffff000-0xd0000000
uncached-minus @ 0xcffff000-0xd0000000
write-combining @ 0xd0000000-0xd0101000
write-combining @ 0xd0000000-0xd0101000
write-combining @ 0xd0101000-0xd0102000
write-combining @ 0xd0101000-0xd0102000
write-combining @ 0xd0101000-0xd0102000
write-combining @ 0xd0102000-0xd0302000
write-combining @ 0xd0102000-0xd0302000
write-combining @ 0xd0102000-0xd0302000
write-combining @ 0xd0102000-0xd0302000
write-combining @ 0xd0302000-0xd07e2000
write-combining @ 0xd0302000-0xd07e2000
---------------------------------------

and here is the output after:

---------------------------------------
PAT memtype list:
uncached-minus @ 0x4fff0000-0x4fff1000
uncached-minus @ 0x4fff0000-0x4fff1000
uncached-minus @ 0x4fff0000-0x4fff4000
uncached-minus @ 0x4fff8000-0x4fff9000
write-combining @ 0xb0000000-0xb8000000
write-combining @ 0xb0000000-0xb8000000
write-combining @ 0xb0000000-0xb8000000
uncached-minus @ 0xcfef0000-0xcff00000
uncached-minus @ 0xcfef0000-0xcff00000
uncached-minus @ 0xcfef0000-0xcff00000
uncached-minus @ 0xcfef0000-0xcff00000
uncached-minus @ 0xcfef0000-0xcff00000
uncached-minus @ 0xcffff000-0xd0000000
uncached-minus @ 0xcffff000-0xd0000000
write-combining @ 0xd0000000-0xd0101000
write-combining @ 0xd0000000-0xd0101000
write-combining @ 0xd0101000-0xd0102000
write-combining @ 0xd0101000-0xd0102000
write-combining @ 0xd0101000-0xd0102000
write-combining @ 0xd0102000-0xd0302000
write-combining @ 0xd0102000-0xd0302000
write-combining @ 0xd0102000-0xd0302000
write-combining @ 0xd0102000-0xd0302000
write-combining @ 0xd0102000-0xd0302000
write-combining @ 0xd0302000-0xd07e2000
write-combining @ 0xd0302000-0xd07e2000
---------------------------------------

The only difference is:

$ diff pat_before.txt pat_after.txt 
24a25
> write-combining @ 0xd0102000-0xd0302000

While dmesg got the following additions:

[ 9648.269894] glxinfo:2441 freeing invalid memtype d0102000-d0112000
[ 9648.269911] glxinfo:2441 freeing invalid memtype d0112000-d0122000
[ 9648.269923] glxinfo:2441 freeing invalid memtype d0122000-d0132000
[ 9648.269935] glxinfo:2441 freeing invalid memtype d0132000-d0142000
[ 9648.269947] glxinfo:2441 freeing invalid memtype d0142000-d0152000
[ 9648.269958] glxinfo:2441 freeing invalid memtype d0152000-d0162000
[ 9648.269970] glxinfo:2441 freeing invalid memtype d0162000-d0172000
[ 9648.269981] glxinfo:2441 freeing invalid memtype d0172000-d0182000
[ 9648.269992] glxinfo:2441 freeing invalid memtype d0182000-d0192000
[ 9648.270021] glxinfo:2441 freeing invalid memtype d0192000-d01a2000
[ 9648.270884] glxinfo:2441 freeing invalid memtype d01a2000-d01b2000
[ 9648.270897] glxinfo:2441 freeing invalid memtype d01b2000-d01c2000
[ 9648.270908] glxinfo:2441 freeing invalid memtype d01c2000-d01d2000
[ 9648.270920] glxinfo:2441 freeing invalid memtype d01d2000-d01e2000
[ 9648.270931] glxinfo:2441 freeing invalid memtype d01e2000-d01f2000
[ 9648.270942] glxinfo:2441 freeing invalid memtype d01f2000-d0202000
[ 9648.270954] glxinfo:2441 freeing invalid memtype d0202000-d0212000
[ 9648.270966] glxinfo:2441 freeing invalid memtype d0212000-d0222000
[ 9648.270977] glxinfo:2441 freeing invalid memtype d0222000-d0232000
[ 9648.270989] glxinfo:2441 freeing invalid memtype d0232000-d0242000
[ 9648.271012] glxinfo:2441 freeing invalid memtype d0242000-d0252000
[ 9648.271748] glxinfo:2441 freeing invalid memtype d0252000-d0262000
[ 9648.271760] glxinfo:2441 freeing invalid memtype d0262000-d0272000
[ 9648.271772] glxinfo:2441 freeing invalid memtype d0272000-d0282000
[ 9648.271783] glxinfo:2441 freeing invalid memtype d0282000-d0292000
[ 9648.271795] glxinfo:2441 freeing invalid memtype d0292000-d02a2000
[ 9648.271806] glxinfo:2441 freeing invalid memtype d02a2000-d02b2000
[ 9648.271818] glxinfo:2441 freeing invalid memtype d02b2000-d02c2000
[ 9648.271829] glxinfo:2441 freeing invalid memtype d02c2000-d02d2000
[ 9648.271841] glxinfo:2441 freeing invalid memtype d02d2000-d02e2000
[ 9648.271854] glxinfo:2441 freeing invalid memtype d02e2000-d02f2000
[ 9648.271865] glxinfo:2441 freeing invalid memtype d02f2000-d0302000


Does that help track down the problem?  I am about to try disabling PAT
in my config to see if that fixes things.

-- 
Kevin Winchester

