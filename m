Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbXLBTnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbXLBTnh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 14:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbXLBTn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 14:43:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50375 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbXLBTn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 14:43:27 -0500
Date: Sun, 2 Dec 2007 11:41:52 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071202114152.3bf4332d@laptopd505.fenrus.org>
In-Reply-To: <20071202185945.GA25990@elte.hu>
References: <20071201092037.GA32544@elte.hu>
	<p737ijwylet.fsf@bingen.suse.de>
	<20071202185945.GA25990@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Dec 2007 19:59:45 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Ingo Molnar <mingo@elte.hu> writes:
> > 
> > > this patch extends the soft-lockup detector to automatically
> > > detect hung TASK_UNINTERRUPTIBLE tasks. Such hung tasks are
> > > printed the following way:
> > 
> > That will likely trigger anytime a hard nfs/cifs mount loses its 
> > server for 120s. To make this work you would need a new 
> > TASK_UNINTERRUPTIBLE_EXTERNAL_EVENT or similar and mark all the
> > places which depend on those.
> 
> TASK_KILLABLE should be the right solution i think.

.. and it's even a tool to show where we missed making something
TASK_KILLABLE... anything that triggers from NFS and the like really
ought to be TASK_KILLABLE after all. This patch will point any
omissions out quite nicely without having to do any kind of destructive
testing.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
