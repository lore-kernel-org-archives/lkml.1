Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbYCaV1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbYCaV1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 17:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757703AbYCaV1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 17:27:33 -0400
Received: from styx.suse.cz ([82.119.242.94]:39057 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756925AbYCaV1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 17:27:32 -0400
Date: Mon, 31 Mar 2008 23:27:30 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg KH <greg@kroah.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] evdev: Release eventual input device grabs when	getting
 disconnected
In-Reply-To: <20080331204221.GA19953@kroah.com>
Message-ID: <Pine.LNX.4.64.0803312326130.5541@jikos.suse.cz>
References: <20080330184259.GB21375@atjola.homenet>
 <alpine.LFD.1.00.0803301448190.14670@woody.linux-foundation.org>
 <200803310215.39414.dtor@insightbb.com> <20080331172813.GA11583@kroah.com>
 <20080331135653.ZZRA012@mailhub.coreip.homeip.net> <20080331204221.GA19953@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2008, Greg KH wrote:


> > Greg, please look at the change again. Before kobject_put(kobj->parent)
> > was done in kobject_cleanup() and so the parent would only be freed when
> > all its children are gone. Now parent is deleted early, even if its
> > children are still referenced by other users. This is lifetime rule
> > change and should really be announced as such.
> Ugh, this was done because of scsi, they required that if you really
> were deleting the parent, you wanted it gone.

What is the exact meaning of "gone" here please?

-- 
Jiri Kosina
