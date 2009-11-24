Return-Path: <linux-kernel-owner+w=401wt.eu-S933943AbZKXVSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933943AbZKXVSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:18:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933267AbZKXVSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:18:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933300AbZKXVSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:18:00 -0500
Message-ID: <4B0C4CD9.3010603@redhat.com>
Date: Tue, 24 Nov 2009 16:15:05 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH -tip v5 03/10] kprobes: Introduce kprobes jump	optimization
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com> <20091123232141.22071.53317.stgit@dhcp-100-2-132.bos.redhat.com> <20091124024417.GA6752@nowhere> <4B0BFCF0.3060607@redhat.com> <20091124194524.GA5071@nowhere>
In-Reply-To: <20091124194524.GA5071@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Nov 24, 2009 at 10:34:08AM -0500, Masami Hiramatsu wrote:
>>> And this comment doesn't tell us much what this brings us.
>>> The changelog tells it stands to avoid a text_mutex deadlock.
>>> I'm not sure why we would deadlock without it.
>>
>> As Mathieu and I discussed on LKML (http://lkml.org/lkml/2009/11/21/187)
>> text_mutex will be locked on the way of cpu-hotplug.
>> Since kprobes locks text_mutex too and stop_machine() refers online_cpus,
>> it will cause a dead-lock. So, I decided to use get_online_cpus() to
>> locking hotplug while optimizing/unoptimizng.
>
>
> Ah ok :)
> Could you add a comment in the code that explains it?

Sure, of course :-)


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

