Return-Path: <linux-kernel-owner+w=401wt.eu-S933349AbZGPUrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933349AbZGPUrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 16:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933336AbZGPUrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 16:47:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42749 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933326AbZGPUre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 16:47:34 -0400
Message-ID: <4A5F9228.7060904@redhat.com>
Date: Thu, 16 Jul 2009 16:48:40 -0400
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
Subject: Re: [PATCH -tip -v12 01/11] x86: instruction decoder API
References: <20090716155652.6266.39970.stgit@localhost.localdomain> <20090716155700.6266.71011.stgit@localhost.localdomain> <20090716163708.GB5804@merkur.ravnborg.org> <4A5F6356.9080505@redhat.com> <20090716200012.GB5994@merkur.ravnborg.org>
In-Reply-To: <20090716200012.GB5994@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Thu, Jul 16, 2009 at 01:28:54PM -0400, Masami Hiramatsu wrote:
>> Sam Ravnborg wrote:
>>>> diff --git a/arch/x86/include/asm/inat.h b/arch/x86/include/asm/inat.h
>>>> new file mode 100644
>>>> index 0000000..01e079a
>>>> --- /dev/null
>>>> +++ b/arch/x86/include/asm/inat.h
>>>> @@ -0,0 +1,125 @@
>>>> +#ifndef _ASM_INAT_INAT_H
>>>> +#define _ASM_INAT_INAT_H
>>> [With reference to comment on patch 2/12...]
>>> You create inat.h here.
>>> Could you investigave what is needed to factor out the stuff
>>> needed from userspace so we can avoid the ugly havk where
>>> you redefine types.h?
>> Sorry, I'm a bit confusing.
>> Would you mean that I should break down user_include.h and
>> add those redefined types in inat.h?
> No - try to factor out what is needed for your program
> so you can avoid user_include.h entirely.
>>> Maybe create a inat_types.h + inat.h as we do in other cases?
>> And inat_types.h has two parts, one for kernel, and one for
>> userspace(which is moved from user_include.h), is that right?
> More like inat_types.h include pure definitions and inat.h
> define all the macros (that would be much nicer if expressed
> as static inlines).

OK, some macros still need to be macros, because it will be used
for defining static tables.

> The real thing to consider is what is needed from your userspace
> program and is also required by the kernel.
> I did not event remotely try to find out - as I guess you know it.
> So try to isolate these bits somehow and you have then nicely dropped
> a lot of dependencies on the remainign headers and can thus
> hopefully get rid of the ugly usser_include.h hack.

OK, I'll try to remove user_include.h hack.

Thank you so much!


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

