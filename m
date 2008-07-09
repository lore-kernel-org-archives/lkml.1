Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbYGIWdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbYGIWdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 18:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYGIWdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 18:33:11 -0400
Received: from gw.goop.org ([64.81.55.164]:35341 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbYGIWdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 18:33:10 -0400
Message-ID: <48753C99.5050408@goop.org>
Date: Wed, 09 Jul 2008 15:32:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Christoph Lameter <cl@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>	<4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org> <m1wsjupuiz.fsf@frodo.ebiederm.org>
In-Reply-To: <m1wsjupuiz.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Christoph Lameter <cl@linux-foundation.org> writes:
>
>   
>> Note also that the 32 bit offset size limits the offset that can be added to the
>> segment register. You either need to place the per cpu area either in the last
>> 2G of the address space or in the first 2G. The zero based approach removes that
>> limitation.
>>     
>
> Good point.  Which means that fundamentally we need to come up with a special
> linker segment or some other way to guarantee that the offsets we use for per
> cpu variables is within 2G of the segment register.
>
> Which means that my idea of using the technique we use on x86_32 will not work.

No, the compiler memory model we use guarantees that everything will be 
within 2G of each other.  The linker will spew loudly if that's not the 
case.

    J

