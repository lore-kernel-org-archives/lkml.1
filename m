Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbZHURko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbZHURko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbZHURkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:40:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48017 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbZHURkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:40:42 -0400
Message-ID: <4A8EDC02.8000508@zytor.com>
Date: Fri, 21 Aug 2009 10:40:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, AMD: Disable wrongly set X86_FEATURE_LAHF_LM
 CPUID bit
References: <1250251594-8348-2-git-send-email-borislav.petkov@amd.com> <tip-c74cb13b94118ec89e48849806356b67caa5ff86@git.kernel.org> <20090816064132.GA16278@elte.hu> <20090816214934.GB7765@liondog.tnic>
In-Reply-To: <20090816214934.GB7765@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2009 02:49 PM, Borislav Petkov wrote:
> On Sun, Aug 16, 2009 at 08:41:32AM +0200, Ingo Molnar wrote:
>> -tip testing found this build bug caused by this patch:
>>
>> arch/x86/kernel/cpu/amd.c: In function ‘init_amd’:
>> arch/x86/kernel/cpu/amd.c:417: error: implicit declaration of function ‘wrmsr_amd_safe’
> 
> Oops, forgot paravirt. Here's a fixed version:
> 

One thing that really bothers me about these is that they're horribly
non-generic.  It wouldn't be so bad -- if we need something more generic
we can create them -- if it wasn't for that perennial horror called
paravirt_crap, which of course just ends up incorporating whatever
internal interfaces we have.

If we're going to modify the paravirt_crap for yet another MSR
operation, then let's at least make it something like "write_msr_edi"
and have it take a parameter for the EDI value.  Perhaps we should let
it set EBX and ESI as well (and the same for the read operation, even
though it already exists.)

	-hpa
