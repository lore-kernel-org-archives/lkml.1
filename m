Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbZCFIZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbZCFIZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 03:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbZCFIZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 03:25:01 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42815 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbZCFIZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 03:25:01 -0500
Message-ID: <49B0DDD6.2080608@redhat.com>
Date: Fri, 06 Mar 2009 09:24:54 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>,
       device-mapper development <dm-devel@redhat.com>
Subject: Re: [PATCH] Re: Oops using 2.6.28.n after a lazy umount of a crypted
 loop-device
References: <49AFA565.6030902@ahsoftware.de> <49AFBE4A.1010605@redhat.com> <49B0BFBD.7060208@ahsoftware.de>
In-Reply-To: <49B0BFBD.7060208@ahsoftware.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Holler wrote:
> Milan Broz schrieb:
>> Please Can you try attached patch if helps here?
>> (Patch is not perfect, but should help, at least identify that
>> it is the same problem I am fixing:-)
> 
> The patch works (I had to add an #include <linux/delay.h> /* msleep */).

ok, thanks.


> I've tested it using 2.6.28.7 and the script below. With your patch the 
> script was running over night looping about 400 times without any error. 
> A crosscheck without the patch needed only 10 iterations to get an oops. 
> So I assume you have fixed the problem I had. ;)
> 
> There stills seems to be another problem left, I've got 3 times the 
> kernel-message
> 
> device-mapper: ioctl: unable to remove open device 
> temporary-cryptsetup-21571

This is bug in cryptsetup related to udev (udev should not touch temporary
cryptsetup device) which is fixed upstream, but there is no
new release yet (Fedora has this patched, not sure about other distros)

see http://code.google.com/p/cryptsetup/source/detail?r=32 and other patches.

Milan
--
mbroz@redhat.com

