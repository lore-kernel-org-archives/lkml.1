Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbXIPL5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbXIPL5j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 07:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbXIPL5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 07:57:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51032 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbXIPL5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 07:57:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [1/3] 2.6.23-rc6: known regressions v2 --- ieee1394, empty suspend stopped working
Date: Sun, 16 Sep 2007 14:09:13 +0200
User-Agent: KMail/1.9.5
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       linux1394-devel@lists.sourceforge.net,
       Ben Collins <ben.collins@ubuntu.com>
References: <46EB436E.6030509@googlemail.com> <46ECF8C8.5040308@s5r6.in-berlin.de>
In-Reply-To: <46ECF8C8.5040308@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709161409.14908.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 16 September 2007 11:35, Stefan Richter wrote:
> Michal Piotrowski wrote:
> > FireWire
> 
> Could you title it "IEEE1394" instead?  (According to the information so
> far, it's in drivers/ieee1394, not drivers/firewire.)
> 
> > Subject         : empty suspend stopped working around 2.6.23-rc4
> > References      : http://lkml.org/lkml/2007/9/11/326
> > Last known good : ?
> > Submitter       : Pavel Machek <pavel@ucw.cz>
> > Caused-By       : ?
> > Handled-By      : ?
> > Status          : unknown
> 
> I did a quick test on my main test machine, a Mac mini running x86-64
> Linux.  Regardless whether swap is on or off and whether ieee1394 and
> ohci1394 are loaded or not, it always behaves the same.  It does
> something, then ends up with power LED off but a non-blinking cursor,
> i.e. _, still shown on the text console.  Is this good or bad?

Bad.  It's supposed to power off the machine.

Can you please try "echo test > /sys/power/disk" before the hibernation?

After that "echo disk > /sys/power/state" should only "suspend" the box
for several seconds and come back to the command prompt.

If that fails, please try

# echo testproc > /sys/power/disk
# echo disk > /sys/power/state

and see if this returns to the command prompt.

Greetings,
Rafael
