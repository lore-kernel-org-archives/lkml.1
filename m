Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbYJHA1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbYJHA1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 20:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYJHA1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 20:27:10 -0400
Received: from ozlabs.org ([203.10.76.45]:57784 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163AbYJHA1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 20:27:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH/RFC 0/4] Add stop_machine_get/put_threads to stop_machine infrastructrue.
Date: Wed, 8 Oct 2008 10:27:04 +1000
User-Agent: KMail/1.9.9
Cc: jens.axboe@oracle.com, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
References: <20081003105632.357231142@de.ibm.com> <200810071239.58732.rusty@rustcorp.com.au> <20081007153854.GA4122@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20081007153854.GA4122@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810081127.05311.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2008 02:38:54 Heiko Carstens wrote:
> On Tue, Oct 07, 2008 at 11:39:58AM +1000, Rusty Russell wrote:
> > That's exactly my idea.  We kmalloc already because NR_CPUS might be too
> > big for the stack.  This version would just kmalloc a struct containing
> > everything we need.
>
> Ok, I did that but the resulting code is astonishingly ugly, so I thought I
> should share it :)

Yeah, the diffstat tells the story.

> Another thing that comes to mind is cpu hotplug: if somebody issued
> stop_machine_prepare() and then a cpu hotplug operation gets started we
> need to create or kill a kstop thread. For that we need the "sm" so we can
> save/find the task_struct pointer of the thread.

Erk, good point.  Suckage.

OK, idea #2.  Let's just always have a kstopmachine thread running on every 
online cpu.  Is there a sane way to reuse the workqueue threads for this?

Thanks,
Rusty.

