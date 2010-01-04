Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643Ab0ADVvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab0ADVvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 16:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965Ab0ADVvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 16:51:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40418 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab0ADVvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 16:51:16 -0500
Message-ID: <4B42629A.2010401@zytor.com>
Date: Mon, 04 Jan 2010 13:50:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Yinghai Lu <yinghai@kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDEV list <netdev@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH 2/2] x86: get more exact nr_irqs
References: <4B347AEE.6030705@kernel.org> <20091228094707.GH24690@elte.hu>	<4B398ECD.1080506@kernel.org>	<4807377b1001031906s6b1ee576jc021da2642bb4147@mail.gmail.com>	<4B415E73.1050801@kernel.org> <4B41918D.3000605@kernel.org>	<m1fx6lizc3.fsf@fess.ebiederm.org>	<86802c441001041103s5abd6d3ai4e6ccbfc68323f3c@mail.gmail.com>	<m1bph9he9m.fsf@fess.ebiederm.org> <4B4241E2.1020008@zytor.com> <m1skald4az.fsf@fess.ebiederm.org>
In-Reply-To: <m1skald4az.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2010 12:05 PM, Eric W. Biederman wrote:
>>
>> rbtree doesn't make much sense for something that is addressed by index,
>> and doesn't need to answer questions of the form "give me the highest
>> member <= X".  A hash table or radix tree makes sense, depending on the
>> expected sparseness of the index.
> 
> Not counting irqs for msi's I think we are looking 36% to 25% fill.  Maybe
> a little lower.  The sparseness is much higher if we count the number of
> irqs that we might/use allocate as we do today.
> 
> Short of driver hotplug msis should be allocated densely, unless we start
> reserving all possible 4K msi-x vectors.
> 
> For each ioapic we allocate 16 gsis, and only maybe four of them are
> connected to actual pci slots.
> 
> This is essentially a slow path operation, so as long as we are not
> too expensive we can use any data structure we want.  In kernel hash
> tables don't grow well so I don't think a hash table is a good choice,
> and a hash table is essentially what we have now.
> 
> The truth is we don't know how many irqs we will have until msi
> supporting drivers claim all of theirs.
> 
> I think a radix-tree would likely be the least intrusive choice as it
> does not imply any changes to the data structure indexed.
> 

Yes, for that kind of densities radix tree is a good choice.

	-hpa

