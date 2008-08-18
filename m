Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbYHRJP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbYHRJP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 05:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbYHRJPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 05:15:14 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:51153 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbYHRJPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 05:15:12 -0400
Message-ID: <48A93CE7.3020301@ah.jp.nec.com>
Date: Mon, 18 Aug 2008 18:12:07 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>, Keith Owens <kaos@ocs.com.au>,
       Jay Lan <jlan@sgi.com>, Christoph Lameter <cl@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, jmerkey@wolfmountaingroup.com,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
References: <20080807200659.GJ24801@one.firstfloor.org> <23175.1218148134@ocs10w> <20080808011500.GA531@redhat.com> <20080808022916.GM24801@one.firstfloor.org> <20080808132953.GB3840@redhat.com> <20080808180303.GB9038@one.firstfloor.org> <20080811130256.GB28030@redhat.com>
In-Reply-To: <20080811130256.GB28030@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Fri, Aug 08, 2008 at 08:03:03PM +0200, Andi Kleen wrote:
>>> Are you suggesting that kdump should be put onto panic_notifier_list, in
>>> such a way so that it runs last?
>> The point was that kernel debuggers have an at least as legitimate
>> need as kdump to run early on panic as kdump. In particularly they
>> should run before kdump because kdump can be triggered from
>> the debugger.
>>
> 
> Agreed.
> 
>> But for modular kernel debuggers the hook would need to be exported,
>> so in theory everyone could use it. In theory code review should
>> catch that. Another alternative would be to readd the old namespaces
>> patches I posted some time ago, this allowed to export symbols only
>> to specific modules (but that would be also unfortunate for out of tree
>> debuggers) 
>>
> 
> Or an easier way is that debuggers can put a breakpoint on panic().
> 
>> Since we have nearly all other needed hooks for kernel debuggers
>> anyways it doesn't really make sense to stop at panic. So this
>> earlier requirements should be relaxed.
>>
> 
> I think given that so many people want kdump on panic_notifier_list,
> it would be worthwhile to experiment with the different approach.
> 
> - Move kdump to panic_notifier_list.
> - Export panic_notifier_list to user space and provide flexibility
>   so that a user can change the priorities of registered handlers
>   dynamically.
> 
> This will allow an admin to explicitly see who all are goint to run
> in what order in case of panic and also give him capability that he
> can choose to change the order.
> 
> This kind of list should keep all the kind of users happy. Those who
> want to run all the other modules before kdump, they will be able to
> do so and those who don't want, they can boost the priority of kdump
> to put it ahead in the list.
> 
> I think Takenori had some working patches in the past for this. Probably
> time to revisit the patches. (Somebody willing to look into it?).
> 
> Thanks
> Vivek

Hi all,

These are my latest patches. Any comments are welcome.

http://www.gossamer-threads.com/lists/linux/kernel/909582
http://www.gossamer-threads.com/lists/linux/kernel/909581
http://www.gossamer-threads.com/lists/linux/kernel/909584
http://www.gossamer-threads.com/lists/linux/kernel/909583

Thanks,
  Takenori Nagano
