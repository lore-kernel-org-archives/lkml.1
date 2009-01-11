Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbZAKVjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbZAKVjl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 16:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbZAKVjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 16:39:24 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:42497 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbZAKVjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 16:39:23 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: current git kernel has strange problems during bisect
Date: Sun, 11 Jan 2009 22:39:20 +0100
User-Agent: KMail/1.9.9
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Johannes Schindelin <Johannes.Schindelin@gmx.de>, git@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200901111602.53082.borntraeger@de.ibm.com> <20090111194258.GA4840@uranus.ravnborg.org> <alpine.LFD.2.00.0901111200330.6528@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901111200330.6528@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901112239.20306.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 11 Januar 2009 schrieb Linus Torvalds:
> Well, you don't actually have to mark that semi-random one as good either. 
> What you can do is to just mark anything that _only_ contains fs/btrfs as 
> good. IOW, you don't have to know the magic number - you just have to be 
> told that "oh, if you only have btrfs files, and you're not actively 
> bisecting a btrfs bug, just do 'git bisect good' and continue".

That should work.

<rant>
Still, I am a bit frustrated. During this weekend I reported 2 regressions 
(wlan and ata)  and I still try to find out why suspend/resume stopped 
working. In the meantime I have identified 2 patches (one was already known, 
I reported the 2nd to the usb maintainers) after 2.6.28 that caused suspend 
to ram regressions. In rc1 S2R was broken again. So I tried bisecting the 
third patch - which finally brought me to the btrfs bisect problem.

For me, this was the most annoying  merge window ever.

In my opinion we should really avoid subtree merges in the future as a curtesy 
to people who do the uncool work of testing, problem tracking and bisecting. 
</rant>

Christian
