Return-Path: <linux-kernel-owner+w=401wt.eu-S1767163AbXEBSdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767163AbXEBSdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767169AbXEBSdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:33:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767163AbXEBSdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:33:11 -0400
Date: Wed, 2 May 2007 13:13:56 -0300
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: Andi Kleen <ak@novell.com>
Cc: Mark Lord <lkml@rtr.ca>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove unnecessary irq disabling
Message-ID: <20070502161356.GA8485@redhat.com>
References: <20070501213050.GD6119@redhat.com> <4637D459.2040502@rtr.ca> <20070502044424.GA7049@redhat.com> <200705021158.17759.ak@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705021158.17759.ak@novell.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 11:58:17AM +0200, Andi Kleen wrote:
> 
> > > What does that break, or was it already broken and this fixes it?
> > I think neither. This function is only called at early bootup,
> > (start_secondary() ), and most of its callees have interrupts off anyway.
> > But maybe we do lose something. Andi, do you have a word on this?
> 
> We need to enable them somewhere, but cpu_idle will do it in the end.
> So it should be safe to drop it. I guess keeping them disabled the whole
> time will be a little safer against potential races.
yeah, that's exactly what I've thought. We enable interrupts (to disable
them afterwards) in smp_callin(), to avoid waking up Mr. Watchdog. I
guess it won't be a problem after that, will it?
 
-- 
Glauber de Oliveira Costa
Red Hat Inc.
"Free as in Freedom"
