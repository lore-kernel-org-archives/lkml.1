Return-Path: <linux-kernel-owner+w=401wt.eu-S1751405AbZLHIxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbZLHIxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 03:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbZLHIxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 03:53:54 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51025 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbZLHIxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 03:53:52 -0500
Subject: Re: [PATCH 7/7] sched: implement try_to_wake_up_local()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
In-Reply-To: <4B1CD89F.9000802@kernel.org>
References: <1259726212-30259-1-git-send-email-tj@kernel.org>
	 <1259726212-30259-8-git-send-email-tj@kernel.org>
	 <1259923487.3977.1940.camel@laptop>  <4B1C75F3.9080808@kernel.org>
	 <1260175804.8223.1217.camel@laptop> <1260176199.8223.1237.camel@laptop>
	 <4B1CD89F.9000802@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 09:53:14 +0100
Message-ID: <1260262394.3935.981.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-07 at 19:27 +0900, Tejun Heo wrote:
> 
> > What happens when you run out of memory and the workqueue progress is
> > needed to get free memory?
> 
> That's when the "rescuer" workers kick in.  All workqueues which might
> be used during allocation paths are required to have one.  When
> manager fails to fork a new worker, it summons the rescuers.  They
> migrate to the distressed cpu and processes only the works from their
> specific workqueues thus guaranteeing forward progress.

What happens if the rescue worker is tied up on another cpu in a
deadlock avoidance game, which requires progress on this cpu in order to
resolve it?

