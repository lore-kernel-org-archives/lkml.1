Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbXLGWMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbXLGWMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 17:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbXLGWMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 17:12:30 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:44830 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbXLGWM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 17:12:29 -0500
Message-ID: <4759C548.6030304@linux.vnet.ibm.com>
Date: Sat, 08 Dec 2007 03:42:24 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Olof Johansson <olof@lixom.net>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC
References: <20071207211425.10223.91240.sendpatchset@balbir-laptop> <20071207212817.GA391@lixom.net> <4759BCA2.1020809@linux.vnet.ibm.com> <975B5B2B-C1F3-4021-9AE2-8873FFE1BDEC@kernel.crashing.org>
In-Reply-To: <975B5B2B-C1F3-4021-9AE2-8873FFE1BDEC@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> 
> On Dec 7, 2007, at 3:35 PM, Balbir Singh wrote:
> 
>> Olof Johansson wrote:
>>> Hi,
>>>
>>> On Sat, Dec 08, 2007 at 02:44:25AM +0530, Balbir Singh wrote:
>>>
>>>> Comments are as always welcome!
>>>
>>> Care to explain what this is useful for? (Not saying it's a stupid idea,
>>> just wondering what the reason for doing it is).
>>>
>>
>> In my case, I use it to test parts of my memory controller patches on an
>> emulated NUMA machine. I plan to use it to test out page migration
>> across nodes.
> 
> Can you explain that further.  I'm still not clear on why this is useful.
> 
> - k

Sure. In my case I need to emulate NUMA nodes to do some NUMA specific
testing. The memory controller I've written has some interesting data
structures like per node, per zone LRU lists. To be able to test those
features on a non-numa box is a problem, since we get just the default node.

To be able to test the memory controller under NUMA, I use fake NUMA
nodes. x86-64 has a similar feature, the code I have here is the
simplest I could come up with for PowerPC.

I just thought of another very interesting use case, it can be used to
split up the zone's lru lock which is highly contended.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
