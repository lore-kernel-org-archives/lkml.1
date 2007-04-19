Return-Path: <linux-kernel-owner+w=401wt.eu-S1161505AbXDSRNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161505AbXDSRNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 13:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161506AbXDSRNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 13:13:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161505AbXDSRNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 13:13:19 -0400
Message-ID: <4627A1BF.8080406@redhat.com>
Date: Thu, 19 Apr 2007 13:07:11 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@o2.pl>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
References: <20070419065404.GB1782@ff.dom.local>
In-Reply-To: <20070419065404.GB1782@ff.dom.local>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:
> Hi,
> 
> IMHO cancel_rearming_delayed_work is dangerous place:
> 
> - it assumes a work function always rearms (with no exception),
> which probably isn't explained enough now (but anyway should
> be checked in such loops);
> 
> - probably possible (theoretical) scenario: a few work
> functions rearm themselves with very short, equal times;
> before flush_workqueue ends, their timers are already
> fired, so cancel_delayed_work has nothing to do.
> 
> Maybe this patch could check, if I'm not dreaming...
> 
> PS: of course the counter value below is a question of taste

Okay, an easy test for it: insmod netconsole ; rmmod netconsole

In 2.6.20.x it loops forever and cancel_rearming_delayed_work()
is part of the trace...

