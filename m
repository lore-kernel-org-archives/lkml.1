Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbZKEExH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbZKEExH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 23:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbZKEExG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 23:53:06 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:33199 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbZKEExF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 23:53:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TpMceHvJbXuvUl31cZ6DYfOWmRdJnhGRc6khR20gE2pK5Kd4M9heWrbX4u0D8vuY01
         9enxKDQPZ0nn+ZxQ+L6mlFaY1+qIoijj+XwxD4C7KUpDciT8NrcuayLmQ9Jz9/FsC6oi
         BAyOyWE8K3QwkD+6baRcubjHRbWIIQ7KQaY5I=
Message-ID: <4AF25DCE.3010101@gmail.com>
Date: Thu, 05 Nov 2009 05:08:30 +0000
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
References: <dd18b0c30911021329g3c99a783n6b0a293240c3312c@mail.gmail.com>	 <20091103222432.4a94bd8f.akpm@linux-foundation.org>	 <4AF17DED.7080808@gmail.com> <4AF198E1.9010303@gmail.com>	 <4AF1A198.1090709@gmail.com>	 <dd18b0c30911040839ice58f81v7c8aa10e79f5d1b8@mail.gmail.com>	 <4AF1DA8D.9070009@gmail.com> <4AF1E66D.6060705@gmail.com>	 <dd18b0c30911041322y2cfd58f8m168550bbe3e8234b@mail.gmail.com>	 <4AF21E0C.90506@gmail.com> <dd18b0c30911041936i7876f2d1o7e31059cc44c644f@mail.gmail.com>
In-Reply-To: <dd18b0c30911041936i7876f2d1o7e31059cc44c644f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Mattock wrote:


> ==1830== Command: c++ -o jsxml.o -c -DOSTYPE="Linux2.6" -DOSARCH=Linux

  Ah, you're running it on the "c++" utility and it's reporting the stats for
that, but how it works is that "c++" (and "gcc", "g++", et al) is just a
driver, that parses the command line arguments and shells out to the actual
compiler ("cc1plus"), assembler and linker to get them to do all the work.

  If you add "-v --save-temps" to the c++ invocation, it'll show you the
separate command lines it executes for the subprograms; the first invocation
will be of cc1plus, using the -E flag to generate the preprocessed source into
a .ii file, it's the second invocation you want, the one which uses the
"-fpreprocessed" flag and names the .ii file as input, which is the one that
actually then compiles the pre-processed source into assembly.  For fuller
explanation, see the GCC wiki:

http://gcc.gnu.org/wiki/DebuggingGCC

    cheers,
      DaveK


