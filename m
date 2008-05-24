Return-Path: <linux-kernel-owner+w=401wt.eu-S1759951AbYEXAku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759951AbYEXAku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 20:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbYEXAkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 20:40:42 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:50688 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbYEXAkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 20:40:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Bernhard Walle <bwalle@suse.de>
Cc: Sharyathi Nagesh <sharyath@in.ibm.com>, akpm@osdl.org,
       mohd.omar@in.ibm.com, IndhuDurai@in.ibm.com,
       Kexec Mailing List <kexec@lists.infradead.org>, fastboot@lists.osdl.org,
       linux-kernel@vger.kernel.org, mohan@in.ibm.com, sachinp@in.ibm.com
References: <4836AC3C.3090005@in.ibm.com> <m1ve144w25.fsf@frodo.ebiederm.org>
	<20080523233348.13fe0c63@kopernikus.site>
Date: Fri, 23 May 2008 17:36:26 -0700
In-Reply-To: <20080523233348.13fe0c63@kopernikus.site> (Bernhard Walle's
	message of "Fri, 23 May 2008 23:33:48 +0200")
Message-ID: <m1od6w4jxx.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bernhard Walle <bwalle@suse.de>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4041]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: correction to compat_sys_kexec_load
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle <bwalle@suse.de> writes:

> * ebiederm@xmission.com (Eric W. Biederman) [2008-05-23 13:14]:
>>
>> What we need to do is fix /sbin/kexec to pass in the correct
>> architecture of the kernel for unload as it does for load.
>
> How should it know that it unloads a 32 bit kernel on a 64 bit system?
> It doesn't have access to the kernel any more once it has been loaded.

The architecture parameter is the architecture of the running kernel
that implements sys_kexec_load.

Because it is a pain for testing and in general impossible we don't
change cpu modes during a kexec.  So a 32bit caller of sys_kexec_load
will need to passing in different code if it is running on a 32bit or
a 64bit kernel.

The trampoline code in /sbin/kexec does change modes on x86 when
appropriate.

Caring if you know the architecture in the unload case is a bit
silly. As there is no real justification for it.  At this
point getting user space fixed so that it works on older kernels
seems important. 

Eric
