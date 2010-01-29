Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792Ab0A2G71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab0A2G71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 01:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990Ab0A2G70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 01:59:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab0A2G70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 01:59:26 -0500
Message-ID: <4B6287E6.8020403@redhat.com>
Date: Fri, 29 Jan 2010 02:01:58 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 4/9] perf session: Create kernel maps in the constructor
References: <1264633557-17597-1-git-send-email-acme@infradead.org> <1264633557-17597-4-git-send-email-acme@infradead.org> <4B60C9A6.10704@redhat.com> <20100127232936.GI12567@ghostprotocols.net> <4B61BB2D.70802@redhat.com> <20100128182951.GB2499@ghostprotocols.net> <4B61FABA.6000600@redhat.com> <20100129004242.GC2499@ghostprotocols.net>
In-Reply-To: <20100129004242.GC2499@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> Em Thu, Jan 28, 2010 at 03:59:38PM -0500, Masami Hiramatsu escreveu:
>>> you'll get ipv6.ko located and loaded, mod->dso->long_name thus will
>>> have the file to use with libdwarf and sym->start will have the
>>> unrelocated address, and mod->start will have where ipv6 is loaded in
>>> kernel space
> 
>> Oh, nice :-) Is that available for the modules which aren't loaded?
> 
> No it isn't, what usecase do you see where you would like to look at non
> loaded modules? Traversing the /lib/modules passed can be made to just
> create DSOs, not maps if we need it. Maps when created using one of these
> DSOs would find them on the list.

One usecase I thought is probing module init code for checking/debugging
driver initialization routine. For this purpose, build-id checking also
should be solved. If the module is not loaded, we can't check build-id
in that time. I think we can compare it when loading the module,
in kernel, if we can pass target build-id to kprobe-tracer.


>> And yeah, I'd like to support modules and it will requires some
>> enhancement in kprobe-tracer too.
> 
> Ok
> 
> <SNIP>
>>> With the recent modifications done to untie the session and symbol
>>> layers, 'perf probe' now can use just the symbols layer.
> 
>> Could you remove session.kmap too?
>> other parts look good to me.
> 
> I'll haven't done that just to keep the patch as small as possible :-)
> But will do before submitting.

Thanks! :-)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

