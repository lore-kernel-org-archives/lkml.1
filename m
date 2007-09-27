Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbXI0HjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbXI0HjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 03:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbXI0HjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 03:39:04 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:4422
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752077AbXI0HjD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 03:39:03 -0400
Message-Id: <46FB7A7A.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 27 Sep 2007 08:40:10 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Cc: <bridge@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Module use count must be updated as bridges are
	created/destroyed
References: <46FA2C17.76E4.0078.0@novell.com>
 <20070926083705.6bc65ea5@fujitsu-loaner> <46FAA013.76E4.0078.0@novell.com>
 <20070926101252.3ccbb987@freepuppy.rosehill>
In-Reply-To: <20070926101252.3ccbb987@freepuppy.rosehill>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Stephen Hemminger <shemminger@linux-foundation.org> 26.09.07 19:12 >>>
>On Wed, 26 Sep 2007 17:08:19 +0100
>"Jan Beulich" <jbeulich@novell.com> wrote:
>
>> >>> Stephen Hemminger <shemminger@linux-foundation.org> 26.09.07 17:37 >>>
>> >On Wed, 26 Sep 2007 08:53:27 +0100
>> >"Jan Beulich" <jbeulich@novell.com> wrote:
>> >
>> >> Otherwise 'modprobe -r' on a module having a dependency on bridge will
>> >> implicitly unload bridge, bringing down all connectivity that was
>> >> using bridges.
>> >> 
>> >> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>> >>
>> >
>> >No, network devices don't do reference counting.
>> >What is the dependency? Where is the source of the module interacting
>> >with the  bridge?
>> 
>> On a Xen system, I loaded and then unloaded ebtable_broute. The unload
>> implicitly unloaded bridge, destroying the network. The only way I could see
>> to avoid the implicit unload was to bump the reference count on bridge
>> creation. Otherwise I would have to ask why bridge has a zero reference
>> count despite a bridge being configured.
>> 
>> Jan
>
>Sounds like a module utilities problem since unloading one module doesn't
>normally unload others.

I have to disagree here - 'modprobe -r' is specifically unloading all modules the
specified one references as long as they have a use count of zero. The
difference to other networking modules is that the latter normally don't export
symbols, and hence don't have dependent modules (and thus cannot be
subject of implicit unloading). Bridge does have dependents, and hence must
avoid implicit unloading by managing its use count.

Jan

