Return-Path: <linux-kernel-owner+w=401wt.eu-S932091AbZKDTdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbZKDTdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757889AbZKDTdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:33:07 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:54586 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757851AbZKDTdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:33:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xdxyXusmoGJe4PrfGLdubQDo64S+WDG/ZhlCZnys7tp1gBXqY+hPRjY1cWpHM1Un9h
         qIrcJGgPPtryzl+C0iMQKQivR953VYILd5gYnoRec66OqenIa+wX7qomPNvEPVdTRF8s
         pLrRRt0HElJrsFBwE2FPMOfBJzy7lc3TqHlCw=
Message-ID: <4AF1DA8D.9070009@gmail.com>
Date: Wed, 04 Nov 2009 19:48:29 +0000
From: Dave Korn <dave.korn.cygwin@googlemail.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: Dave Korn <dave.korn.cygwin@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gcc@gcc.gnu.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@cs.washington.edu>
Subject: Re: cc1plus invoked oom-killer: gfp_mask=0x280da, order=0, oom_adj=0
References: <dd18b0c30911021329g3c99a783n6b0a293240c3312c@mail.gmail.com>	 <20091103222432.4a94bd8f.akpm@linux-foundation.org>	 <4AF17DED.7080808@gmail.com> <4AF198E1.9010303@gmail.com>	 <4AF1A198.1090709@gmail.com> <dd18b0c30911040839ice58f81v7c8aa10e79f5d1b8@mail.gmail.com>
In-Reply-To: <dd18b0c30911040839ice58f81v7c8aa10e79f5d1b8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Mattock wrote:

> O.k. here is the info from dmesg(with the patch added)
> and what -fmem-report:

  I don't know how to read the oom dmesg, but as to the -fmem-report:

> Memory still allocated at the end of the compilation process
> Size   Allocated        Used    Overhead
> Total       7200k       5293k        104k

... what that's telling us is that there isn't a substantial leak in GCC, as
there's only 7 meg left unreclaimed by GC at the end.  I think we'll have to
wait and see what the debugger tells us; either GCC really is using that much
memory in processing the file, or there's some kind of system or kernel bug
you're running into that is causing a leak in the VMM rather than the application.

> String pool

> bytes           86k (17592186044415M overhead)

  0xFFFFFFFFFFF00000, lol, wut?  It's possible that indicates some sort of
memory corruption going on.  Maybe valgrind can help, do you have that?

    cheers,
      DaveK

