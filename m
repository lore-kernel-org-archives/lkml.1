Return-Path: <linux-kernel-owner+w=401wt.eu-S1766715AbXDSOR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766715AbXDSOR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 10:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766717AbXDSORz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 10:17:55 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:65134 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766715AbXDSORy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 10:17:54 -0400
Date: Thu, 19 Apr 2007 16:19:42 +0200
From: DervishD <lkml@dervishd.net>
To: Juergen Beisert <juergen127@kreuzholzen.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Wrong free clusters count on FAT32
Message-ID: <20070419141942.GF8287@DervishD>
Mail-Followup-To: Juergen Beisert <juergen127@kreuzholzen.de>,
	linux-kernel@vger.kernel.org
References: <20070419085750.GA2833@DervishD> <200704191352.06456.juergen127@kreuzholzen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200704191352.06456.juergen127@kreuzholzen.de>
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Juergen :)

 * Juergen Beisert <juergen127@kreuzholzen.de> dixit:
> On Thursday 19 April 2007 10:57, DervishD wrote:
> > I have a portable device with a FAT32 formatted hard disk in it, and
> > everytime I delete a file in the device *using the device itself to
> > do it* the device increases its count of free space and if I plug
> > the device in a Windows system, Windows agrees on the free space.
> > Linux doesn't. Linux believes that the files are still there
> > ocuppying space, and I have to run fsck.vfat to fix the problem.
> 
> As I remember: It needs a large amount of time to calculate the free
> space on a big FAT32 system.

    Big fat truth, I'm afraid. The thing is that I thought that Linux
did that from time to time to update the count. Obviously, doing it for
every statfs call would be very expensive :((

> So the last free sector count is also stored. When mounting this
> filesystem you don't need to walk through the whole FAT to calculate
> the available space, you can use this "cached" value instead. And this
> cached value seems not to be updated in your portable device.

    It doesn't, certainly, but Windows doesn't care. Moreover, the
device doesn't seem to recalculate the value on every run (unless it
does it lightning fast!), so maybe the number is stored elsewhere (the
count can be stored in many places as far as I've read, but I don't know
the details).

    A mount option to force walking the FAT and getting the real info
could be interesting. That way, it will be only done for certain devices
(small disks, for example).

    Thanks for your answer :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
