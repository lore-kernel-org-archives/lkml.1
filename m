Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbZKXDUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbZKXDUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 22:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757792AbZKXDUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 22:20:09 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35268 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602AbZKXDUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 22:20:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p3kihWOB4eRNB/8bEuMwCQEK2ueVnQxGV6rPU3TJn3HvuHcVNLQdQwo4EufySeJ80J
         tu5GvcROZlFg1GBDvmJOtBuTqO/ae5BFPY4Ot6VP5xSn7gFwo6RVo1spcWc7hBNhh2Wr
         7rsDOaGVAGfFTwjPm0CR2TNU2duWlstp+tkkg=
Date: Tue, 24 Nov 2009 04:20:09 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip v5 00/10] kprobes: Kprobes jump optimization
	support
Message-ID: <20091124032008.GD6752@nowhere>
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com> <20091124020315.GA6221@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124020315.GA6221@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 03:03:19AM +0100, Frederic Weisbecker wrote:
> On Mon, Nov 23, 2009 at 06:21:16PM -0500, Masami Hiramatsu wrote:
> >   When the optimized-kprobe is hit before optimization, its handler
> >  changes IP(instruction pointer) to copied code and exits. So, the
> >  instructions which were copied to detour buffer are executed on the detour
> >  buffer.
> 
> 
> 
> Hm, why is it playing such hybrid game there?
> If I understand well, we have executed int 3, executed the
> handler and we jump back to the detour buffer?
> 


I got it, I think. We have instructions to patch. And the above
turn this area into dead code, safe to patch.

But still, stop_machine() seem to make it not necessary anymore.

