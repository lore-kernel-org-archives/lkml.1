Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbYGKA6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbYGKA6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 20:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbYGKA6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:58:45 -0400
Received: from relay2.sgi.com ([192.48.171.30]:42467 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752186AbYGKA6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:58:44 -0400
Message-ID: <4876B043.7040304@sgi.com>
Date: Thu, 10 Jul 2008 17:58:43 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Christoph Lameter <cl@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>	<4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org>	<m1wsjupuiz.fsf@frodo.ebiederm.org> <48753C99.5050408@goop.org> <m1ej62iq9z.fsf@frodo.ebiederm.org> <487555A8.2050007@zytor.com> <487556A5.5090907@goop.org> <4876194E.4080205@linux-foundation.org> <48761C06.3020003@zytor.com> <48762A3B.5050104@linux-foundation.org> <48762DD2.5090802@zytor.com> <487637A1.4080403@linux-foundation.org> <487639ED.7000502@zytor.com> <48763CA6.9030802@linux-foundation.org> <487647EF.5010609@goop.org> <48764A01.1070402@linux-foundation.org> <48764C7C.5010309@goop.org> <48767692.4080504@linux-foundation.org> <487677F0.4000404@goop.org> <4876799B.7010204@linux-foundation.org> <48767F4F.1010209@zytor.com> <4876A56C.3050707@sgi.com> <4876A5CA.7020109@zytor.com>
In-Reply-To: <4876A5CA.7020109@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Mike Travis wrote:
>>
>> Hmm, that might be the way to go.... At boot up time determine the
>> size of the system in terms of cpu count and memory available and
>> attempt to do the right thing, with startup options to override the
>> internal choices... ?
>>
>> (Surely a system that has a "gazillion ip tunnels" could modify it's
>> kernel start options... ;-)
>>
>> Unfortunately, we can't use a MODULE to support different options unless
>> we change how the kernel starts up (would need to mount the root fs
>> before starting secondary cpus.)
>>
> 
> Using a module doesn't make any sense anyway.  This is more what the
> kernel command line is for.
> 
>     -hpa


I was thinking that supporting virtual percpu addresses would take a fair
amount of code that, if living in a MODULE, wouldn't impact small systems.
But it seems to be not worth the effort... ;-)

Thanks,
Mike
