Return-Path: <linux-kernel-owner+w=401wt.eu-S1753417Ab0ADOBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab0ADOBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 09:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268Ab0ADOBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 09:01:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42044 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab0ADOBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 09:01:39 -0500
Subject: Re: [PATCH]tickless: Fix tick nohz timer irq0 fail to increaase
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Youquan,Song" <youquan.song@linux.intel.com>, hpa@zytor.com,
       tglx@linutronix.de, akpm@linux-foundation.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       kent.liu@intel.com, chaohong.guo@intel.com, youquan.song@intel.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "jens.axboe" <jens.axboe@oracle.com>
In-Reply-To: <20100104043650.6acfb056@infradead.org>
References: <20091214130233.GA3898@youquan-linux.bj.intel.com>
	 <20100104104905.GA30574@youquan-linux.bj.intel.com>
	 <20100104043650.6acfb056@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jan 2010 15:00:49 +0100
Message-ID: <1262613649.6408.164.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 04:36 -0800, Arjan van de Ven wrote:
> > cause is that it is default to enable high resolution timer which
> > will force to oneshot broadcast mode.
> 
> using local apic in one shot mode is not a problem, I'd in fact call it
> a feature... 

lapic yes, broadcast not so much.

He mentioned he was using Nehelem-EX which is known broken in that it
stops the lapic in deeper C states and thus reverts to HPET broadcast
since there's not enough HPET timers to go around.

Something like processor.max_cstate=2 should fix that IIRC.

Jens ran into this on his shiny new box.

Disabling nohz is funny indeed, one wonders why he does that.

