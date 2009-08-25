Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbZHYGpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbZHYGpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 02:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbZHYGpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 02:45:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38583 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbZHYGpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 02:45:30 -0400
Message-ID: <4A93884E.3000403@zytor.com>
Date: Mon, 24 Aug 2009 23:44:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, AMD: Disable wrongly set X86_FEATURE_LAHF_LM
 CPUID bit
References: <1250251594-8348-2-git-send-email-borislav.petkov@amd.com> <tip-c74cb13b94118ec89e48849806356b67caa5ff86@git.kernel.org> <20090816064132.GA16278@elte.hu> <20090816214934.GB7765@liondog.tnic> <4A8EDC02.8000508@zytor.com> <20090822163750.GA31631@liondog.tnic> <4A92F93F.8000502@zytor.com> <20090825055215.GA22595@liondog.tnic>
In-Reply-To: <20090825055215.GA22595@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2009 10:52 PM, Borislav Petkov wrote:
> On Mon, Aug 24, 2009 at 01:34:07PM -0700, H. Peter Anvin wrote:
>> Looks reasonable... although part of me wonders if having a pointer to
>> an array containing the entire register file in and out is even better,
>> of if I'm just overengineering at this point.
> 
> Hmm, let's have necessity determine that. I can only think of %edi being
> used as an input reg to rd/wrmsr beside %ecx but it could be very well
> that some other x86 hardware uses other regs too. Do we actually need
> all regs or a two should suffice?
> 

Hard to know.  In theory we shouldn't need ESI and EDI either!

As I said, I wouldn't have worried about it at all if it wasn't for
paravirt_ops turning these things into ABIs.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

