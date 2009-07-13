Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbZGMTzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbZGMTzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 15:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbZGMTzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 15:55:09 -0400
Received: from smtp.df.ru ([195.42.160.16]:58314 "EHLO smtp.df.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755584AbZGMTzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 15:55:08 -0400
Date: Mon, 13 Jul 2009 23:55:58 +0400
From: Alexey Vlasov <renton@renton.name>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Counters in df, du
Message-ID: <20090713195558.GC5569@beaver.vrungel.ru>
References: <20090713081106.GA5569@beaver.vrungel.ru> <87fxd19cfq.fsf@basil.nowhere.org> <20090713113252.GB5569@beaver.vrungel.ru> <3e8340490907130654i3d00aa6dt9118004c2fd94689@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <3e8340490907130654i3d00aa6dt9118004c2fd94689@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 09:54:22AM -0400, Bryan Donlan wrote:
> >> Alexey Vlasov <renton@renton.name> writes:
> >> >
> >> > I know that df, du can show different values if some files were deleted,
> >> > but the processes which opened these files are still acting.
> >>
> >> You can check for that by doing ls -l /proc/*/fd | grep deleted
> >>
> >> It won't tell you the file size though.
> >
> > There comes a big list, like this:
> >
> > lowx------ 1 root root 64 Jul 13 14:58 1763 -> /tmp/ZCUDXqiMTp (deleted)
> >
> > The most interesting is that the /tmp size constantly grows.
> 
> lsof -n | grep deleted

# lsof -n /tmp | awk '/deleted/ {if ($7 != 0) print$0}'

mysqld    22905                          mysql    6u   REG
0,13    20 663938322 /tmp/ib1oZTSZ (deleted)
mysqld    22905                          mysql    8u   REG
0,13 84773 663938424 /tmp/ibRcarbD (deleted)

# df -h /tmp
Filesystem            Size  Used Avail Use% Mounted on
tmpfs                 4.1G  3.4G  630M  85% /tmp

It will soon be up to 100% full and I'll have to remount.

-- 
BRGDS. Alexey Vlasov.
