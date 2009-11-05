Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbZKEU6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbZKEU6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 15:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758371AbZKEU6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 15:58:50 -0500
Received: from smtp4.ultrahosting.com ([74.213.175.253]:51652 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758335AbZKEU6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 15:58:49 -0500
Date: Thu, 5 Nov 2009 15:57:23 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Andi Kleen <andi@firstfloor.org>
cc: npiggin@suse.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
Subject: Re: [RFC MM] Accessors for mm locking
In-Reply-To: <87vdho7kzn.fsf@basil.nowhere.org>
Message-ID: <alpine.DEB.1.10.0911051555320.7668@V090114053VZO-1>
References: <alpine.DEB.1.10.0911051417370.24312@V090114053VZO-1> <87vdho7kzn.fsf@basil.nowhere.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009, Andi Kleen wrote:

> My assumption was that a suitable scalable lock (or rather multi locks)
> would need to know about the virtual address, or at least the VMA.
> As in doing range locking for different address space areas.

Not sure why the address would matter. The main problem right now is that
there are cachelines in mm_struct that are bouncing for concurrent page faults
etc. Ranges wont help if you need to serialize access to mm_struct.

> So this simple abstraction doesn't seem to be enough to really experiment?

Look at the next patch which gives a rough implementation of using per cpu
counters for read locking instead of the rw semaphore.
