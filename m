Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbYGJXhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbYGJXhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 19:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbYGJXhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 19:37:06 -0400
Received: from relay1.sgi.com ([192.48.171.29]:55559 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753501AbYGJXhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 19:37:05 -0400
Message-ID: <48769D1E.3030003@sgi.com>
Date: Thu, 10 Jul 2008 16:37:02 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>	<4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org>	<m1wsjupuiz.fsf@frodo.ebiederm.org> <48753C99.5050408@goop.org>	<m1ej62iq9z.fsf@frodo.ebiederm.org> <487555A8.2050007@zytor.com>	<487556A5.5090907@goop.org> <4876194E.4080205@linux-foundation.org>	<48761C06.3020003@zytor.com> <48762A3B.5050104@linux-foundation.org>	<48762DD2.5090802@zytor.com> <487637A1.4080403@linux-foundation.org>	<m1prpl4pmh.fsf@frodo.ebiederm.org> <48764C21.4020601@zytor.com> <m1fxqhzhcu.fsf@frodo.ebiederm.org> <4876608B.10408@sgi.com> <487663C4.6040309@zytor.com>
In-Reply-To: <487663C4.6040309@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Mike Travis wrote:
>>
>> The biggest growth came from moving all the xxx[NR_CPUS] arrays into
>> the per cpu area.  So you free up a huge amount of unused memory when
>> the NR_CPUS count starts getting into the ozone layer.  4k now, 16k
>> real soon now, ??? future?
>>
> 
> Even (or perhaps especially) so, allocating the percpu area in 2 MB
> increments is a total nonstarter.  It hurts the small, common
> configurations way too much.  For SGI, it's probably fine.
> 
>     -hpa

Yes, "right-sizing" the kernel for systems from 512M laptops to 4k cpu
systems with memory totally maxed out, using only a binary distribution
has proven tricky (at best... ;-)

One alternative was to only allocate a chunk similar in size to
PERCPU_ENOUGH_ROOM and allow for startup options to create a bigger
space if needed.  Though the realloc idea has some merit if we can
validate the non-use of pointers to specific cpu's percpu vars.
(CPU_ALLOC contains a function to dereference a percpu offset.)

The discussion started at:

	http://marc.info/?l=linux-kernel&m=121212026716085&w=4

Thanks,
Mike
