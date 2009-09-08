Return-Path: <linux-kernel-owner+w=401wt.eu-S1751344AbZIHPc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbZIHPc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 11:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbZIHPc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 11:32:57 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:39142 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750777AbZIHPc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 11:32:56 -0400
Date: Tue, 8 Sep 2009 11:32:02 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       linux-mm <linux-mm@kvack.org>, Oleg Nesterov <onestero@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] lru_add_drain_all() vs isolation
In-Reply-To: <alpine.DEB.1.10.0909081110450.30203@V090114053VZO-1>
Message-ID: <alpine.DEB.1.10.0909081124240.30203@V090114053VZO-1>
References: <20090908190148.0CC9.A69D9226@jp.fujitsu.com>  <1252405209.7746.38.camel@twins>  <20090908193712.0CCF.A69D9226@jp.fujitsu.com>  <1252411520.7746.68.camel@twins>  <alpine.DEB.1.10.0909081000100.15723@V090114053VZO-1> <1252419602.7746.73.camel@twins>
 <alpine.DEB.1.10.0909081110450.30203@V090114053VZO-1>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usefulness of a scheme like this requires:

1. There are cpus that continually execute user space code
   without system interaction.

2. There are repeated VM activities that require page isolation /
   migration.

The first page isolation activity will then clear the lru caches of the
processes doing number crunching in user space (and therefore the first
isolation will still interrupt). The second and following isolation will
then no longer interrupt the processes.

2. is rare. So the question is if the additional code in the LRU handling
can be justified. If lru handling is not time sensitive then yes.




