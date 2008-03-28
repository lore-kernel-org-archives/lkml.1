Return-Path: <linux-kernel-owner+w=401wt.eu-S1757819AbYC1X1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbYC1X1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 19:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbYC1X1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 19:27:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41801 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbYC1X1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 19:27:02 -0400
Message-ID: <47ED7EBD.8070009@zytor.com>
Date: Fri, 28 Mar 2008 16:26:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: "John T." <j.thomast@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: UTF-8 and Alt key in the console
References: <205509.99433.qm@web45710.mail.sp1.yahoo.com> <alpine.LNX.1.00.0803231942380.3157@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.00.0803231942380.3157@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
>>> The best probably would be to introduce an escape code, along the lines
>>> of other escape codes in the terminal interfae.
>>
>> You're right.
>>
>> Many say Unix is also broken compared to Plan 9.. sometimes it's
>> too late. The real fix for this issue seems like it'd be very
>> hard to accomplish.
> 
> The idea of revamping the escape codes is not all that bad.
> 
> Thanks to terminfo, this should be easy. Change vt.c,
> add corresponding terminfo entry and set TERM to something
> that has not previously existed.
> 
> About the ESC key, I thought, would it suffice to replace its
> current output of ^[ with ^[^[?

It would be better to assign a CSI (ESC [) code to it, like other 
function keys.  Unfortunately, the terminal everyone tries to emulate 
(Linux does so quite poorly due to its broken implementation of ISO 
2022, but that's less of an issue with UTF-8), VT 220, had ESC on the 
F11 key, so the CSI 2 3 ~ sequence it uses we use for the F11 key. 
Doesn't mean we can't assign another one.

One would also like to distinguish, say, Backspace from Ctrl-H.  This is 
trickier, because the termios settings don't permit compound keys.  The 
most obvious way to deal with that is an escape code for Ctrl-H, but 
that has the risk of breaking a lot of other things.

	-hpa
