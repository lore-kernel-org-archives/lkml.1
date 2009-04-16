Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZDPVhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZDPVhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 17:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbZDPVgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 17:36:55 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:49043 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbZDPVgy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 17:36:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kPive23m7bmhabzrlqN68EbMdtLUqJyU0nzdUAlVQ4vu/L6KvJ31xPeHds2Nm7D5XK
         RWo04geEOijFcL7PE74ZjLGbZpL8fM2DoZdAt2dkP66uHasZnokXT6VLZCU87QnWW9BQ
         upYa5SOEzuYQXuUxnMMa7ECtwRApYiccQ+4SI=
MIME-Version: 1.0
In-Reply-To: <49E7A377.3000901@linux.intel.com>
References: <20090410231245.GF6719@linux.vnet.ibm.com>
	 <Pine.LNX.4.64.0904141801300.24679@blonde.anvils>
	 <200904150328.n3F3S0F9083222@www262.sakura.ne.jp>
	 <Pine.LNX.4.64.0904152036150.27354@blonde.anvils>
	 <200904160046.n3G0ki9o028612@www262.sakura.ne.jp>
	 <Pine.LNX.4.64.0904160551080.28048@blonde.anvils>
	 <200904160535.n3G5ZBIE006724@www262.sakura.ne.jp>
	 <Pine.LNX.4.64.0904162145130.645@blonde.anvils>
	 <20090416212436.GA31113@suse.de> <49E7A377.3000901@linux.intel.com>
Date: Thu, 16 Apr 2009 22:36:52 +0100
Message-ID: <87a5b0800904161436u2226daf4y7bbaf99c4ac85f1a@mail.gmail.com>
Subject: Re: Please revert kobject_uevent UMH_NO_WAIT
From: Will Newton <will.newton@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Greg KH <gregkh@suse.de>, Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       alan@lxorguk.ukuu.org.uk, viro@zeniv.linux.org.uk, jmorris@namei.org,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 10:30 PM, Arjan van de Ven
<arjan@linux.intel.com> wrote:
> Greg KH wrote:
>>
>> On Thu, Apr 16, 2009 at 09:55:29PM +0100, Hugh Dickins wrote:
>>>
>>> Please revert commit f520360d93cdc37de5d972dac4bf3bdef6a7f6a7
>>> "kobject: don't block for each kobject_uevent".
>>>
>>> Tetsuo Handa, running a kernel with CONFIG_DEBUG_PAGEALLOC=y
>>> and CONFIG_UEVENT_HELPER_PATH=/sbin/hotplug, has been hitting RCU
>>> detected CPU stalls: it's been spinning in the loop where do_execve()
>>> counts up the args (but why wasn't fixup_exception working? dunno).
>>>
>>> The recent change, switching kobject_uevent_env() from UMH_WAIT_EXEC
>>> to UMH_NO_WAIT, is broken: the exec uses args on the local stack here,
>>> and an env which is kfreed as soon as call_usermodehelper() returns.
>>> It very much needs to wait for the exec to be done.
>>>
>>> Or keep the UMH_NO_WAIT, and complicate the code to allocate and free
>>> these resources correctly?  No, as GregKH pointed out when making the
>>> commit, CONFIG_UEVENT_HELPER_PATH="" is a much better optimization -
>>> though some distros are still saying /sbin/hotplug in their .config,
>>> yet with no such binary in their initrd or their root.
>>>
>>> Or...
>>>
>>> [PATCH] revert kobject_uevent UMH_NO_WAIT
>>>
>>> Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
>>> Signed-off-by: Hugh Dickins <hugh@veritas.com>
>>
>> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> Acked-by: Arjan van de Ven <arjan@linux.intel.com>
> as well
>
> not worth the hassle if this breaks too much

Acked-by: Will Newton <will.newton@gmail.com>

It's causing crashes for me too (reported 10 days ago).

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
