Return-Path: <linux-kernel-owner+w=401wt.eu-S1759555AbYGJRkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555AbYGJRkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbYGJRkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:40:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753033AbYGJRkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:40:11 -0400
Message-ID: <4876492E.90901@linux-foundation.org>
Date: Thu, 10 Jul 2008 12:38:54 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>	<4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org>	<m1wsjupuiz.fsf@frodo.ebiederm.org> <48753C99.5050408@goop.org>	<m1ej62iq9z.fsf@frodo.ebiederm.org> <487555A8.2050007@zytor.com>	<487556A5.5090907@goop.org> <4876194E.4080205@linux-foundation.org>	<48761C06.3020003@zytor.com> <48762A3B.5050104@linux-foundation.org>	<48762DD2.5090802@zytor.com> <487637A1.4080403@linux-foundation.org> <m1prpl4pmh.fsf@frodo.ebiederm.org>
In-Reply-To: <m1prpl4pmh.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:

> First off right now reserving more than about 64KB is ridiculous.  We rightly
> don't have that many per cpu variables.

We do. The case has been made numerous times that we need at least several megabytes of per cpu memory in case someone creates gazillions of ip tunnels etc etc.


>> instead of looking it up in a table because that will save a memory access on
>> per_cpu().
> 
> ???? Optimizing per_cpu seems to be the wrong path.  If you want to go fast you
> access the data on the cpu you start out on.

Yes most arches provide specialized registers for local per cpu variable access. There are cases though in which you have to access another processors cpu space.

>> Maybe there is another way of arranging things that would allow for this?
> 
> Yes.  Start with a patch that doesn't have freaky failures that can't be understood
> or bisected because the patch is too big.  The only reason we are having a conversation

The patches are reasonably small. The problem that Mike seems to have is early boot debugging.
