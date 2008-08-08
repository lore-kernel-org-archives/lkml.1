Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbYHHJYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbYHHJYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 05:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbYHHJYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 05:24:24 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:58419 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbYHHJYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 05:24:23 -0400
Message-ID: <489C10C5.9060208@keyaccess.nl>
Date: Fri, 08 Aug 2008 11:24:21 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Simon Arlott <simon@fire.lp0.eu>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH RFC] USB: Add HCD fastboot
References: <Pine.LNX.4.44L0.0807311510220.5019-100000@iolanthe.rowland.org> <4899F035.9040003@simon.arlott.org.uk>
In-Reply-To: <4899F035.9040003@simon.arlott.org.uk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06-08-08 20:40, Simon Arlott wrote:

>>> Ok - so there could be some big improvements to be had by making the 
>>> hcd init happen as early as possible and the device initcalls later?
>>
>> Maybe.  Perhaps a better approach would be to make the device driver 
>> initcalls before there are any devices for their probe routines to 
>> block on.
> 
> What about this?
> 
> The Makefiles become a bit messy, but by moving things around I get the 
> desired effect without splitting their initcalls.
> 
> [    7.941890] Write protecting the kernel read-only data: 5656k
> [    5.437709] Write protecting the kernel read-only data: 5656k
> 
> 2.5s faster, which is almost half the boot time.
> 
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>

Interesting... I haven't been able to get stable improvements, with all 
USB kernel modules built-in, just a USB mouse on OHCI and otherwise a 
switched of USB HD on EHCI and usb-storage, but I do get the idea that 
with your parch, I "get lucky" more often.

I have knfsd as a module and it loads through the exportfs trigger 
during bootup and outputs the last message to my dmesg:

4 boots without your patch: 6.12, 6.41, 6.38, 6.34 seconds
4 boots with              : 5.39, 6.33, 5.37, 6.34

Booting with the external HD switched on adds a tiny bit to the actual 
kernel startup time -- completely repeatable 2.62 seconds until freeing 
init code with the HD off versus 2.73 with it on -- but doesn't seem to 
change the picture otherwise...

Would those results make sense you feel? I'm not looking forward to 
putting an actual statistical analysis on it ;-)

Arjan: your fastboot repo by the way doesn't pull cleanly into current 
upstream anymore.

Rene.
