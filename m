Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbZASWHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbZASWHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 17:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZASWHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 17:07:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57872 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbZASWHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 17:07:46 -0500
Message-ID: <4974F9A8.7060107@zytor.com>
Date: Mon, 19 Jan 2009 14:07:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Avuton Olrich <avuton@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Fail to early boot with v2.6.27-rc2 to at least v2.6.29-rc2 due
 to dc1e35c
References: <3aa654a40901190604l2149c592ne4fbf782fa46655f@mail.gmail.com> <4974CC8B.1030403@zytor.com> <3aa654a40901191131p7c141378m1bcd3baeed098e09@mail.gmail.com> <4974DD86.2090300@zytor.com> <20090119201115.GD31356@linux-os.sc.intel.com> <3aa654a40901191346i12cc736m40bebd422100a088@mail.gmail.com> <20090119215736.GE31356@linux-os.sc.intel.com>
In-Reply-To: <20090119215736.GE31356@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> On Mon, Jan 19, 2009 at 01:46:37PM -0800, Avuton Olrich wrote:
>> On Mon, Jan 19, 2009 at 12:11 PM, Suresh Siddha
>> <suresh.b.siddha@intel.com> wrote:
>>> Avuton, Does your bios has an option which says limit the cpuid
>>> vector limit to '2' or something. Can you disable that option and
>>> re-check? It will typically be located under cpu configuration settings.
>> You're the winner of the prize. The culprit in my bios was:
>>
>> Max CPUID Value Limit: Enabled
> 
> Though the bios is the culprit and this option will severely limit
> the cpu capabilities that OS can take advantage of, OS should fallback
> to a safer mode. I will have a patch for it.
> 
> Also, I wonder, if we should complain/scream during boot if we find only
> fewer cpuid levels on modern generation cpu's.
> 

We should, or if this block is reversible, we should probably just undo 
it (the reason people put this block in places is because of, ahem, 
inferior operating systems having bugs.)

Do you know how this is managed?  Via an MSR?

	-hpa
