Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbYDXA5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbYDXA5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 20:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYDXA5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 20:57:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:56653 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbYDXA5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 20:57:15 -0400
Subject: Re: x86: 4kstacks default
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Chinner <dgc@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080423233652.GT103491721@sgi.com>
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	 <20080418142934.38ce6bf4.akpm@linux-foundation.org>
	 <20080419142329.GA5339@elte.hu> <1208928421.9060.22.camel@pasglop>
	 <20080423233652.GT103491721@sgi.com>
Content-Type: text/plain
Date: Thu, 24 Apr 2008 10:56:40 +1000
Message-Id: <1208998600.9060.86.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-04-24 at 09:36 +1000, David Chinner wrote:
> > Do we routinely test nasty scenarii such as a GFP_KERNEL allocation
> deep
> > in a call stack trying to swap something out to NFS ?
> 
> I doubt it, because this is the place that a local XFS filesystem
> typically blows a 4k stack (direct memory reclaim triggering
> ->writepage). Boot testing does nothing to exercise the potential
> paths for stack overflows....

Yup, note even counting when the said NFS is on top of some fancy
network stack with a driver on top of USB .... I mean, we do have
potential for worst case scenario that I think -will- blow a 4k stack.

Ben.


