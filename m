Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbYJNBNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbYJNBNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 21:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYJNBNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 21:13:23 -0400
Received: from smtp.ono.com ([62.42.230.12]:18820 "EHLO resmaa01.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751239AbYJNBNW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 21:13:22 -0400
Date: Tue, 14 Oct 2008 03:13:20 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.27-git3: rtl8169 oops and wireless missing symbols
Message-ID: <20081014031320.2dc80177@werewolf.home>
In-Reply-To: <43e72e890810131723k227ff97bya17aee0d9a5da2b@mail.gmail.com>
References: <20081014010202.71d13eaf@werewolf.home>
	<20081013232432.GB32550@tuxdriver.com>
	<43e72e890810131723k227ff97bya17aee0d9a5da2b@mail.gmail.com>
X-Mailer: Claws Mail 3.6.1cvs2 (GTK+ 2.14.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008 17:23:57 -0700, "Luis R. Rodriguez" <mcgrof@gmail.com> wrote:

> On Mon, Oct 13, 2008 at 4:24 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > On Tue, Oct 14, 2008 at 01:02:02AM +0200, J.A. Magallón wrote:
> >
> >> werewolf:~# modprobe ath5k
> >> WARNING: Error inserting cfg80211 (/lib/modules/2.6.27-jam03/kernel/net/wireless/cfg80211.ko): Unknown symbol in module, or unknown parameter (see dmesg)
> >> WARNING: Error inserting mac80211 (/lib/modules/2.6.27-jam03/kernel/net/mac80211/mac80211.ko): Unknown symbol in module, or unknown parameter (see dmesg)
> >> FATAL: Error inserting ath5k (/lib/modules/2.6.27-jam03/kernel/drivers/net/wireless/ath5k/ath5k.ko): Unknown symbol in module, or unknown parameter (see dmesg)
> >> werewolf:~# modprobe mac80211
> >> WARNING: Error inserting cfg80211 (/lib/modules/2.6.27-jam03/kernel/net/wireless/cfg80211.ko): Unknown symbol in module, or unknown parameter (see dmesg)
> >> FATAL: Error inserting mac80211 (/lib/modules/2.6.27-jam03/kernel/net/mac80211/mac80211.ko): Unknown symbol in module, or unknown parameter (see dmesg)
> >>
> >> Dmesg is below.
> >
> > cfg80211 isn't loading, so mac80211 can't find it's symbols, and
> > ath5k can't find mac80211's symbols.
> 
> What symbols?
> 
> sudo rmmod ath5k
> sudo dmesg -c > /dev/null
> sudo modprobe ath5k
> sudo dmesg -c
> 
> >> cfg80211: Unknown parameter `ieee80211_regdom'
> 
> Ahh this one.. this is the 2 character module parameter you can pass
> to cfg80211 upon load and this is available only when
> CONFIG_WIRELESS_OLD_REGULATORY is enabled.
> 

BTW, I have not set this anywhere and it defaults to JP, instead of the world
domain as the code reads...

I set it in modprobe.conf and now is EU:

options cfg80211 ieee80211_regdom=EU


-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
