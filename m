Return-Path: <linux-kernel-owner+w=401wt.eu-S1761296AbYGJSPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761296AbYGJSPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760263AbYGJSOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:14:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35007 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760219AbYGJSOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:14:52 -0400
Message-ID: <48765006.4020505@zytor.com>
Date: Thu, 10 Jul 2008 14:08:06 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org>	<4875231F.1020506@zytor.com> <487524A0.6020304@goop.org>	<487529AE.3060505@zytor.com> <m1r6a2r9nj.fsf@frodo.ebiederm.org>	<48753A71.2030006@zytor.com> <m18wwahauq.fsf@frodo.ebiederm.org>
In-Reply-To: <m18wwahauq.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> Another alternative that almost fares better then a segment with
> a base of zero is a base of -32K or so.  Only trouble that would get us
> manually managing the per cpu area size again.
> 

Yes, an extra link pass would be better than that.  I have tried, and 
none of the clever things I tried actually works, since GNU ld has 
pretty much no way to get it to reveal its information ahead of time.

However, I want to explore the details of the supposed toolchain issue; 
it might be just a simple tweak to the way things are done now to fix it.

Clearly, given the stack protector ABI, we want %gs:40 to be usable and 
free.

	-hpa
