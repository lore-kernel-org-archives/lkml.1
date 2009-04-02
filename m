Return-Path: <linux-kernel-owner+w=401wt.eu-S1751582AbZDBLoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbZDBLoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756749AbZDBLn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:43:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52151 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756413AbZDBLn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:43:57 -0400
Message-ID: <49D4A4EB.8020105@redhat.com>
Date: Thu, 02 Apr 2009 14:43:39 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090331184057.28333.77287.stgit@dev.haskins.net> <87ab71monw.fsf@basil.nowhere.org> <49D35825.3050001@novell.com> <20090401132340.GT11935@one.firstfloor.org> <49D37805.1060301@novell.com> <20090401170103.GU11935@one.firstfloor.org> <49D3B64F.6070703@codemonkey.ws> <49D3D7EE.4080202@novell.com> <49D46089.5040204@redhat.com> <49D497A1.4090900@novell.com>
In-Reply-To: <49D497A1.4090900@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:

  

>> virtio is already non-kvm-specific (lguest uses it) and
>> non-pci-specific (s390 uses it).
>>     
>
> Ok, then to be more specific, I need it to be more generic than it
> already is.  For instance, I need it to be able to integrate with
> shm_signals.  

Why?

  

>> If you have a good exit mitigation scheme you can cut exits by a
>> factor of 100; so the userspace exit costs are cut by the same
>> factor.  If you have good copyless networking APIs you can cut the
>> cost of copies to zero (well, to the cost of get_user_pages_fast(),
>> but a kernel solution needs that too).
>>     
>
> "exit mitigation' schemes are for bandwidth, not latency.  For latency
> it all comes down to how fast you can signal in both directions.  If
> someone is going to do a stand-alone request-reply, its generally always
> going to be at least one hypercall and one rx-interrupt.  So your speed
> will be governed by your signal path, not your buffer bandwidth.
>   

The userspace path is longer by 2 microseconds (for two additional 
heavyweight exits) and a few syscalls.  I don't think that's worthy of 
putting all the code in the kernel.

-- 
error compiling committee.c: too many arguments to function

