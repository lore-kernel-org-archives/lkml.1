Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbZJSNkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbZJSNkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 09:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbZJSNkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 09:40:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:26092 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbZJSNku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 09:40:50 -0400
Message-ID: <4ADC6C67.8090206@monstr.eu>
Date: Mon, 19 Oct 2009 15:40:55 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, mingo@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
       rostedt@goodmis.org, hpa@zytor.com, cebbert@redhat.com,
       tony.luck@intel.com
Subject: Re: [PATCH 13/16] percpu: remove per_cpu__ prefix.
References: <1255500125-3210-1-git-send-email-tj@kernel.org> <1255500125-3210-14-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0910141026370.26476@gentwo.org> <4AD6EA57.6020105@kernel.org>
In-Reply-To: <4AD6EA57.6020105@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> (microblaze maintainer cc'd, hello)
> 
> Christoph Lameter wrote:
>> On Wed, 14 Oct 2009, Tejun Heo wrote:
>>
>>> @@ -39,7 +39,7 @@ extern void *per_cpu_init(void);
>>>   * On the positive side, using __ia64_per_cpu_var() instead of __get_cpu_var() is slightly
>>>   * more efficient.
>>>   */
>>> -#define __ia64_per_cpu_var(var)	per_cpu__##var
>>> +#define __ia64_per_cpu_var(var)	var
>> IA64 could completely drop the macro? Tony?
> 
> Being discussed but I think we should just add sparse annotation there
> instead.
> 
>>> diff --git a/arch/microblaze/include/asm/entry.h b/arch/microblaze/include/asm/entry.h
>>> index 61abbd2..ec89f2a 100644
>>> --- a/arch/microblaze/include/asm/entry.h
>>> +++ b/arch/microblaze/include/asm/entry.h
>>> @@ -21,7 +21,7 @@
>>>   * places
>>>   */
>>>
>>> -#define PER_CPU(var) per_cpu__##var
>>> +#define PER_CPU(var) var
>> Microblaze too.
> 
> This macro is used only in assemblies which wouldn't be covered by
> sparse so in this case this patch series actually removes protection,
> so I wasn't too sure about ripping the macro off.  Any ideas what we
> can do here?  Just kill it?

If I understand correctly, functionality will be the same. But anyway I would
like to mot lose information about per_cpu variables. That's why please keep
that macro for Microblaze. If is the problem, you should convince me why to do it.

Thanks,
Michal






-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
