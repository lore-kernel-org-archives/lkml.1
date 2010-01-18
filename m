Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142Ab0ARPAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab0ARPAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 10:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632Ab0ARPAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 10:00:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42211 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab0ARPAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 10:00:13 -0500
Subject: Re: [PATCH]  perf_events: improve x86 event scheduling (v5)
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <20100118145346.GF10364@nowhere>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
	 <20100118134324.GB10364@nowhere> <1263822898.4283.558.camel@laptop>
	 <20100118142004.GD10364@nowhere> <1263825421.4283.597.camel@laptop>
	 <20100118145346.GF10364@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 15:59:58 +0100
Message-ID: <1263826798.4283.606.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 15:53 +0100, Frederic Weisbecker wrote:

> Not sure what you both mean by this core VS uncore thing :)
> Is it about hardware counters that apply to single hardware threads
> or shared among them inside a same core?

Yeah intel has two PMUs, one per logical cpu and one per socket/node. We
currently don't support the node one yet.

So the thing with these socket wide things is is that they are not able
to tell where the event originated, so relating that back to a task is
only possible when there's only one task running.

