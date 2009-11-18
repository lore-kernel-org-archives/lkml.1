Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbZKREp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbZKREp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 23:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbZKREp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 23:45:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34574 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055AbZKREp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 23:45:26 -0500
Message-ID: <4B037B3A.7010700@zytor.com>
Date: Tue, 17 Nov 2009 20:42:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Masami Hiramatsu <mhiramat@redhat.com>, linux-next@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Randy Dunlap <rdunlap@xenotime.net>, Jim Keniston <jkenisto@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -next 0/3] x86 insn decoder test updates (Re: linux-next:
 Tree for October 29 (x86 posttest))
References: <20091116230611.5250.86656.stgit@harusame> <20091117061352.GE30852@elte.hu>
In-Reply-To: <20091117061352.GE30852@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2009 10:13 PM, Ingo Molnar wrote:
> 
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> Here are the patches which update x86 instruction decoder build-time 
>> test. As Stephen reported on linux-next, sometimes objdump decodes bad 
>> instructions as normal. This will cause a false positive result on x86 
>> insn decoder test. This patches update the test as below;
>>
>>  - Show more information with V=1
>>  - Show in which symbol the difference places.
>>  - Just warning instead of build failure.
> 
> yes, -tip testing was showing such build bugs too:
> 
>  Error: ffffffff8104aae3:	c5 83 3d 49 80 ee    	lds    0xffffffffee80493d(%rbx),%eax
>  Error: objdump says 6 bytes, but insn_get_length() says 3 (attr:0)
> 
> it happens with older tools, such as binutils-2.17. Modern binutils 
> (2.19) is fine.
> 
> We dont want to remove the build error: it helped us fix a number of 
> real bugs in the decoder - instead please try to create a make based 
> workaround based on binutils, to not run the test with binutils older 
> than 2.19 or so.
> 

One idea might be to instead of binutils to use NASM.  The entire NASM
disassembler is small enough (about 10,000 lines including build tools
and instruction database) that we could fit it in the tree in a pinch.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

