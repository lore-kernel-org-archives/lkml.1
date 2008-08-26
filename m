Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbYHZKre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbYHZKre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 06:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbYHZKrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 06:47:24 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:9694 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbYHZKrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 06:47:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QLpiljfPzVUd0MOeLLEeZoaP1SsiqXnAeLmUc8YNrp4u/0aLzydn3KVjVWzm15apQE
         8dh6XqgAp1XowG2AXATaqlHzj41+hrUCM+0edgXZ4DxKQzpVetW1MTLPdxju296A/W9D
         88IevT8UVj+F+oCjyXeZEGYCHvpHHUiVIOPUY=
Date: Tue, 26 Aug 2008 10:47:17 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Denys Fedoryshchenko <denys@visp.net.lb>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Message-ID: <20080826104717.GB2609@ff.dom.local>
References: <20080826095126.GA2609@ff.dom.local> <200808261329.53741.denys@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808261329.53741.denys@visp.net.lb>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 01:29:53PM +0300, Denys Fedoryshchenko wrote:
> On Tuesday 26 August 2008, Jarek Poplawski wrote:
> >
> > This function is really used in many places, and these profiles are
> > not enough at least to me, but it seems you could have a lot of
> > softirqs (and probably hrtimers) scheduling, so maybe you should try
> > if e.g. disabling hrtimers or changing kernel HZ makes any difference.
> >
> > Jarek P.
> One user is shapers, it is ok for me.

The question is if you really need so exact shaping at a cost of
higher system load.

> I am not sure, but maybe another user is softlockup debug option... and if 
> there is a lot of task switches maybe it will cause excessive load of timers 
> slow?

Maybe. Anyway, you could try if lower HZ (with longer jiffies) can help
with processing more skbs without rescheduling.

Jarek P.
