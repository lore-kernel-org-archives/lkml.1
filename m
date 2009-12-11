Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbZLKUlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbZLKUlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 15:41:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZLKUlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 15:41:05 -0500
Received: from smtp.nokia.com ([192.100.122.233]:34036 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbZLKUlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 15:41:03 -0500
Date: Fri, 11 Dec 2009 22:40:14 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext sai pavan <saipavan.243@gmail.com>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [RFC/PATCH 2/5] usb: otg: twl4030: add support for notifier
Message-ID: <20091211204014.GA30776@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com>
 <1260531086-23857-3-git-send-email-felipe.balbi@nokia.com>
 <c60a9cb0912110922g10fd0cc7m3b3430731db5ed81@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c60a9cb0912110922g10fd0cc7m3b3430731db5ed81@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Dec 2009 20:40:31.0583 (UTC) FILETIME=[2E6F7EF0:01CA7AA2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 11, 2009 at 06:22:14PM +0100, ext sai pavan wrote:
>> @@ -628,7 +628,8 @@ static irqreturn_t twl4030_usb_irq(int irq, void *_twl)
>>                else
>>                        twl4030_phy_resume(twl);
>>
>> -               twl4030charger_usb_en(status == USB_LINK_VBUS);
>> +               blocking_notifier_call_chain(&twl->otg.notifier, status,
>> +                               twl->otg.gadget);
>>        }
>
>You might not want to invoke blocking notifier chain(may sleep) from
>interrupt context. May be atomic notifier chain is appropriate here.

that's a threaded irq. Maybe we should patch all twl children to use 
request_threaded_irq() already. I'll test that tomorrow.

-- 
balbi
