Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbZLTJJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbZLTJJr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 04:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbZLTJJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 04:09:45 -0500
Received: from bar.sig21.net ([80.81.252.164]:49360 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbZLTJJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 04:09:44 -0500
Date: Sun, 20 Dec 2009 10:10:19 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michael Guntsche <mike@it-loops.com>,
       Oliver Hartkopp <oliver@hartkopp.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, mjt@tls.msk.ru,
       mmarek@suse.cz
Subject: Re: 2.6.33-rc1 Reboot right after bootloader
Message-ID: <20091220091019.GA20246@sig21.net>
References: <20091219233457.GA4288@trillian.comsick.at>
 <20091220084656.GA485@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091220084656.GA485@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -4.0 (----)
X-Spam-21-Report: No, score=-4.0 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.361,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 09:46:56AM +0100, Sam Ravnborg wrote:
> On Sun, Dec 20, 2009 at 12:34:57AM +0100, Michael Guntsche wrote:
> > 
> > I took me some time but I tracked down my reboot problem. The culprit is
> > commit 
> > 
> > 4a2ff67c88211026afcbdbc190c13f705dae1b59: kbuild: fix bzImage build for
> > x86
> 
> Just to check what is going wrong here could you try to execute the following two commands:
> printf \\xa8\\x51\\x37\\x00 > x ; hexdump x
> /usr/bin/printf \\xa8\\x51\\x37\\x00 > x ; hexdump x
> echo -ne \\xa8\\x51\\x37\\x00 > x ; hexdump x
> 
> Please try as above and also with full path to printf (/usr/bin/printf)

Debian dash has a built-in printf which doesn't support \x.
/usr/bin/printf works fine.

$ printf \\xa8\\x51\\x37\\x00 > x ; hexdump x
0000000 785c 3861 785c 3135 785c 3733 785c 3030
0000010
$ /usr/bin/printf \\xa8\\x51\\x37\\x00 > x ; hexdump x
0000000 51a8 0037                              
0000004
$ echo -ne \\xa8\\x51\\x37\\x00 > x ; hexdump x
0000000 6e2d 2065 785c 3861 785c 3135 785c 3733
0000010 785c 3030 000a                         
0000015


Johannes
