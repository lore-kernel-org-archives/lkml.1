Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbZDTMEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbZDTMEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 08:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbZDTMEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 08:04:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43057
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754977AbZDTMEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 08:04:11 -0400
Date: Mon, 20 Apr 2009 05:04:03 -0700 (PDT)
Message-Id: <20090420.050403.56531925.davem@davemloft.net>
To: heiko.carstens@de.ibm.com
Cc: folkert@vanheusden.com, mingo@elte.hu, peterz@infradead.org,
       schwidefsky@de.ibm.com, borntraeger@de.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mutex: have non-spinning mutexes on s390 by default
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090420140103.27d92d7d@osiris.boeblingen.de.ibm.com>
References: <20090409174758.74abec87@osiris.boeblingen.de.ibm.com>
	<20090417214212.GG10554@vanheusden.com>
	<20090420140103.27d92d7d@osiris.boeblingen.de.ibm.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Mon, 20 Apr 2009 14:01:03 +0200

> On Fri, 17 Apr 2009 23:42:12 +0200
> Folkert van Heusden <folkert@vanheusden.com> wrote:
> 
>> > The adaptive spinning mutexes will not always do what one would expect on
>> > virtualized architectures like s390. Especially the cpu_relax() loop in
>> > mutex_spin_on_owner might hurt if the mutex holding cpu has been scheduled
>> > away by the hypervisor.
>> > We would end up in a cpu_relax() loop when there is no chance that the
>> > state of the mutex changes until the target cpu has been scheduled again by
>> > the hypervisor.
>> > For that reason we should change the default behaviour to no-spin on s390.
>> 
>> Hmmm. Wouldn't this be a change that applies to ibm system p as wel?
>> E.g. with linux in an lpar.
> 
> This applies to every kernel that runs under a hypervisor.

I wouldn't say "every" because this change is definitely not
appropriate on sparc64 hypervisor based systems.
