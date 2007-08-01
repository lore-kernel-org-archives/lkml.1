Return-Path: <linux-kernel-owner+w=401wt.eu-S932765AbXHASkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbXHASkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757499AbXHASk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:40:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60674 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761288AbXHASk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:40:27 -0400
Date: Wed, 1 Aug 2007 20:40:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] Simple Performance Counters: x86_64 support
Message-ID: <20070801184026.GC20713@one.firstfloor.org>
References: <11859243121617-git-send-email-clameter@sgi.com> <p73ir7zplty.fsf@bingen.suse.de> <Pine.LNX.4.64.0708011052080.20795@schroedinger.engr.sgi.com> <20070801182611.GB20713@one.firstfloor.org> <Pine.LNX.4.64.0708011127490.22867@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708011127490.22867@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It is certainly interesting to compare alternative ways of handling the 
> instruction streams by various processors or models of processors.

Well you have to do a lot more work then to handle instable TSCs then.

In particular the frequencies can be different between CPUs, they 
change (which you can catch with cpufreq notifiers) and during the
cpufreq change period they're instable (as in you can't tell for
some time which frequency they're currently running at and they
might be running immediate frequencies) 

The current cycles_2_ns() users avoid this problem by not
using the TSC in this case, but that might not be an option
for you (cpufreq is becoming more and more ubiquitous)

Good luck.

-Andi
