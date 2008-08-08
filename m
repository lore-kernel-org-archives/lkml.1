Return-Path: <linux-kernel-owner+w=401wt.eu-S1752202AbYHHOal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbYHHOal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 10:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbYHHOaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 10:30:18 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:43157 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbYHHOaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 10:30:16 -0400
Message-ID: <489C5876.6000409@keyaccess.nl>
Date: Fri, 08 Aug 2008 16:30:14 +0200
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
References: <Pine.LNX.4.44L0.0807311510220.5019-100000@iolanthe.rowland.org>    <4899F035.9040003@simon.arlott.org.uk>    <489C10C5.9060208@keyaccess.nl> <19319b3fe3c10503fe594310f2fddab1743bfe8b@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
In-Reply-To: <19319b3fe3c10503fe594310f2fddab1743bfe8b@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08-08-08 13:29, Simon Arlott wrote:

> I suggest adding initcall_debug=1, it'll show how long the usb and other
> initcalls take to run. You should see the first usb device driver initcall
> take a second or two to run (without the patch). Maybe I'm just badly
> affected by having HCDs with 10 ports (of which only 4 are physically
> usable...).
> 
> dmesg|grep initcall\
> |sed -e 's/.*initcall \([^ ]\+\( \(\[[^]]\+\]\)\)\?\) returned [^ ]\+ after \([^ ]\+\) secs/\4 \1/'\
> |sort -n

Thanks, but that specific expression doesn't work work me,since there's 
not a single one that takes ' secs', only ' msecs'.

Here's the USB related ones here:

> [    1.198751] initcall ehci_hcd_init+0x0/0x11 returned 0 after 123 msecs
> [    1.818688] initcall ohci_hcd_mod_init+0x0/0x31 returned 0 after 591 msecs
> [    2.537756] initcall usb_stor_init+0x0/0x32 returned 0 after 685 msecs

[ ... ]

> [    2.619477] initcall hid_init+0x0/0x3 returned 0 after 0 msecs
> [    2.629667] initcall hid_init+0x0/0x3e returned 0 after 9 msecs

685 isn't nice but better then 2000...

Rene.

