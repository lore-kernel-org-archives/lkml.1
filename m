Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbZHQPws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbZHQPws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 11:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbZHQPwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 11:52:46 -0400
Received: from bitwagon.com ([74.82.39.175]:36998 "HELO bitwagon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752785AbZHQPwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 11:52:45 -0400
Message-ID: <4A897CCA.7030809@bitwagon.com>
Date: Mon, 17 Aug 2009 08:52:42 -0700
From: John Reiser <jreiser@bitwagon.com>
Organization: -
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Steven Rostedt <srostedt@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: recordmcount commutes with "ld -r"
References: <4A8040D8.8020504@bitwagon.com> <alpine.DEB.2.00.0908171025140.20915@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0908171025140.20915@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2009 07:33 AM, Steven Rostedt wrote:

> On Mon, 10 Aug 2009, John Reiser wrote:

>> recordmcount commutes with "ld -r".  ...

> Running the linking on the built-in.o and *.ko files is a good idea.

I'll see what it takes to patch scripts/Makefile.build and any other
build-control file that is required.

>> I noticed another property.  Logically, recordmcount could modify a
>> .o file in place. ...
>> I have written recordmcount.c which does such modify-in-place ...

> I would be interested in seeing it. Do you require any of the elf
> libraries to use this? If so, that would make the kernel build
> dependent on having the development elf libraries installed.

No, my recordmcount.c is completely standalone except for libc.so.
I'll sent it to you (and anyone else who asks) separately.

> I've thought about converting recordmcount into a C file before, but I was
> a bit hesitant on rewriting elf routines (although I've done it before
> and they are quite trivial) but even more concerned on breaking other
> archs.

Yes, the major question is whether R_ARM_ABS32, R_IA64_IMM64, R_PPC64_ADDR64,
R_SH_DIR32, R_SPARC_64, R_390_64, and R_390_32 are the correct relocation
enums for a plain address.  That will require testers...

-- 
