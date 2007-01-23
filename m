Return-Path: <linux-kernel-owner+w=401wt.eu-S932664AbXAWCok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbXAWCok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 21:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932669AbXAWCok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 21:44:40 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:48014 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932664AbXAWCoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 21:44:39 -0500
Date: Mon, 22 Jan 2007 18:44:02 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Rik van Riel <riel@redhat.com>
cc: Balbir Singh <balbir@in.ibm.com>, Andrea Arcangeli <andrea@suse.de>,
       Niki Hammler <mailinglists@nobaq.net>, linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: Why active list and inactive list?
In-Reply-To: <45B5703E.5010400@redhat.com>
Message-ID: <Pine.LNX.4.64.0701221837210.30653@schroedinger.engr.sgi.com>
References: <45B55286.5060909@nobaq.net> <20070123003939.GY13798@opteron.random>
 <45B56575.10807@in.ibm.com> <Pine.LNX.4.64.0701221737510.30455@schroedinger.engr.sgi.com>
 <45B569A4.3010006@redhat.com> <Pine.LNX.4.64.0701221801420.30595@schroedinger.engr.sgi.com>
 <45B5703E.5010400@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jan 2007, Rik van Riel wrote:

> The big one is how we are to do some background aging in a
> clock-pro system, so referenced bits don't just pile up when
> the VM has enough memory - otherwise we might not know the
> right pages to evict when a new process starts up and starts
> allocating lots of memory.

There are two bad choices right?

1. Scan for reference bits

   Bad because we may have to scan quite a bit without too much
   result. LRU allows us to defer this until memory is tight.
   Any such scan will pollute the cache and cause a stall of
   the app. You really do not want this for a realtime system.

2. Take faults on reference and update the page state.
   Bad because this means a fault if the reference bit
   has not been set. Could be many faults.

Clock pro really requires 2 right? So lots of additional page faults?
