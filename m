Return-Path: <linux-kernel-owner+w=401wt.eu-S1760860AbYGJRxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860AbYGJRxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757827AbYGJRxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:53:14 -0400
Received: from gw.goop.org ([64.81.55.164]:58053 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181AbYGJRxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:53:13 -0400
Message-ID: <48764C7C.5010309@goop.org>
Date: Thu, 10 Jul 2008 10:53:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>	<4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org>	<m1wsjupuiz.fsf@frodo.ebiederm.org> <48753C99.5050408@goop.org> <m1ej62iq9z.fsf@frodo.ebiederm.org> <487555A8.2050007@zytor.com> <487556A5.5090907@goop.org> <4876194E.4080205@linux-foundation.org> <48761C06.3020003@zytor.com> <48762A3B.5050104@linux-foundation.org> <48762DD2.5090802@zytor.com> <487637A1.4080403@linux-foundation.org> <487639ED.7000502@zytor.com> <48763CA6.9030802@linux-foundation.org> <487647EF.5010609@goop.org> <48764A01.1070402@linux-foundation.org>
In-Reply-To: <48764A01.1070402@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
>> The nice thing about the non-zero-based scheme i386 uses is that setting
>> gs-base to zero means that percpu variables accesses get directly to the
>> prototype percpu data area, which simplifies boot time setup (which is
>> doubly awkward on 32-bit because you need to generate a GDT entry rather
>> than just load an MSR as you do in 64-bit).
>>     
>
> Great but it causes trouble in other ways as discussed.

What other trouble?  It works fine.

>  Its best to consistently access
> per cpu variables using the segment registers.
>   


It is, but initially the segment base is 0, so just using a percpu 
variable does something sensible from the start with no special setup.

    J
