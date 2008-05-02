Return-Path: <linux-kernel-owner+w=401wt.eu-S934637AbYEBMQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934637AbYEBMQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762082AbYEBMQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:16:22 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45084 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbYEBMQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:16:21 -0400
Date: Fri, 2 May 2008 14:16:19 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: davem@davemloft.net
Subject: Who reverted 2.6.25 - stats
Message-ID: <alpine.LNX.1.10.0805021332510.6463@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Subject modeled upon the "Who wrote 2.6.x" series from LWN)
Hello everyone,


following the implied "suggestion" of David Miller to track reverts in 
http://marc.info/?l=linux-kernel&m=120959059828048&w=2 , I stitched 
together a short script that evaluates the commit log summary and prints 
a overview who has the most reverts and who got reverted most. There are 
surprisingly few revert commits -- currently, perhaps because, as he 
says, a "reluctance to even suggest reverts".

One thing I noticed is that reverts are not always marked with the word 
"revert" in the summary line even though it normally would be, for 
example
	6b8e1c7e x86: 8K stacks by default
	d61ecf0b x86: 4kstacks default
(People evading the revert statistics?)
So that is not counted, but I wanted to make aware of it.
Stats are below.

> git log v2.6.25..linus/master --pretty="format:<%an>%s" | ./git-revert-stats
 P#  COMM#  NAME --- Top people doing the revert:
  1      1  Paul Mackerras
  2      1  David S. Miller
  3      1  Ingo Molnar
  4      1  Andrew Morton
  5      1  John W. Linville

 P#  COMM#  NAME --- Top developers with reverted commits:
  1      1  Andreas Schwab
  2      1  Michael Beasley
  3      1  Ingo Molnar
  4      1  Luis Carlos Cobo
  5      1  Yasunori Goto

A bit more interesting are the tallies for older releases:

> git log v2.6.24..v2.6.25 --pretty="format:<%an>%s" | ./git-revert-stats -o
 P#  COMM#  NAME --- Top people doing the revert:
  1      6  Linus Torvalds
  2      5  Len Brown
  3      4  Andrew Morton
  4      3  Ingo Molnar
  5      2  Paul Mackerras
  6      2  David S. Miller
  7      2  Bartlomiej Zolnierkiewicz
  *     10 developers with only one revert are omitted

 P#  COMM#  NAME --- Top developers with reverted commits:
  1      2  Matthew Garrett
  2      2  Ingo Molnar
  3      2  Alexey Starikovskiy
  4      2  Christoph Lameter
  *     20 developers with only one revert are omitted

> git log v2.6.23..v2.6.24 --pretty="format:<%an>%s" | ./git-revert-stats -o
 P#  COMM#  NAME --- Top people doing the revert:
  1     13  Linus Torvalds
  2      7  Andrew Morton
  3      5  Len Brown
  4      2  Jens Axboe
  5      2  Thomas Gleixner
  6      2  David Woodhouse
  *     11 developers with only one revert are omitted

 P#  COMM#  NAME --- Top developers with reverted commits:
  1      2  Ingo Molnar
  2      2  Alexey Starikovskiy
  3      2  Stephen Hemminger
  4      2  Mathieu Desnoyers
  *     25 developers with only one revert are omitted

> git log v2.6.22..v2.6.23 --pretty="format:<%an>%s" | ./git-revert-stats -o
 P#  COMM#  NAME --- Top people doing the revert:
  1     13  Linus Torvalds
  2      5  Andrew Morton
  *     11 developers with only one revert are omitted

 P#  COMM#  NAME --- Top developers with reverted commits:
  1      2  Thomas Gleixner
  2      2  Ryusuke Konishi
  *     19 developers with only one revert are omitted

> git log v2.6.21..v2.6.22 --pretty="format:<%an>%s" | ./git-revert-stats -o
 P#  COMM#  NAME --- Top people doing the revert:
  1      7  Linus Torvalds
  2      3  Paul Mackerras
  3      3  Len Brown
  4      2  Andi Kleen
  5      2  Andrew Morton
  *      5 developers with only one revert are omitted

 P#  COMM#  NAME --- Top developers with reverted commits:
  1      2  Stephen Rothwell
  2      2  Jake Moilanen
  *     10 developers with only one revert are omitted

Find the script at 
http://dev.medozas.de/gitweb.cgi?p=hxtools;a=blob;f=libexec/git-revert-stats;hb=master
(it is not yet in a hxtools tarball).
