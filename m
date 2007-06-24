Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbXFXVri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbXFXVri (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 17:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbXFXVr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 17:47:29 -0400
Received: from mga07.intel.com ([143.182.124.22]:11967 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751352AbXFXVr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 17:47:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,456,1175497200"; 
   d="scan'208";a="242720462"
Message-ID: <467EE609.9050908@linux.intel.com>
Date: Sun, 24 Jun 2007 14:45:45 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: IRQ Balance Question for Single but Multi-Core Processors
References: <Pine.LNX.4.64.0706241627470.5819@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0706241627470.5819@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> Question regarding the IRQ balance daemon and the 2.6.x kernel.
> 
> For a single-processor but dual or quad core CPU, should one be running 
> the IRQ balancing daemon, will it result in increased performance?

it's a tradeoff.

for cores/threads that share cache, there's no point to run a daemon 
all the time, they share so many resources that things don't really 
matter.....

irqbalance will, as a result, set up a one time static mapping and 
then exit on such systems; this will give a "reasonable" spread of 
interrupts, but won't cost you any cpu after that.

On "real" smp systems, the performance and power tradeoffs are 
different and there irqbalance will keep an eye on things over time...
