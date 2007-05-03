Return-Path: <linux-kernel-owner+w=401wt.eu-S1031259AbXECNoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031259AbXECNoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 09:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031286AbXECNoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 09:44:38 -0400
Received: from rtr.ca ([64.26.128.89]:2152 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031259AbXECNoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 09:44:38 -0400
Message-ID: <4639E743.2080504@rtr.ca>
Date: Thu, 03 May 2007 09:44:35 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@osdl.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [BUG] usb/core/hub.c loops forever on resume
 from ram due to bluetooth
References: <Pine.LNX.4.44L0.0705030932290.3548-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0705030932290.3548-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Wed, 2 May 2007, Mark Lord wrote:
> 
>> Alan Stern wrote:
>>> A better approach would be to find out why your system gets into that loop 
>>> and fix the underlying cause.
>> Not better, just parallel.
>>
>> That loop should not be unbounded, as this example proves.
>> But it also shouldn't get stuck there regardless.
>>
>> Two fixes needed.
> 
> If the code never gets stuck in a loop, then there's no need to check 
> whether the loop is unbounded!  :-)

Yes, except here we know it does actually get stuck in a loop,
and having unbounded loops in device-driver code is a known baddy.

One cannot predict perfectly exactly how devices will fail,
but one can program defensively against them with simple precautions
like limiting list traversals and the like.  :)

Sure, Marcel may eventually look at the bluetooth code and fix it
to not get confused, but some other USB device may then show up
in the future with similar issues.  The messages are still there
so we'll know about any future failure, but it won't just silently
crash the machine on resume this way.

Remember, resume is a very tough operation to debug at the best
of times, so adding some harmless robustness to the more troublesome
drives is a very Good Thing(tm) here.

Cheers
