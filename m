Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbZKJCzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbZKJCzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 21:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbZKJCzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 21:55:00 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:50739 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbZKJCy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 21:54:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cW6vRekWFgg4XiiZT7IldrY5R2KjmAqepBgjnQO4NQQHuKx0t4xUnEPkQ5Wzph85BD
         0DPeVoxJFx9xOkmA0U68KmO1JYo31no0kf79DtkQxNQK9n9S6hdez7dAC1A73wGvcxtm
         qhdzKBx7lp24+17uMTAGjtML6yciRIGYjN26U=
Message-ID: <4AF8D620.5090205@gmail.com>
Date: Mon, 09 Nov 2009 18:55:28 -0800
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
I didn't think at the time, but when compiling
4.5.*(snapshot) I added the pure64 patch to
gcc, everything seemed to go fine, but maybe
there needs to be more to it.

would this might cause an issue(memory leak or something)
like what I was receiving even though there's a symlink
to lib64?

BTW: I just cleared the deck and started fresh,
compiled gcc+pure64 patch(snapshot) into a single directory,
and then looked at ldd /usr/bin/gcc*
I see it pointing to /lib64(looking on my other system with
4.4.1 it points to /lib)

Justin P. Mattock
