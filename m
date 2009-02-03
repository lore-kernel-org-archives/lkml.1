Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbZBCQlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbZBCQlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:41:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZBCQk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:40:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41455 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbZBCQk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:40:57 -0500
Subject: Re: [PATCH v2] ftrace: On PowerPC we don't need frame pointers for
	CALLER_ADDRs
From: Steven Rostedt <srostedt@redhat.com>
To: avorontsov@ru.mvista.com
Cc: Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090203161955.GA776@oksana.dev.rtsoft.ru>
References: <20090131190650.GA4284@oksana.dev.rtsoft.ru>
	 <1233534919.18767.69.camel@pasglop>
	 <1233583455.16878.3.camel@localhost.localdomain>
	 <20090203145649.GA19955@oksana.dev.rtsoft.ru>
	 <20090203160645.GA9020@elte.hu> <20090203161955.GA776@oksana.dev.rtsoft.ru>
Content-Type: text/plain
Organization: Red Hat
Date: Tue, 03 Feb 2009 11:32:18 -0500
Message-Id: <1233678738.16878.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-02-03 at 19:19 +0300, Anton Vorontsov wrote:
> On Tue, Feb 03, 2009 at 05:06:45PM +0100, Ingo Molnar wrote:

> [1] Btw, why exactly do we need the -fno-omit-frame-pointer for
> "FUNCTION_TRCER" tracer? Why just -pg isn't sufficient?..
> 

The problem is this that is in the toplevel Makefile:


ifdef CONFIG_FRAME_POINTER
KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
else
KBUILD_CFLAGS	+= -fomit-frame-pointer
endif


-pg is incompatible with -fomit-frame-pointer

-- Steve


