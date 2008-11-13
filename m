Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbYKMRDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbYKMRDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbYKMRDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:03:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41813 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbYKMRDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:03:03 -0500
Date: Thu, 13 Nov 2008 18:12:20 +0100
From: Andi Kleen <andi@firstfloor.org>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/function-return-tracer: Make the function return tracer lockless
Message-ID: <20081113171220.GX3810@one.firstfloor.org>
References: <491B4F0A.3080901@gmail.com> <87od0jd6ds.fsf@basil.nowhere.org> <c62985530811130901t7ddf84beof39a964582fb94a0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c62985530811130901t7ddf84beof39a964582fb94a0@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > local register i
> > i = index;
> > write to index'ed array using i
> >                            <--------- interrupt here would overwrite data
> > ...
> > index = i + 1;
> 
> 
> Yes in the common case that would be a danger. But here, if an
> interrupt is raised, it will increment
> the counter and then decrement it at return time without dropping the
> cpu. So after the interrupt, the
> value will remain the same...

The buffer contents will not be necessarily
the same. See the scenario above. The interrupt would use the 
same i as the current function and would overwrite the
partially written entry.

-Andi
