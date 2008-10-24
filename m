Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614AbYJXOZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbYJXOZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 10:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbYJXOZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 10:25:38 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:48194 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751884AbYJXOZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 10:25:37 -0400
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       NetDEV list <netdev@vger.kernel.org>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: Re: e1000e fails after several S3 resumes (2.6.26 Debian, TP T60) 
In-Reply-To: Your message of "Thu, 23 Oct 2008 15:42:55 PDT."
             <F169D4F5E1F1974DBFAFABF47F60C10A069DFD62@orsmsx507.amr.corp.intel.com> (sfid-20081023_194301_937814_89312B9F) 
X-Mailer: MH-E 8.1; nmh 1.2; GNU Emacs 22.2.1
Date: Fri, 24 Oct 2008 10:24:57 -0400
From: Sanjoy Mahajan <sanjoy@MIT.EDU>
Message-Id: <E1KtNaz-0003Xx-0y@approx.mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> hm, does your kernel have CONFIG_PM defined?  

It does have that defined:

  $ grep CONFIG_PM /boot/config-2.6.26-1-686 
  CONFIG_PM=y
  # CONFIG_PM_DEBUG is not set
  CONFIG_PM_SLEEP_SMP=y
  CONFIG_PM_SLEEP=y
  CONFIG_PM_STD_PARTITION=""

> if it happens again please include lspci -vvv before and after ethtool
> -r (see below)

I will.  Now I'm running BIOS 2.23, so I'm curious whether that
'upgrade' fixes the problem.

I say 'upgrade' because now S3 sleep and wakeup often take 60 seconds.
I've also noticed ACPI errors in the 'dmesg'.  Once I have something
reproducible I'll file a bugzilla report.

> device was also claiming successfully transmitting, so I don't know
> why the DHCP packets don't work, can you tcpdump on the network or the
> dhcp server by chance?

I'll do that too on the next failure.  Is 'tcpdump host 18.38.0.1'
sufficient or do I need a few -v switches?

> can you ifconfig eth0 promisc before doing suspend?  I'd be curious if
> that fixed it.

If/when it reproduces, I'll add that line to the pre-suspend code.  (I
use 's2ram', which I think sleeps with 'echo mem > /sys/power/state' and
does a vt switch on wakeup).

Generally: For making debugging go smoothly, is it worth running a
vanilla kernel rather than the Debian one?  I could try 2.6.26.7 or
2.6.27.3.  Is running 2.6.27.y not as useful as running 2.6.26.y, in
case the bug is merely hidden but not solved in the new kernel?  On the
other hand, I'm tempted to try 2.6.27.y in case it fixes the slow
suspend/resume.

-Sanjoy

`Until lions have their historians, tales of the hunt shall always
 glorify the hunters.'  --African Proverb
