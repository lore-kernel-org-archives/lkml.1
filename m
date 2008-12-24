Return-Path: <linux-kernel-owner+w=401wt.eu-S1751812AbYLXWS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbYLXWS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 17:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYLXWSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 17:18:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:13664 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbYLXWSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 17:18:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bpWXCcKJlapjrzZT1Ttw/3C5yKgMdat+cCC5obUMoJDXNdEPHnlwi6wbhLhJ/CHQKC
         drpLpo4CEBFSz0WDHq4rDFEJUKcHoOvW9gGuiNh8CTap8MZWhBR+eTUNRrq/NEjrRwrA
         aajFH1Qak4eLQve8Vi/ncDstO5MePGk4gMRbs=
Message-ID: <69e28c910812241418x11925680n702bfcdd694db543@mail.gmail.com>
Date: Wed, 24 Dec 2008 23:18:13 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: mmotm 2008-12-24-01-20 uploaded (ath9k)
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4952ACF2.9010502@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200812240930.mBO9U3e6030301@imap1.linux-foundation.org>
	 <495279BB.1090703@oracle.com> <20081224192132.GO5944@tesla>
	 <4952ACF2.9010502@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2008 at 10:43 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Luis R. Rodriguez wrote:
>> On Wed, Dec 24, 2008 at 10:04:43AM -0800, Randy Dunlap wrote:
>>> akpm@linux-foundation.org wrote:
>>>> The mm-of-the-moment snapshot 2008-12-24-01-20 has been uploaded to
>>>>
>>>>    http://userweb.kernel.org/~akpm/mmotm/
>>>>
>>>> and will soon be available at
>>>>
>>>>    git://git.zen-sources.org/zen/mmotm.git
>>>
>>> ath9k build fails with:
>>>
>>> drivers/built-in.o: In function `ath_detach':
>>> main.c:(.text+0xee655): undefined reference to `rfkill_unregister'
>>> drivers/built-in.o: In function `ath_rfkill_poll':
>>> main.c:(.text+0xeedfa): undefined reference to `rfkill_force_state'
>>> drivers/built-in.o: In function `ath9k_start':
>>> main.c:(.text+0xefe79): undefined reference to `rfkill_register'
>>> main.c:(.text+0xeff20): undefined reference to `rfkill_free'
>>> drivers/built-in.o: In function `ath_pci_probe':
>>> main.c:(.text+0xf0f73): undefined reference to `rfkill_allocate'
>>>
>>> when ath9k is built-in and CONFIG_RFKILL=m.
>>>
>>> config attached.
>>
>> <-- snip -->
>>
>>> # CONFIG_MAC80211_DEBUGFS is not set
>>> # CONFIG_MAC80211_DEBUG_MENU is not set
>>> CONFIG_RFKILL=m
>>> CONFIG_RFKILL_INPUT=m
>>> CONFIG_RFKILL_LEDS=y
>>
>> Try this (already merged into wireless-testing):
>
> This seems to be already merged/used in mmotm and that's where the
> build failure happened.
>
> And this patch does not address how to call rfkill interfaces when
> CONFIG_RFKILL=m and ath9k is built into the kernel image...
>

IMO we should not allow compiling-in ath9k when rfkill is built as a
module, similar to how we do for mac80211 (CONFIG_MAC80211=m requires
all drivers to be modules).

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
