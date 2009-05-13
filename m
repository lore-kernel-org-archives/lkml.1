Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbZEMOej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbZEMOej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbZEMOe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:34:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54348 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411AbZEMOe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:34:27 -0400
Message-ID: <4A0ADACB.8030205@redhat.com>
Date: Wed, 13 May 2009 10:35:55 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Przemysssaw Paweeeczyk <przemyslaw@pawelczyk.it>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andi Kleen <ak@linux.intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH -tip v5 1/7] x86: instruction decorder API
References: <20090509004829.5505.38720.stgit@localhost.localdomain> <20090509004841.5505.48140.stgit@localhost.localdomain> <20090513082310.GQ18554@redhat.com> <40e92d5b0905130235p2c60bd56y4f001247e11d6302@mail.gmail.com> <20090513094326.GA22281@redhat.com>
In-Reply-To: <20090513094326.GA22281@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gleb Natapov wrote:
> On Wed, May 13, 2009 at 11:35:16AM +0200, Przemysssaw Paweeeczyk wrote:
>> On Wed, May 13, 2009 at 10:23, Gleb Natapov <gleb@redhat.com> wrote:
>>> On Fri, May 08, 2009 at 08:48:42PM -0400, Masami Hiramatsu wrote:
>>>> +++ b/arch/x86/scripts/gen-insn-attr-x86.awk
>>>> @@ -0,0 +1,314 @@
>>>> +#!/bin/awk -f
>>> On some distributions (debian) it is /usr/bin/awk.
>> True, but on most of them (all?) there is also an appropriate link in /bin.
> Nope, not on debian testing. Although I assume if kernel compilation
> will start to fail it will appear :)
> 
>> If shebang could have more that one argument, then '/usr/bin/env awk
>> -f' would be the best solution I think.

Ah, I see.
Actually, it will be executed from Makefile with 'awk -f'.

> --- a/arch/x86/lib/Makefile
> +++ b/arch/x86/lib/Makefile
> @@ -2,12 +2,21 @@
>  # Makefile for x86 specific library files.
>  #
>  
> +quiet_cmd_inat_tables = GEN     $@
> +      cmd_inat_tables = awk -f $(srctree)/arch/x86/scripts/gen-insn-attr-x86.awk $(srctree)/arch/x86/lib/x86-opcode-map.txt > $@
> +

So, if awk is on the PATH, it will pass.
Maybe, I need to add 'HOSTAWK = awk' line in Makefile.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

