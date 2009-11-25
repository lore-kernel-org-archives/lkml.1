Return-Path: <linux-kernel-owner+w=401wt.eu-S1758091AbZKYQN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091AbZKYQN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 11:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbZKYQN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 11:13:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbZKYQNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 11:13:55 -0500
Message-ID: <4B0D5789.3000303@redhat.com>
Date: Wed, 25 Nov 2009 11:12:57 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH -tip v5 07/10] kprobes/x86: Support kprobes jump	optimization
 on x86
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com> <20091123232211.22071.58974.stgit@dhcp-100-2-132.bos.redhat.com> <20091124162708.GA29995@redhat.com> <4B0C1BF8.9060408@redhat.com>
In-Reply-To: <4B0C1BF8.9060408@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Jason Baron wrote:
>> Also, with multiple users we don't want to trample over each others code
>> patching. Thus, if each sub-system could register some type of
>> 'is_reserved()' callback, and then we can call all these call backs from
>> the '__multibyte_poke()' routine before we do any patching to make sure
>> that we aren't trampling on each others code. After a successful
>> patching, each sub-system can update its reserved set of code as
>> appropriate. I can code a prototype here, if this makes sense.
>
> Hmm, we have to implement it carefully, because here kprobes already
> inserted int3 and optprobe rewrites the int3 again. If is_reserved()
> returns 1 and multibyte_poke returns error, we can't optimize it anymore.

IMHO, all text-modifiers except kprobes provide is_reserved() callback
and kprobes cancels probing if its target address is reserved, since
only kprobes changes texts anywhere while others changes texts at
fixed addresses.

Anyway, I think this will be another bugfix for current kprobes/alternative.

Thank you,
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

