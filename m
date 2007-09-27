Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbXI0PEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbXI0PEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbXI0PE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:04:26 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:27533
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773AbXI0PEZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:04:25 -0400
Message-Id: <46FBE2DD.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 27 Sep 2007 16:05:33 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Cc: <bridge@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Module use count must be updated as bridges are
	created/destroyed
References: <46FA2C17.76E4.0078.0@novell.com>
 <20070926083705.6bc65ea5@fujitsu-loaner> <46FAA013.76E4.0078.0@novell.com>
 <20070926101252.3ccbb987@freepuppy.rosehill>
 <46FB7A7A.76E4.0078.0@novell.com>
 <20070927074849.074fdb88@freepuppy.rosehill>
In-Reply-To: <20070927074849.074fdb88@freepuppy.rosehill>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> >Sounds like a module utilities problem since unloading one module doesn't
>> >normally unload others.
>> 
>> I have to disagree here - 'modprobe -r' is specifically unloading all modules the
>> specified one references as long as they have a use count of zero. The
>> difference to other networking modules is that the latter normally don't export
>> symbols, and hence don't have dependent modules (and thus cannot be
>> subject of implicit unloading). Bridge does have dependents, and hence must
>> avoid implicit unloading by managing its use count.
>
>I want keep the behavior that:
>	modprobe -r bridge
>removes all bridges.  It is too useful and may already be in some user scripts.

So we have an unsolvable problem here then, unless infrastructure gets added
that allows a module to declare itself as not-implicit-unload-safe, forcing
modprobe -r to keep its hands off it. Ugly.

Jan

