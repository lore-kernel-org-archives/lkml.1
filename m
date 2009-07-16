Return-Path: <linux-kernel-owner+w=401wt.eu-S933279AbZGPUPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279AbZGPUPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 16:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933261AbZGPUPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 16:15:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52088 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933233AbZGPUPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 16:15:37 -0400
Message-ID: <4A5F8AAD.1060404@redhat.com>
Date: Thu, 16 Jul 2009 16:16:45 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andi Kleen <ak@linux.intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Avi Kivity <avi@redhat.com>,
       Przemys??awPawe??czyk <przemyslaw@pawelczyk.it>
Subject: Re: [PATCH -tip -v12 02/11] x86: x86 instruction decoder build-time
 selftest
References: <20090716155652.6266.39970.stgit@localhost.localdomain> <20090716155706.6266.79022.stgit@localhost.localdomain> <20090716162947.GA5804@merkur.ravnborg.org> <4A5F6571.3020002@redhat.com> <20090716195542.GA5994@merkur.ravnborg.org>
In-Reply-To: <20090716195542.GA5994@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>>>> +      cmd_posttest = objdump -d $(objtree)/vmlinux | awk -f $(srctree)/arch/x86/scripts/distill.awk | $(obj)/test_get_len
>>>> +
>>> You are using the native objdump here.
>>> But I assume this fails miserably when you build x86 on a powerpc host.
>>> In other words - you broke an allyesconfig build for -next...
>>> We have $(OBJDUMP) for this.
>> Ah, I see... Would you know actual name of x86-objdump on the powerpc
>> (or any other crosscompiling host)? I just set "OBJDUMP=objdump" is OK?
>> I'm not so sure about cross-compiling kernel...
> 
> Replacing objdump with $(OBJDUMP) will do the trick.
> We set OBJDUMP to the correct value in the top-level makefile.
> 
> Are there any parts of your user-space program that rely
> on the host is little-endian?
> If it does then it would fail on a power-pc target despite using the
> correct objdump.

Hmm, as far as I can see, the result of get_next() macro with the types
more than two bytes(s16, s32...) might be effected.
But it doesn't effect get_insn_len test because those values are ignored.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

