Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbXKLO2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbXKLO2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 09:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbXKLO2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 09:28:08 -0500
Received: from vulpecula.futurs.inria.fr ([195.83.212.5]:41324 "EHLO
	vulpecula.futurs.inria.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbXKLO2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 09:28:07 -0500
X-Greylist: delayed 1520 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Nov 2007 09:28:07 EST
Message-ID: <47385D05.20705@lifl.fr>
Date: Mon, 12 Nov 2007 15:02:45 +0100
From: Eric Piel <Eric.Piel@lifl.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20071101 Mandriva/2.0.0.6-5mdv2008.1 (2008.1) Thunderbird/2.0.0.6 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: trenn@suse.de
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@redhat.com>
Subject: Re: Kernel panic at boot with ondemand governor as default	(2.6.24-rc2)
References: <4737539F.2070401@lifl.fr> <1194859012.4590.595.camel@queen.suse.de>
In-Reply-To: <1194859012.4590.595.camel@queen.suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

11/12/2007 10:16 AM, Thomas Renninger wrote/a écrit:
> On Sun, 2007-11-11 at 20:10 +0100, Eric Piel wrote:
>> Hello,
>>
>> I've tried kernel 2.6.24-rc2 and I have a problem with the new option 
>> for setting up the cpufreq ondemand governor as default: a kernel panic 
>> happens early at boot time. If I boot first with performance governor 
>> and later change to ondemand, everything is fine (as usual).
>>
>> This seems related to the delayed_workqueue. The kernel panic message 
>> finishes by:
>> EIP: [<c012aa60>] wq_per_cpu+0x0/0x10 SS:ESP 0068:c191be58
>> Kernel panic - not syncing: Attempted to kill init!
>>
>> A picture of the whole message is available here:
>> http://pieleric.free.fr/unorder/1162-ondemand-panic.jpg
>>
>> My computer is a x86 using speedstep-ich, and you can find the full 
>> .config leading to the panic attached.
>>
>> Does anyone has any idea was it going wrong?
> 
> Does it work if you compile speedstep-ich as a module?
> If you load it, ondemand governor should still be set up automatically.
> If this works, could it be that the kernel does not like that
> queue_delayed_work_on is called that early?

Yes, it works if I compile speedstep-ich as module. I've put the module 
in initramfs and as soon it is loaded, the ondemand governor is selected 
and works.

However, do you think it's ok to prevent cpufreq drivers to be built-in 
if ondemand governor is selected as default? Another way would be to 
reorganise the initialisation code so that workqueue is initialised 
before the cpufreq framework is started, do you think it's possible?

See you,
Eric

