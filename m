Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbYFSWV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbYFSWV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 18:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbYFSWVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 18:21:46 -0400
Received: from gw.goop.org ([64.81.55.164]:33301 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbYFSWVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 18:21:46 -0400
Message-ID: <485ADBCF.5040101@goop.org>
Date: Thu, 19 Jun 2008 15:21:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.509483000@polaris-admin.engr.sgi.com> <20080605102222.GA21319@elte.hu> <484EF29C.7080100@sgi.com> <485947A8.8060801@goop.org> <4859511E.5050605@sgi.com> <48596315.6020104@goop.org> <48596893.4040908@sgi.com> <485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org> <485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org> <485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com> <485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com>
In-Reply-To: <485ADA12.5010505@sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Jeremy Fitzhardinge wrote:
>
>   
>> Why not use the real pda for all cpus?
>>     
>
> Yeah, I figured that out after doing some more thinking... ;-)
>
>   
>> Do you move the boot-cpu's per-cpu data? (Please don't)  If not, you can
>> just use percpu__pda from the start without having to do anything else,
>> and then set up %gs pointing to the pda base for each secondary cpu.
>>     
>
> The problem is that the static percpu area is removed as it lies
> in the initdata section, so the pda is removed as well.
>   

Well, that's easy to fix...

> But I took your suggestion to move the fixup to before secondary_startup.
>
> Below is a revised version. 

(Incremental diffs are easier to review and work with.)

>  It builds but I'll have to test it tomorrow.
> Note the addition of:
>
> +       initial_pda = (unsigned long)get_percpu_pda(cpu);
>
> in do_boot_cpu.
>
> I'm not sure yet what to put into acpi_save_state_mem:
>
>         initial_code = (unsigned long)wakeup_long64;
> +       /* ZZZ initial_pda = (unsigned long)?; */
>   

You'll need to change wakeup_long64 to load the right value into the 
GS_BASE msr anyway.

    J
