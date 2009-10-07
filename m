Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbZJGVa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbZJGVa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbZJGVa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:30:57 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:48138 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbZJGVa4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:30:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=ShwCKOrRAAe2hSQbEWK7hbLKDbSSdKm2ck8C0sDR2Lw+A1JGjguR4UXhKdSyGsJ8UU
         vop+RHTYOx0vgqjFkCkNEtzNEmFjOgoppqFo4ts7YUupCf6loQRuNFURtz245Vf41sWo
         BsvHuxIVNCWSaXyKIsWXoUA+RFyq5myzE/sso=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20091007.134626.238756485.davem@davemloft.net>
References: <1254911461.26976.239.camel@twins>
	 <19148.30773.350036.411105@cargo.ozlabs.ibm.com>
	 <7c86c4470910070531s8ff0d54xb29c22dd982aa387@mail.gmail.com>
	 <20091007.134626.238756485.davem@davemloft.net>
Date: Wed, 7 Oct 2009 23:30:18 +0200
Message-ID: <7c86c4470910071430q6c6b9bf0k36458f46d1231420@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf_events: add event constraints support for Intel 
	processors
From: stephane eranian <eranian@googlemail.com>
To: David Miller <davem@davemloft.net>
Cc: paulus@samba.org, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       mingo@elte.hu, perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 7, 2009 at 10:46 PM, David Miller <davem@davemloft.net> wrote:
> From: stephane eranian <eranian@googlemail.com>
> Date: Wed, 7 Oct 2009 14:31:58 +0200
>
>> What PPC does is probably the only way to do this given the interface between
>> generic and machine-specific code. The one advantage I see is that it works
>> inside an event group but also across event groups because that code does not
>> look at group boundary, it only looks at the events and the number of available
>> registers. The downside is that you duplicate state.
>>
>> Did I get this right, Paul?
>
> That's basically how his code works, yes.  I intend on duplicating
> it to some extent on sparc64 since I'm operating in a similar
> problem space.
>
> So if at least some of this engine went to a generic place, there'd
> be at least a 3rd user :-)

Based on my experience, the assignment problem is best handled
in the architecture or model specific code. On some PMU models,
it is way more complicated than just two events competing for the
same counter. That's the case on Itanium, for instance. And that
is also the case with AMD64 Northbridge events.

Something I forgot to mention earlier is that when you re-run the
assignment code for the new event, no already assigned event
can be kicked out in favor of the new event. An existing event
can be moved to another counter at worst. Otherwise, you will
evict an event which, the generic layer thinks, is currently running.



>
