Return-Path: <linux-kernel-owner+w=401wt.eu-S1759708AbZKFTrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708AbZKFTrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 14:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759682AbZKFTrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 14:47:18 -0500
Received: from smtp.ultrahosting.com ([74.213.175.253]:35944 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757783AbZKFTrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 14:47:18 -0500
Date: Fri, 6 Nov 2009 14:45:58 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Andi Kleen <andi@firstfloor.org>
cc: npiggin@suse.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
Subject: Re: [RFC MM] mmap_sem scaling: only scan cpus used by an mm
In-Reply-To: <20091106191448.GD819@basil.fritz.box>
Message-ID: <alpine.DEB.1.10.0911061443120.21579@V090114053VZO-1>
References: <alpine.DEB.1.10.0911051417370.24312@V090114053VZO-1> <alpine.DEB.1.10.0911051419320.24312@V090114053VZO-1> <87r5sc7kst.fsf@basil.nowhere.org> <alpine.DEB.1.10.0911051558220.7668@V090114053VZO-1> <20091106073946.GV31511@one.firstfloor.org>
 <alpine.DEB.1.10.0911061352320.22205@V090114053VZO-1> <20091106191448.GD819@basil.fritz.box>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Nov 2009, Andi Kleen wrote:

> On Fri, Nov 06, 2009 at 01:53:35PM -0500, Christoph Lameter wrote:
> > One way to reduce the cost of the writer lock is to track the cpus used
> > and loop over the processors in that bitmap.
>
> Can't you use the same mask as is used for TLB flushing?

They are clearing the cpus that are no longer in use. We could use the
same mask if we would transfer the counters but for that we would need to
make sure that no concurrent user of the counters is out there. Probably
too expensive to do.


