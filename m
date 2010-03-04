Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab0CDI5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 03:57:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35616 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab0CDI5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 03:57:33 -0500
Subject: Re: [RFC][PATCH 10/11] perf, x86: use LBR for PEBS IP+1 fixup
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, paulus@samba.org, robert.richter@amd.com,
       fweisbec@gmail.com
In-Reply-To: <bd4cb8901003031350v274ca388v48ad61d7baa87d90@mail.gmail.com>
References: <20100303163936.906011640@chello.nl>
	 <20100303164306.602529559@chello.nl> <4B8EA4D9.6000505@redhat.com>
	 <1267645029.25158.106.camel@laptop> <4B8ED097.6090006@redhat.com>
	 <bd4cb8901003031350v274ca388v48ad61d7baa87d90@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Mar 2010 09:57:26 +0100
Message-ID: <1267693046.25158.143.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 22:50 +0100, Stephane Eranian wrote:

> I think systematically and transparently using LBR to correct PEBS off-by-one
> problem is not such a good idea. You've basically highjacked LBR and user
> cannot use it in a different way.

Well, they could, it just makes scheduling the stuff more interesting.

> There are PEBS+LBR measurements where you care about extracting the LBR data.
> There are PEBS measurements where you don't care about getting the correct IP.
> I don't necessarily want to pay the price, especially when this could
> be done offline in the tool.

There are some people who argue that fixing up that +1 insn issue is
critical, sadly they don't appear to want to argue their case in public.
What we can do is make it optional I guess.

