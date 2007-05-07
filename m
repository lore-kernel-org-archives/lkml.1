Return-Path: <linux-kernel-owner+w=401wt.eu-S966193AbXEGSgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966193AbXEGSgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 14:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966178AbXEGSgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 14:36:36 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:1648 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966174AbXEGSgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 14:36:35 -0400
X-Hashcash: 1:23:070507:linux-kernel@vger.kernel.org::0gOh30vzOE1OATda:000000000000000000000000000000000KLXB
From: James Cloos <cloos@jhcloos.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v10
In-Reply-To: <20070507163342.GA3502@elte.hu> (Ingo Molnar's message of "Mon\, 7
	May 2007 18\:33\:42 +0200")
References: <20070507163342.GA3502@elte.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/23.0.0 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAMnRFWHRUaXRsZQAvbWF4dG9y
 L2Nsb29zL2luY29taW5nLzIwMDQvMDIvUFdHL0pIQzE2LnBuZyJMlEwAAAAadEVYdFNvZnR3YXJl
 AEdOT01FIEljb24gRWRpdG9ynioKbAAAAHFJREFUeJzFk8EKwCAMQ1/ED9cvzw6iuM0N9WIvDTWE
 1KjAxmKnLBEBjLcEIBCeI2nccy5YKrjxwbbvAvZ37zlo4GB9iRMC/cq/AppItwmMyJ5I98wd9G7P
 xxgrSKlYS2lMrOcV13o95aVSKA7E5ndGXG+IIzcl4BNfAAAAAElFTkSuQmCC
Copyright: Copyright 2007 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
X-Hashcash: 1:23:070507:mingo@elte.hu::RVNnfg6BzRJ5uXFP:0000N55p
Date: Mon, 07 May 2007 14:35:42 -0400
Message-ID: <m3abwgqy5m.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I finally had time to try bisecting the problem I was having with cfs8
and master Sunday, and was able to eliminate the problem.

I had first done:

  clone
  branch
  checkout
  apply
  commit
  pull

If instead of pulling master into the cfs branch, I rather switch to the
master branch and pull the cfs branch into that, it works.

I'll try updating to the current master with v10 to confirm.

For those who want to follow, do:


#!/bin/sh
git clone -l -s -n \
 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git \
 2.6.21-cfs-master
cd 2.6.21-cfs-master
git checkout -b git checkout -b cfs v2.6.21
git pull git://people.freedesktop.org/~cloos/cfs-2.6.git
git checkout master
git pull . cfs


The master branch of git://people.freedesktop.org/~cloos/cfs-2.6.git
has 2.6.21 with the sched-cfs-v10-v2.6.21.1.patch.  Cf gitweb at:

http://gitweb.freedesktop.org/?p=/users/cloos/cfs-2.6.git

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
