Return-Path: <linux-kernel-owner+w=401wt.eu-S1762714AbZE0Soc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762714AbZE0Soc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933242AbZE0SoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:44:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37832 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763684AbZE0SoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:44:18 -0400
Date: Wed, 27 May 2009 20:50:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, paul@mad-scientist.net,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [2.6.27.24] Kernel coredump to a pipe is failing
Message-ID: <20090527185056.GW1065@one.firstfloor.org>
References: <1243355634.29250.331.camel@psmith-ubeta.netezza.com> <878wkjobbm.fsf@basil.nowhere.org> <20090527183109.GA30574@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527183109.GA30574@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, I think there is a strong reason to handle signals during
> core dumping. The coredump can take a lot of time/resources, not good
> it looks like unkillable procees to users.

One problem with that is if you send a process a string of signals that cause
a core dump and then kill. In the old case you would just get a full core dump
on the first signal and be done. With your change it would process
the second signal too and stop the dumping and you get none or a partial 
core dump. That might well break existing setups.

> 
> Perhaps it makes sense to do

Probably, my patch is not usable as is anyways because it would
need to save the mask somewhere so that the ELF dumper can 
build the correct mask. Your version would at least avoid that 
problem.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
