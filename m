Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbZJKObV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbZJKObV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 10:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755326AbZJKObU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 10:31:20 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:57504 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbZJKObT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 10:31:19 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Oct 2009 10:31:19 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Mzl1n0WQKR+qwMQ+EK06fiPYKQSOzorTP11YayaKnrNET/dw328k8KHKVuEILSI3L5
         nR4601xbD3azLDmlDY05l+gdro3878/0dhuNtCU0dTvxRRP/2rQrQA/1Lmc+JVyKig9d
         W+2ij8ITYXVTb9IzJ44IgDwSN0nvK6B2kpG5A=
Message-ID: <4AD1EA65.3070805@lwfinger.net>
Date: Sun, 11 Oct 2009 09:23:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-2.1 Thunderbird/3.0b4
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Dave Young <hidave.darkstar@gmail.com>, akpm@linux-foundation.org,
       bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [mmotm 2009-10-09-01-07] b43/wireless possible circular locking
References: <20091011094139.GA2778@darkstar> <1255254687.4095.46.camel@johannes.local>
In-Reply-To: <1255254687.4095.46.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2009 04:51 AM, Johannes Berg wrote:
> On Sun, 2009-10-11 at 17:41 +0800, Dave Young wrote:
>> Hi,
>>
>> I got lockdep warnings about possible circular lock with
>> b43 interface startup. It looks like a real problem.
>>
>> [   71.974542] wlan0: deauthenticating from 00:19:e0:db:24:de by local choice (reason=3)
>> [   72.004352] b43-phy0 debug: Removing Interface type 2
>> [   72.005431] 
>> [   72.005435] =======================================================
>> [   72.006168] [ INFO: possible circular locking dependency detected ]
>> [   72.006759] 2.6.32-rc3-mm1 #4
>> [   72.007047] -------------------------------------------------------
>> [   72.007617] ifconfig/2175 is trying to acquire lock:
>> [   72.007617]  (&(&rfkill->poll_work)->work){+.+...}, at: [<c0239375>] __cancel_work_timer+0x8c/0x18e
>> [   72.007617] 
>> [   72.007617] but task is already holding lock:
>> [   72.007617]  (&wl->mutex){+.+.+.}, at: [<f8fa5359>] b43_op_stop+0x28/0x6a [b43]
> 
> I believe this is already taken care of by Larry.

Yes, I introduced this bug and fixed it. The latest wireless-testing
should have the fix. In addition, it is on its way to Linus through
DameM. Unfortunately, that fix has another bug that will not show up
in the logs. With it, it is impossible to turn the radio back on after
it is killed via the rfkill switch. A "final" (And I hope that is
true!) fix is out for testing; however, the OP for the bug that
started this whole chain only has limited access to the machine in
question.

Larry
