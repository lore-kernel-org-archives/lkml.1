Return-Path: <linux-kernel-owner+w=401wt.eu-S1760755AbZKZQTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760755AbZKZQTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760677AbZKZQTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:19:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48459 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760283AbZKZQTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:19:49 -0500
Subject: Re: Missing recalculation of scheduler tunables in case of cpu hot
 add/remove
From: Peter Zijlstra <peterz@infradead.org>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Holger.Wolf@de.ibm.com, epasch@de.ibm.com
In-Reply-To: <4B0EA88E.3030205@linux.vnet.ibm.com>
References: <4B0EA88E.3030205@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Nov 2009 17:19:42 +0100
Message-ID: <1259252382.31676.207.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 17:10 +0100, Christian Ehrhardt wrote:

> What I consider more important at the moment is that there is no hook to 
> recalculate these values in case cpu hot add/remove takes place.
> As an example someone could boot a machine with one online cpu and get 
> the low non scaled defaults, later on driven by load the system 
> activates more and more processors. Therefore the system could end up 
> having  a large amount of cpus with non recalculated scheduler tunables.

This is virt junk that's playing dumb games with hotplug isn't it?

Normal machines simply don't change their numbers of cpus, if they
hotplug its usually for things like suspend or actual replacement of a
faulty piece of kit, in which case there's little point in adjusting
things.

Aside from that, we probably should put an upper limit in place, as I
guess large cpu count machines get silly large values.

