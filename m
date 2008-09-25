Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbYIYFba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbYIYFba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 01:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbYIYFbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 01:31:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58761 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbYIYFbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 01:31:20 -0400
Message-ID: <48DB220E.5000004@zytor.com>
Date: Wed, 24 Sep 2008 22:30:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Alok kataria <alokkataria1@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Yan Li <elliot.li.tech@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
       "rjmaomao@gmail.com" <rjmaomao@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Daniel Hecht <dhecht@vmware.com>,
       Zach Amsden <zach@vmware.com>
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
References: <20080221115452.GB13948@elte.hu>	 <20080907234510.GA24133@yantp.cn.ibm.com>	 <20080908140423.GG11993@elte.hu>	 <35f686220809241928k3669e30bi8a98b440443c4bff@mail.gmail.com>	 <48DB15DB.8040501@zytor.com> <1222317978.23524.117.camel@alok-dev1>	 <48DB1984.8020704@zytor.com> <1222318928.23524.121.camel@alok-dev1>	 <48DB1BCE.2070106@zytor.com> <1222320201.23524.135.camel@alok-dev1>
In-Reply-To: <1222320201.23524.135.camel@alok-dev1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> 
> Hmm...what can a IN on an unknown port cause on native hardware, if a
> port is not being used it would return 0xFFFFFFFF in eax, and if you
> have a real device there (a sane one), what can IN result in apart from
> reading some IO register/counter value in eax ?
> If there is anything apart from the above 2 outcomes, please let me know
> exactly what you mean.
> 

First, you are assuming all devices are "sane".  This is obviously wrong 
-- you're poking in hyperspace, and you don't know if you're going to 
hit someone's ancient controller card that perhaps drives a medical 
accelerator for all you know.

Second, you are assuming that devices you call "sane" don't have I/O 
ports with read side effects.  Many, if not most, devices have some I/O 
ports with read side effects, especially read-clear semantics and/or 
queue drain operations.

Third, in the real world hardware is buggy.  Not just a little, but 
severely so.  Accessing a part of a device which is uninitialized, 
powered down or plain broken can wedge the device or the whole system.

In short, poking at I/O ports which you don't know what they are at best 
takes us bad to the bad old days of ISA probing (without the protection 
of customary address assignments); I think it has to be an absolutely 
last resort and would be reflective of utterly incompetent design.  It 
is significantly *worse* than stealing random opcodes, Virtual PC-style, 
and that is also unacceptable.

	-hpa
