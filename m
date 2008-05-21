Return-Path: <linux-kernel-owner+w=401wt.eu-S936627AbYEUTwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936627AbYEUTwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759248AbYEUTwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:52:39 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:9897 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758426AbYEUTwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:52:38 -0400
X-Greylist: delayed 1204 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 May 2008 15:52:38 EDT
Message-Id: <48344E8A.7E42.0086.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Wed, 21 May 2008 13:32:10 -0600
From: "Leonardo Chiquitto" <lchiquitto@novell.com>
To: "Alan Stern" <stern@rowland.harvard.edu>, "Jiri Kosina" <jkosina@suse.cz>
Cc: "Greg KH" <greg@kroah.com>, "Oliver Neukum" <oliver@neukum.org>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB: fix deadlock in HCD code
References: <Pine.LNX.4.64.0805211620270.6718@jikos.suse.cz>
 <Pine.LNX.4.44L0.0805211042070.2490-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0805211042070.2490-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> > > Used in the suspend code. Your patch is indeed correct, but I fear 
>> > > there might be a second bug caused by wrong calling conditions.
>> > The problem in the Novell bugzilla entry was caused by the fact that the 
>> > OHCI irq routine was invoked with interrupts enabled, owing to a missing 
>> > IRQF_DISABLED flag.  That bug has already been fixed in 2.6.25.
>> 
>> That indeed is 2.6.25 kernel. I guess you are talking about commit 
>> 442258e2ff69 here.
> 
> Yes.
> 
>> If so, the reporter is definitely using the kernel 
>> containing this commit, and the lockups still trigger.
>> 
>> Seems that my patch is papering over the real bug (someone enabling 
>> interrupts somewhere) indeed, but I can't seem to be able to find such 
>> codepath.
> 
> You could try testing the interrupt-enable flag at various places 
> in ohci-hcd (start with finish_urb) and printing an error message if 
> interrupts are enabled.
> 
> One possibility is that in an earlier call to finish_urb,
> usb_hcd_giveback_urb was called with interrupts disabled and returned 
> with interrupts enabled.  In other words, some driver's callback 
> routine may have enabled interrupts incorrectly.

Alan,

  I am trying your suggestion right now. Lets see if it finds something.

Thanks,
Leonardo

