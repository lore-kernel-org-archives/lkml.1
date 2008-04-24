Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbYDXVoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbYDXVoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 17:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbYDXVoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 17:44:08 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53136 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbYDXVoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 17:44:07 -0400
Date: Thu, 24 Apr 2008 23:44:04 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Soeren Sandmann <sandmann@daimi.au.dk>
cc: linux-kernel@vger.kernel.org
Subject: Re: stat benchmark
In-Reply-To: <ye8wsmnezq9.fsf@camel05.daimi.au.dk>
Message-ID: <alpine.LNX.1.10.0804242329060.11644@fbirervta.pbzchgretzou.qr>
References: <ye8wsmnezq9.fsf@camel05.daimi.au.dk>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-04-24 22:59, Soeren Sandmann wrote:
>
>    http://www.daimi.au.dk/~sandmann/stat-benchmark.c
>
>there is a simple program that will measure the time it takes to stat
>every file in the current directory with a cold cache.
>
>This is essentially what applications do in a number of common cases
>such as "ls -l", nautilus opening a directory, or an "open file"
>dialog being showed.

Mh somewhat. Some programs/libraries unnecessarily stat No, nautilus is excluded

>
>Unfortunately, performance of that operation kinda sucks. On my system
>(ext3), it produces:
>
>    c-24-61-65-93:~% sudo ./a.out 
>    Time to readdir(): 0.307671 s
>    Time to stat 2349 files: 8.203693 s
>
>8 seconds is about 80 times slower than what a user perceives as
>"instantly" and slow enough that we really should display a progress
>bar if it can't be fixed.
>
>So I am looking for ways to improve this.
>
>Under the theory that disk seeks are killing us, one idea is to add a
>'multistat' system call that would allow statting of many files at a
>time, which would give the disk scheduler more to work with. 
>
>Possibly the same thing would need to be done for the getxattr
>information.
>
>Does this sound like a reasonable idea?
>

XFS for example already has bulkstat, but it is not really
exported to userspace :-/
