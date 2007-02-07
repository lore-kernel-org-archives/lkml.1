Return-Path: <linux-kernel-owner+w=401wt.eu-S1030309AbXBGAWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030309AbXBGAWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 19:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030337AbXBGAWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 19:22:53 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:32929 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030309AbXBGAWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 19:22:52 -0500
Message-ID: <45C91BDB.9060403@vmware.com>
Date: Tue, 06 Feb 2007 16:22:51 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Andi Kleen <ak@muc.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 6/11] Vmi timer no idle hz fixes.patch
References: <200702060353.l163r9ec000751@zach-dev.vmware.com> <20070206122917.GD47229@muc.de>
In-Reply-To: <20070206122917.GD47229@muc.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> -#ifdef CONFIG_S390
>> -#ifdef CONFIG_MATHEMU
>> -	{
>> -		.ctl_name	= KERN_IEEE_EMULATION_WARNINGS,
>> -		.procname	= "ieee_emulation_warnings",
>> -		.data		= &sysctl_ieee_emulation_warnings,
>> -		.maxlen		= sizeof(int),
>> -		.mode		= 0644,
>> -		.proc_handler	= &proc_dointvec,
>> -	},
>>     
>
> I think there needs to be a way to have this syctl only
> when it's really implemented for the paravirt ops.
>
> I suppose you should move it to dynamic registration on demand.
>   

Hmm, is there a way to do that and share the sysctl with Xen?  Yes, I 
think if we move the data to paravirt.c and call 
paravirt_start_no_idle_hz (or something_with_fewer_underbars), then we 
can both share this call site instead of silly duplicating the .ctl_name ...

Will code it up.

Zach
