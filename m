Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbZCLK1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbZCLK1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756012AbZCLK0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:26:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36403 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbZCLK0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:26:09 -0400
Subject: Re: [PATCH 01/10] Documentation
From: Peter Zijlstra <peterz@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@intellilink.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       arozansk@redhat.com, jmoyer@redhat.com, oz-kernel@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, menage@google.com
In-Reply-To: <1236823015-4183-2-git-send-email-vgoyal@redhat.com>
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com>
	 <1236823015-4183-2-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 11:24:50 +0100
Message-Id: <1236853490.5090.140.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 21:56 -0400, Vivek Goyal wrote:
> +Going back to old behavior
> +==========================
> +In new scheme of things essentially we are creating hierarchical fair
> +queuing logic in elevator layer and changing IO schedulers to make use of
> +that logic so that end IO schedulers start supporting hierarchical scheduling.
> +
> +Elevator layer continues to support the old interfaces. So even if fair queuing
> +is enabled at elevator layer, one can have both new hierarchical scheduler as
> +well as old non-hierarchical scheduler operating.
> +
> +Also noop, deadline and AS have option of enabling hierarchical scheduling.
> +If it is selected, fair queuing is done in hierarchical manner. If hierarchical
> +scheduling is disabled, noop, deadline and AS should retain their existing
> +behavior.
> +
> +CFQ is the only exception where one can not disable fair queuing as it is
> +needed for providing fairness among various threads even in non-hierarchical
> +mode.
> +
> +Various user visible config options
> +===================================
> +CONFIG_IOSCHED_NOOP_HIER
> +       - Enables hierchical fair queuing in noop. Not selecting this option
> +         leads to old behavior of noop.
> +
> +CONFIG_IOSCHED_DEADLINE_HIER
> +       - Enables hierchical fair queuing in deadline. Not selecting this
> +         option leads to old behavior of deadline.
> +
> +CONFIG_IOSCHED_AS_HIER
> +       - Enables hierchical fair queuing in AS. Not selecting this option
> +         leads to old behavior of AS.
> +
> +CONFIG_IOSCHED_CFQ_HIER
> +       - Enables hierarchical fair queuing in CFQ. Not selecting this option
> +         still does fair queuing among various queus but it is flat and not
> +         hierarchical.

One worry I have is that these are compile time switches. Is there any
way you can get the old AS/DEADLINE back when these are enabled but
you're not actively using cgroups?

