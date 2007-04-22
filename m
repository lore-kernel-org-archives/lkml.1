Return-Path: <linux-kernel-owner+w=401wt.eu-S1030196AbXDVLPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030196AbXDVLPq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 07:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030284AbXDVLPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 07:15:46 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:62228 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030196AbXDVLPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 07:15:45 -0400
Date: Sun, 22 Apr 2007 13:17:33 +0200
From: DervishD <lkml@dervishd.net>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Juergen Beisert <juergen127@kreuzholzen.de>, linux-kernel@vger.kernel.org
Subject: Re: Wrong free clusters count on FAT32
Message-ID: <20070422111733.GA5786@DervishD>
Mail-Followup-To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Juergen Beisert <juergen127@kreuzholzen.de>,
	linux-kernel@vger.kernel.org
References: <20070419085750.GA2833@DervishD> <200704191352.06456.juergen127@kreuzholzen.de> <20070419141942.GF8287@DervishD> <87d51xtkmp.fsf@duaron.myhome.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87d51xtkmp.fsf@duaron.myhome.or.jp>
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Ogawa :)

 * OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> dixit:
> DervishD <lkml@dervishd.net> writes:
> > A mount option to force walking the FAT and getting the real
> > info could be interesting. That way, it will be only done for
> > certain devices (small disks, for example).
> 
> Yes. It seems that Windows does not update the ->free_clusters
> correctly. Probably, I think the option is good for now. What do you
> think about an attached patch?

    The option ignores ->free_clusters by default, am I wrong? I'm not
sure about this: given that nobody cared before, chances are that this
problem didn't bite anyone, so I think that the default behaviour should
be the _old_ behaviour (that is, nofree=0, as if the option never
existed).

    Moreover, I'm not sure if Windows updates correctly or not the
free_clustes FSINFO entry, this problem has happened (by now) in a
portable device only. What I can ensure is that both the portable device
and any Windows box I've tested ignores this value and properly
calculate the real free space. Linux doesn't because it relies on an
invalid value. Again, the fault is in the portable device, but the
workaround seems common practice out there...

    So I will suggest just "nofree:0" instead of "nofree:1". And thanks
a lot for the patch :))) I'm not sure about this: given that nobody
cared before, chances are that this problem didn't bite anyone, so I
think that the default behaviour should be the _old_ behaviour (that is,
nofree=0, as if the option never existed).

    Moreover, I'm not sure if Windows updates correctly or not the
free_clustes FSINFO entry, this problem has happened (by now) in a
portable device only. What I can ensure is that both the portable device
and any Windows box I've tested ignores this value and properly
calculate the real free space. Linux doesn't because it relies on an
invalid value. Again, the fault is in the portable device, but the
workaround seems common practice out there...

    So I will suggest just "nofree:0" instead of "nofree:1". And thanks
a lot for the patch :)))

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
