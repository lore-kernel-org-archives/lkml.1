Return-Path: <linux-kernel-owner+w=401wt.eu-S1759688AbZF3PLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759688AbZF3PLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 11:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbZF3PLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 11:11:39 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:47457 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758439AbZF3PLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 11:11:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=jkbW9elYJe6mP2nduQMBnsnDQWH0WwGhn0mxsN9ogLzomzTcN7qFQ81f01CLVI/78i
         99GTjJsTs6PlmrYXCZY1VKM5dK0Qvg1v+VrZ4v3u7kMY0tQBRqkdIFBXmdeh5dUTbNxX
         AMntqUjs3A5gXxKnyDV3t3BDXhGKy0y1W/59c=
Subject: Re: [BUG] MIPS: Hibernation in the latest linux-mips:master branch
 not work
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Ralf Baechle <ralf@linux-mips.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <20090630144540.GA18212@linux-mips.org>
References: <1246372868.19049.17.camel@falcon>
	 <20090630144540.GA18212@linux-mips.org>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Tue, 30 Jun 2009 23:11:27 +0800
Message-Id: <1246374687.20482.10.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-30 at 15:45 +0100, Ralf Baechle wrote:
> On Tue, Jun 30, 2009 at 10:41:08PM +0800, Wu Zhangjin wrote:
> 
> > I just updated my git repository to the master branch of the latest
> > linux-mips git repository, and tested the STD/Hibernation support on
> > fuloong2e and yeeloong2f, it failed:
> > 
> > when using the no_console_suspend kernel command line to debug, it
> > stopped on:
> > 
> > PM: Shringking memory... done (1000 pages freed)
> > PM: Freed 160000 kbytes in 1.68 seconds (95.23 MB/s)
> > PM: Creating hibernation image:
> > PM: Need to copy 5053 pages
> > PM: Hibernation image created (4195 pages copied)
> > 
> > and then, the number indicator light of keyboard works well, but can not
> > type anything. 
> > 
> > anybody have tested it on another platform? does it work?
> 
> At the time of the merge I tested it on Malta and found it to be working.

thanks! I will test it again and analyze why.

hi, ralf, in the latest master branch of linux-mips git repo, seems
there is a need to select the SYS_SUPPORTS_HOTPLUG_CPU option in every
uni-processor board, otherwise, the suspend/hibernation can not be used,
because you have set:

config ARCH_HIBERNATION_POSSIBLE
    def_bool y
    depends on SYS_SUPPORTS_HOTPLUG_CPU

config ARCH_SUSPEND_POSSIBLE
    def_bool y
    depends on SYS_SUPPORTS_HOTPLUG_CPU

so, the board-specific patch must be pushed by the maintainers of
boards. and if the board support SMP, they must implement the
mips-specific hotplug support, is this right? I have selected
SYS_SUPPORTS_HOTPLUG_CPU in LEMOTE_FULONG and will push a relative patch
later.

Regards,
Wu Zhangjin

