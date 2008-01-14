Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbYANLbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbYANLbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 06:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbYANLbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 06:31:03 -0500
Received: from ns2.suse.de ([195.135.220.15]:49172 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486AbYANLbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 06:31:01 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 00/10] x86: Reduce memory and intra-node effects with large count NR_CPUs
Date: Mon, 14 Jan 2008 12:30:56 +0100
User-Agent: KMail/1.9.6
Cc: travis@sgi.com, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20080113183453.973425000@sgi.com> <200801141104.18789.ak@suse.de> <20080114101133.GA23238@elte.hu>
In-Reply-To: <20080114101133.GA23238@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801141230.56403.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> i think this patchset already gives a net win, by moving stuff from 
> NR_CPUS arrays into per_cpu area. (Travis please confirm that this is 
> indeed what the numbers show)

Yes that is what his patchkit does, although I'm not sure he has addressed all NR_CPUS
pigs yet. The basic idea came out of some discussions we had at kernel summit on this 
topic. It's definitely a step in the right direction.

Another problem is that NR_IRQS currently scales with NR_CPUs which is wrong too
(e.g. a hyperthreaded quad core/socket does not need 8 times as many 
external interrupts as a single core/socket). And there are unfortunately a few 
drivers that declare NR_IRQS arrays.

In general there are more scaling problems like this (e.g. it also doesn't make
sense to scale kernel threads for each CPU thread for example).

At some point we might need to separate CONFIG_NR_CPUS into a 
CONFIG_NR_SOCKETS / CONFIG_NR_CPUS to address this, although full dynamic
scaling without configuration is best of course.

All can just be addressed step by step of course.

-Andi
