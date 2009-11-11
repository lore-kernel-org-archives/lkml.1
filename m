Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbZKKN2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbZKKN2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 08:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZKKN2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 08:28:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54284 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbZKKN2g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 08:28:36 -0500
Subject: Re: [PATCH v5 0/4] pseries: Add cede support for cpu-offline
From: Peter Zijlstra <peterz@infradead.org>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Nathan Fontenot <nfont@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20091030052106.25493.42109.stgit@sofia.in.ibm.com>
References: <20091030052106.25493.42109.stgit@sofia.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 11 Nov 2009 14:25:35 +0100
Message-ID: <1257945935.4372.36.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-30 at 10:52 +0530, Gautham R Shenoy wrote:

> Gautham R Shenoy (4):
>       pseries: Serialize cpu hotplug operations during deactivate Vs deallocate
>       pseries: Add code to online/offline CPUs of a DLPAR node.
>       pSeries: Add hooks to put the CPU into an appropriate offline state
>       pSeries: extended_cede_processor() helper function.
> 
> 
>  Documentation/cpu-hotplug.txt                   |    6 +
>  arch/powerpc/include/asm/lppaca.h               |    9 +
>  arch/powerpc/platforms/pseries/dlpar.c          |  129 ++++++++++++++++
>  arch/powerpc/platforms/pseries/hotplug-cpu.c    |  182 ++++++++++++++++++++++-
>  arch/powerpc/platforms/pseries/offline_states.h |   18 ++
>  arch/powerpc/platforms/pseries/plpar_wrappers.h |   22 +++
>  arch/powerpc/platforms/pseries/smp.c            |   19 ++
>  arch/powerpc/xmon/xmon.c                        |    3 
>  drivers/base/cpu.c                              |    2 
>  include/linux/cpu.h                             |   13 ++
>  10 files changed, 387 insertions(+), 16 deletions(-)
>  create mode 100644 arch/powerpc/platforms/pseries/offline_states.h

Not quite sure how you solved the DLPAR communication but since pretty
much everything is under arch/powerpc/ I really don't have much to say.
