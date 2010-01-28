Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190Ab0A1Q3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab0A1Q3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 11:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615Ab0A1Q3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 11:29:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588Ab0A1Q3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 11:29:11 -0500
Message-ID: <4B61BB2D.70802@redhat.com>
Date: Thu, 28 Jan 2010 11:28:29 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 4/9] perf session: Create kernel maps in the constructor
References: <1264633557-17597-1-git-send-email-acme@infradead.org> <1264633557-17597-4-git-send-email-acme@infradead.org> <4B60C9A6.10704@redhat.com> <20100127232936.GI12567@ghostprotocols.net>
In-Reply-To: <20100127232936.GI12567@ghostprotocols.net>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> Em Wed, Jan 27, 2010 at 06:17:58PM -0500, Masami Hiramatsu escreveu:
>> Arnaldo Carvalho de Melo wrote:
>>> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>>>
>>> Removing one extra step needed in the tools that need this, fixing a bug
>>> in 'perf probe' where this was not being done.
>>
>> Thanks,
>> BTW, when O_WRONLY should be used? I guess I might misunderstand something
>> in builtin-probe.c, and it should use O_RDONLY ...
> 
> O_RDONLY only when you have a perf.data file, O_WRONLY was thought for
> 'perf record', then for tools that want only to do symbol lookup it was
> reused...

Ah, so that is the mode for perf.data.

> I think we should have a proper enum and more clearly specify these
> semantics, as well as adding a MMAP mode so that we can lift the code
> now in perf top somehow.

Yeah, and if you can separate an interface only for handling symbols
from debug/elf binaries, it will be helpful for me too.

> But for now using O_WRONLY provides what 'perf probe' needs, I guess :-)

I think so ;-)

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

