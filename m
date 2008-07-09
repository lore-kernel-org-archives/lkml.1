Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbYGIVVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbYGIVVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYGIVVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:21:03 -0400
Received: from gw.goop.org ([64.81.55.164]:46752 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232AbYGIVVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:21:01 -0400
Message-ID: <48752BAC.2050905@goop.org>
Date: Wed, 09 Jul 2008 14:20:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>	<4875209D.8010603@goop.org> <487522A8.60906@zytor.com>	<48752409.1030201@goop.org> <m1abgqu5rg.fsf@frodo.ebiederm.org>
In-Reply-To: <m1abgqu5rg.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> But we can pick an arbitrary point where %gs points at.
>
> Hmm.  This whole thing is even sillier then I thought.
> Why can't we access per cpu vars as:
> %gs:(per_cpu__var - __per_cpu_start) ?
>   

Because there's no linker reloc for doing subtraction (or addition) of 
two symbols.

> If we can subtract constants and allow the linker to perform that resolution
> at link.  A zero based per cpu segment becomes a moot issue.
>   

They're not constants; they're symbols.

    J
