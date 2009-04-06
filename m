Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbZDFRnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbZDFRnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 13:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZDFRnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 13:43:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60103 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbZDFRnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 13:43:32 -0400
Message-ID: <49DA3F85.7050302@redhat.com>
Date: Mon, 06 Apr 2009 13:44:37 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [BUGFIX][PATCH -tip] x86: fix text_poke to handle highmem pages
References: <49D76FFF.6020202@redhat.com> <20090404154230.GB2451@Krystal> <49D7A6DF.8080804@redhat.com> <49D7AF26.5030808@redhat.com> <49D82987.5090003@redhat.com> <49DA37CB.4020901@redhat.com> <20090406173238.GA31867@Krystal>
In-Reply-To: <20090406173238.GA31867@Krystal>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
>> Fix a bug in text_poke to handle highmem pages, because module
>> text pages are possible to be highmem pages on x86-32.
>> In that case, since fixmap can't handle those pages, text_poke
>> uses kmap_atomic.
>>
> 
> Hrm, can you remind me what would be the downside of using kmap_atomic
> in every scenarios (highmem and non-highmem) then ?

kmap_atomic can handle only highmem pages. If you passes lowmem pages,
it returns just original vaddr of it. (because kmap is only for
highmem support)

> 
> I would try to avoid "special cases" as much as possible, because they
> just make problems harder to reproduce.

Actually, this bug is a special case because it happens only on PAE kernel.

> 
> The idea would be to either add fixmap highmem support, or to simply use
> kmap_atomic() for all cases until we add fixmap highmem support.
> 


Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

