Return-Path: <linux-kernel-owner+w=401wt.eu-S1759877AbZKFVVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877AbZKFVVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 16:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759725AbZKFVVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 16:21:23 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43486 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbZKFVVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 16:21:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=S81GmIpqG+fi8VB7R/25j9KVN/OgS19aXslsJv5HBszjF7YNIkM0OMmDnYGUmphIPA
         lbRYxrEeCMlARd9DBso0wZ9TSG8/E8bUoRUrH4ku0QlTF5A2mCmdAu4f/Q7HzkPWt5gp
         hF4BzOM/svjhDgEUh9gmAmHRpdP+FgTit6Oh0=
Message-ID: <4AF49365.5010601@gmail.com>
Date: Fri, 06 Nov 2009 13:21:41 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Dave Korn <dave.korn.cygwin@googlemail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gcc@gcc.gnu.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@cs.washington.edu>
Subject: Re: cc1plus invoked oom-killer: gfp_mask=0x280da, order=0, oom_adj=0
References: <dd18b0c30911021329g3c99a783n6b0a293240c3312c@mail.gmail.com>	 <20091103222432.4a94bd8f.akpm@linux-foundation.org>	 <4AF17DED.7080808@gmail.com> <4AF198E1.9010303@gmail.com>	 <4AF1A198.1090709@gmail.com>	 <dd18b0c30911040839ice58f81v7c8aa10e79f5d1b8@mail.gmail.com>	 <4AF1DA8D.9070009@gmail.com> <4AF1E66D.6060705@gmail.com>	 <dd18b0c30911041322y2cfd58f8m168550bbe3e8234b@mail.gmail.com>	 <4AF21E0C.90506@gmail.com> <dd18b0c30911041936i7876f2d1o7e31059cc44c644f@mail.gmail.com> <4AF25DCE.3010101@gmail.com>
In-Reply-To: <4AF25DCE.3010101@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Korn wrote:
> Justin Mattock wrote:
>
>
>    
>> ==1830== Command: c++ -o jsxml.o -c -DOSTYPE="Linux2.6" -DOSARCH=Linux
>>      
>
>    Ah, you're running it on the "c++" utility and it's reporting the stats for
> that, but how it works is that "c++" (and "gcc", "g++", et al) is just a
> driver, that parses the command line arguments and shells out to the actual
> compiler ("cc1plus"), assembler and linker to get them to do all the work.
>
>    If you add "-v --save-temps" to the c++ invocation, it'll show you the
> separate command lines it executes for the subprograms; the first invocation
> will be of cc1plus, using the -E flag to generate the preprocessed source into
> a .ii file, it's the second invocation you want, the one which uses the
> "-fpreprocessed" flag and names the .ii file as input, which is the one that
> actually then compiles the pre-processed source into assembly.  For fuller
> explanation, see the GCC wiki:
>
> http://gcc.gnu.org/wiki/DebuggingGCC
>
>      cheers,
>        DaveK
>
>
>
>    
o.k. after some reading and some experimenting,
I finally got firefox to compile all the way without a
memory leak..
here's what I found:
using the default .mozconfig I see during compiling there
is a -O3 in the CFLAGS(mozilla default optimization)
When using my optimization I use -O2
by mistake I accidentally forgot to add the -O2 while
tweaking my .mozconfig for a right CFLAGS to use for
debugging, in doing so firefox compiled all the way.

So using a custom CFLAGS in mozconfig and leaving out
-O* works..

Any ideas what might be happening here?

Justin P. Mattock
