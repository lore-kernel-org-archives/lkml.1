Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237AbXDNRSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbXDNRSQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 13:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbXDNRSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 13:18:16 -0400
Received: from stinky.trash.net ([213.144.137.162]:64067 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbXDNRSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 13:18:15 -0400
Message-ID: <46210C82.6060701@trash.net>
Date: Sat, 14 Apr 2007 19:16:50 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: drraid@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Kernel 2.6.20.4 Unaligned address
References: <1f8291090704101602q41e30a7doe79f3606643b628b@mail.gmail.com> <20070413.163521.45883605.davem@davemloft.net>
In-Reply-To: <20070413.163521.45883605.davem@davemloft.net>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: "doctor raid" <drraid@gmail.com>
> Date: Tue, 10 Apr 2007 16:02:01 -0700
> 
> 
>>[1] kernel errors reporting unaligned access of memory
>>[2]  The following two lines iterate twice a piece, about once every 2 minutes:
>>
>>      Kernel unaligned access at TPC[79c344] arpt_do_table+0x3cc/0x640
>>       Kernel unaligned access at TPC[79c33c] arpt_do_table+0x3c4/0x640
> 
> 
> This patch below should fix this problem.
> 
> Patrick I'm going to push this to Linus.  Even if it doesn't
> fix this person's problem, either both the input device loop
> and the output device loop should use the "long" casting
> optimization or both should not :-)


Looks good, thanks Dave. On 64 bit both interfaces are unaligned
within struct arpt_arp:

char                       iniface[16];          /*    94    16 */
char                       outiface[16];         /*   110    16 */
