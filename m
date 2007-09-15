Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbXIOSa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbXIOSa0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 14:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbXIOSaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 14:30:18 -0400
Received: from smtp27.orange.fr ([80.12.242.95]:56966 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbXIOSaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 14:30:16 -0400
X-ME-UUID: 20070915183014695.A9D211C00085@mwinf2711.orange.fr
Message-ID: <46EC24B6.2030709@free.fr>
Date: Sat, 15 Sep 2007 20:30:14 +0200
From: Eric Valette <eric.valette@free.fr>
Reply-To: eric.valette@free.fr
Organization: HOME
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Rob Hussey <robjhussey@gmail.com>
Cc: flamingice@sourmilk.net, andreamrl@tiscali.it,
       linux-kernel@vger.kernel.org, rol@witbe.net
Subject: Re: rtl8187 driver in 2.6.23-rc6-git5: kernel panic if not used as
 a module. Works as a module.
References: <46EBE70C.2040201@free.fr> <46EBEBD2.7060502@free.fr> <6b8cef970709150928h25a7093md5f86d2bdcf677cc@mail.gmail.com>
In-Reply-To: <6b8cef970709150928h25a7093md5f86d2bdcf677cc@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Hussey wrote:
> On 9/15/07, Eric Valette <eric.valette@free.fr> wrote:
>> Eric Valette wrote:
>>
>>> I can probably take a picture of the backtrace if you want.
>> Just saw that just above my message in the LKML web interface, someone
>> posted a backtrace. Mine is different but at least, we are at least two
>> to have the crash.
> 
> This is the same thing I said to Paul Rolland, since I think your
> problems are the same:
> I had this problem as well. It has to do with mac80211, cfg80211 and
> the rate control algorithm not initializing early enough in the boot
> process. These two patches should fix it:
> 
> [PATCH] mac80211: fix initialisation when built-in
> http://article.gmane.org/gmane.linux.kernel.wireless.general/5710/match=patch+mac80211+initialisation
> 
> [PATCH] cfg80211: fix initialisation if built-in
> http://article.gmane.org/gmane.linux.network/71326/match=patch+cfg80211+initialisation
> 
> Regards,
> Rob

Thanks for your help: it does indeed fix the problem.

Now I have two side questions:
	- the code is no more symetric "subsys_initcall" -> "module_exit". Do
not know if it is "normal" but I love symmetry in code :-). Did not test
it still works as a module...
	- Who takes the responsability to push a patch to Linus? I guess it is
urgent unless he plans a rc7

-- eric

