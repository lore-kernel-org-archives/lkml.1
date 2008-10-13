Return-Path: <linux-kernel-owner+w=401wt.eu-S1760781AbYJMXoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760781AbYJMXoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 19:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756951AbYJMXoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 19:44:10 -0400
Received: from smtp.ono.com ([62.42.230.12]:42979 "EHLO resmaa01.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755862AbYJMXoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 19:44:09 -0400
Date: Tue, 14 Oct 2008 01:44:06 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.27-git3: rtl8169 oops and wireless missing symbols
Message-ID: <20081014014406.318db8e7@werewolf.home>
In-Reply-To: <20081013232432.GB32550@tuxdriver.com>
References: <20081014010202.71d13eaf@werewolf.home>
	<20081013232432.GB32550@tuxdriver.com>
X-Mailer: Claws Mail 3.6.1cvs2 (GTK+ 2.14.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008 19:24:33 -0400, "John W. Linville" <linville@tuxdriver.com> wrote:

> On Tue, Oct 14, 2008 at 01:02:02AM +0200, J.A. Magallón wrote:
> 
> > werewolf:~# modprobe ath5k
> > WARNING: Error inserting cfg80211 (/lib/modules/2.6.27-jam03/kernel/net/wireless/cfg80211.ko): Unknown symbol in module, or unknown parameter (see dmesg)
> > WARNING: Error inserting mac80211 (/lib/modules/2.6.27-jam03/kernel/net/mac80211/mac80211.ko): Unknown symbol in module, or unknown parameter (see dmesg)
> > FATAL: Error inserting ath5k (/lib/modules/2.6.27-jam03/kernel/drivers/net/wireless/ath5k/ath5k.ko): Unknown symbol in module, or unknown parameter (see dmesg)
> > werewolf:~# modprobe mac80211
> > WARNING: Error inserting cfg80211 (/lib/modules/2.6.27-jam03/kernel/net/wireless/cfg80211.ko): Unknown symbol in module, or unknown parameter (see dmesg)
> > FATAL: Error inserting mac80211 (/lib/modules/2.6.27-jam03/kernel/net/mac80211/mac80211.ko): Unknown symbol in module, or unknown parameter (see dmesg)
> > 
> > Dmesg is below.
> 
> cfg80211 isn't loading, so mac80211 can't find it's symbols, and
> ath5k can't find mac80211's symbols.
> 
> > cfg80211: Unknown parameter `ieee80211_regdom'
> 
> config WIRELESS_OLD_REGULATORY
> 	bool "Old wireless static regulatory definitions"
...
> 
> Is this not clear enough?
> 

NO.

I'm a complete literate in wireles internals. Not in other areas. And I
don't undestand a word about regulations and so on. The only thing
I see there is 'OLD WAY of doing things', so I disable it. I expect
two things:

- As it is an optional thing I can toggle, no driver depends on it.
- If I choose a driver that depends on it, it will get automagically
  selected.

So, please, if migration is not finished:

- Default it as Y, or add a depend on every driver that uses it
- Hide it under the famous 'crazy hacker-only things' boolean

It is enough to have to choose between mac80211 and ieee80211.

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
