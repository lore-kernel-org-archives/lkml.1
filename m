Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbZDTMCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbZDTMCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 08:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbZDTMB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 08:01:58 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:37880 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbZDTMB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 08:01:57 -0400
Date: Mon, 20 Apr 2009 14:01:03 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mutex: have non-spinning mutexes on s390 by default
Message-ID: <20090420140103.27d92d7d@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20090417214212.GG10554@vanheusden.com>
References: <20090409174758.74abec87@osiris.boeblingen.de.ibm.com>
	<20090417214212.GG10554@vanheusden.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009 23:42:12 +0200
Folkert van Heusden <folkert@vanheusden.com> wrote:

> > The adaptive spinning mutexes will not always do what one would expect on
> > virtualized architectures like s390. Especially the cpu_relax() loop in
> > mutex_spin_on_owner might hurt if the mutex holding cpu has been scheduled
> > away by the hypervisor.
> > We would end up in a cpu_relax() loop when there is no chance that the
> > state of the mutex changes until the target cpu has been scheduled again by
> > the hypervisor.
> > For that reason we should change the default behaviour to no-spin on s390.
> 
> Hmmm. Wouldn't this be a change that applies to ibm system p as wel?
> E.g. with linux in an lpar.

This applies to every kernel that runs under a hypervisor. However the
difference is that s390 kernels _always_ have a hypervisor, whereas
other architectures may or may not have one.
In case the mutex spinning code ist causing problem it still can be
switched at run time. That way other architectures can come up with a
solution that fits their needs best.
