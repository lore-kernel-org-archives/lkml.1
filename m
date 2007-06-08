Return-Path: <linux-kernel-owner+w=401wt.eu-S1031699AbXFHToU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031699AbXFHToU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756900AbXFHToM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:44:12 -0400
Received: from mail.suse.de ([195.135.220.2]:56215 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbXFHToL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:44:11 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [patch] i386/x86_64: smp_call_function locking inconsistency
Date: Fri, 8 Jun 2007 21:43:51 +0200
User-Agent: KMail/1.9.6
Cc: "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Jan Glauber" <jan.glauber@de.ibm.com>,
       "David Miller" <davem@davemloft.net>, akpm@osdl.org, mingo@elte.hu,
       schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@redhat.com>
References: <20070208203210.GB9798@osiris.ibm.com> <20070607162743.GA9433@osiris.ibm.com> <a781481a0706070954l636d752am82ef7ca9703788aa@mail.gmail.com>
In-Reply-To: <a781481a0706070954l636d752am82ef7ca9703788aa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706082143.52191.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Indeed -- this was doubly problematic because the un-safeness
> was because of smp_processor_id() as well as the (eventual)
> access of cpu_online_map (via smp_call_function() ->
> num_online_cpus()) ... thanks for letting me know about this.

CPU hotplug is changed to use the freezer anyways. It is known
that the current handling of these maps in preempt has various holes and this
little case here won't make it overall much worse.

-Andi
