Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbYDADad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbYDADad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 23:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbYDADaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 23:30:24 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:6313 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbYDADaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 23:30:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=aWeqzWUxARQNksmjoI6v7neve5Flgl4pUOOCsOF2nkZDPU85t8dnbKylkv7i3woCZgGtCD+1kKMn6O8tyCIoapCmyKmrgu1hd/y7l3sThLZhqJQJwp8VBIlGsRASvhndVdg9aNN6NmC53Oze8XsQsiJjMWbKwK17r2TU9MAbHFE=
Date: Mon, 31 Mar 2008 23:30:19 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] evdev: Release eventual input device grabs when getting
	disconnected
Message-ID: <20080401033019.GA18041@anvil.corenet.prv>
References: <20080330184259.GB21375@atjola.homenet> <alpine.LFD.1.00.0803301448190.14670@woody.linux-foundation.org> <200803310215.39414.dtor@insightbb.com> <20080331172813.GA11583@kroah.com> <20080331135653.ZZRA012@mailhub.coreip.homeip.net> <20080331204221.GA19953@kroah.com> <20080331165456.ZZRA012@mailhub.coreip.homeip.net> <20080331220906.GA28171@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331220906.GA28171@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 03:09:06PM -0700, Greg KH wrote:
> On Mon, Mar 31, 2008 at 04:57:36PM -0400, Dmitry Torokhov wrote:
> > 
> > Ok, I really liked the old behavior better, but if it is to stay then
> > we need something like this (not for inclusion yet as mousedev and joydev
> > need to be adjusted as well):
> 
> Yes, that's the proper behavior anyway, as you are passing off a pointer
> to a device, you need to keep the reference to that device around until
> you are finished with it.
> 
> I'm amazed that this wasn't causing a problem before the kobject change,
> as this should have been needed there as well.  Would running with slab
> debugging cause it to hit then?
> 

It worked because evdev (and mousedev, joydev) are direct children of
input_dev and prior to Kay change parent would stay till all childrens
are gone.

I will ask Linus to pull extended patch covering also joydev and mousedev
shortly.

-- 
Dmitry
