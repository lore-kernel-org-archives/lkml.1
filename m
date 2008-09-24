Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbYIXKUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbYIXKUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 06:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYIXKUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 06:20:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:38417 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbYIXKT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 06:19:59 -0400
Subject: Re: [PATCH HACK] powerpc: quick hack to get a functional eHEA with
	hardirq preemption
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Milton Miller <miltonm@bga.com>
Cc: Sebastien Dugue <sebastien.dugue@bull.net>,
       Jan-Bernd Themann <ossthema@de.ibm.com>,
       Christoph Raisch <RAISCH@de.ibm.com>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <200809240958.m8O9wM7k010996@sullivan.realtime.net>
References: <200809231743.23828.ossthema@de.ibm.com>
	 , <20080915100406.342e027a@bull.net>
	 <200809240958.m8O9wM7k010996@sullivan.realtime.net>
Content-Type: text/plain
Date: Wed, 24 Sep 2008 20:17:47 +1000
Message-Id: <1222251467.8277.73.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-24 at 04:58 -0500, Milton Miller wrote:
> The per-interrupt mask and unmask calls have to go through RTAS, a
> single-threaded global context, which in addition to increasing
> path length will really limit scalability.  The interrupt controller
> poll and reject facilities are accessed through hypervisor calls
> which are comparable to a fast syscall, and parallel to all cpus.

Note also that the XICS code thus assumes, iirc, as does the cell IIC
code, that eoi is called on the -same- cpu that fetched the interrupt
initially. That assumption can be broken with IRQ threads no ?

Ben.


