Return-Path: <linux-kernel-owner+w=401wt.eu-S1765005AbYDONCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765005AbYDONCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 09:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759817AbYDONCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 09:02:42 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:6033 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757126AbYDONCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 09:02:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ZDCuhSCETxEb5DaUVZwuBx6D+kVdn+27BTqlc392hHyc+4/TFsq1slj1Jh+Xg6wAOC3/fXsWLP2GX5xSzZqM8iOrZjbvrnjf20YTaEVBbpoRt9zoE5Z5IMLNGg/HhyLAL6NE83Xdhy9k1uzGoNKbkpofSDe2HQDlGD6Fznsz+Xc=
Date: Tue, 15 Apr 2008 09:02:35 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] wm97xx-core: Only schedule interrupt handler if
	not already scheduled
Message-ID: <20080415085946.ZZRA012@mailhub.coreip.homeip.net>
References: <20080414173841.GA2213@rakim.wolfsonmicro.main> <1208194775-4293-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20080414140832.ZZRA012@mailhub.coreip.homeip.net> <20080415084819.GA24498@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415084819.GA24498@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 09:48:19AM +0100, Mark Brown wrote:
> On Mon, Apr 14, 2008 at 02:10:02PM -0400, Dmitry Torokhov wrote:
> > On Mon, Apr 14, 2008 at 06:39:33PM +0100, Mark Brown wrote:
> 
> > > +	if (!work_pending(&wm->pen_event_work)) {
> > > +		wm->mach_ops->irq_enable(wm, 0);
> > > +		queue_work(wm->ts_workq, &wm->pen_event_work);
> > > +	}
> 
> > Given the fact that work will not be queued if it is pending anyway
> > why is this change needed?
> 
> As well as not queuing the work it ensures that the calls to
> irq_enable() are balanced which helps with implementing that operation.

Hmm... another question then - what would fire up wm97xx_pen_interrupt()
again, before wm97xx_pen_irq_worker had a chance to run, if the very
first thing we do after getting interrupt is irq_enable(wm, 0)?

-- 
Dmitry
