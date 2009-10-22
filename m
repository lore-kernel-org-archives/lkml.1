Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbZJVPbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbZJVPbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 11:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbZJVPbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 11:31:21 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:44193 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051AbZJVPbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 11:31:20 -0400
Message-ID: <4AE07AB7.2070901@austin.ibm.com>
Date: Thu, 22 Oct 2009 10:31:03 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5 v4] Export memory_sysdev_class
References: <4ADF1C49.2030201@austin.ibm.com>	 <4ADF1E42.3020907@austin.ibm.com> <1256141009.23737.22.camel@nimitz>
In-Reply-To: <1256141009.23737.22.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dave Hansen wrote:
> On Wed, 2009-10-21 at 09:44 -0500, Nathan Fontenot wrote:
>> Export the memory_sysdev_class structure.  This is needed so we can create
>> a 'release' file in sysfs in addition to the existing 'probe' file in
>> order to support DLPAR removal of memory on the powerpc/pseries platform.
>> The new 'release' file will be powerpc/pseries only.
> 
> Please do it in generic code.  You may only need it on ppc today, but
> somebody else is going to want the same thing tomorrow on another arch.

I thought about this but wasn't sure if having the probe/release sysfs files
for memory and cpu be in generic code would be accepted.

Would it be acceptable to put the new release file for memory under the
ARCH_MEMORY_PROBE config option?  This would reduce the number of arch'es
that would require stubs as it appears only powerpc and x86 define this.

I could do the same thing for the cpu probe/release files and a new
ARCH_CPU_PROBE config option which would eliminate the required stubs
in arch'es other than powerpc right now.

-Nathan Fontenot
  
> 
> It's also nice to keep all of the stuff doing the actual sysfs munging
> in one place.  I know it'll cost a few stubs for calling in and out of
> arch code, but it should save some work down the road for somebody else.
> 
> -- Dave
> 
