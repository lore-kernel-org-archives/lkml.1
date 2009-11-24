Return-Path: <linux-kernel-owner+w=401wt.eu-S1758204AbZKXTp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbZKXTp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 14:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758026AbZKXTp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 14:45:27 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:51087 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758005AbZKXTp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 14:45:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s8nSZ2fiN6R4/s2bNljWnqcB5Il9G2Sf/h6s6vKpTeqs/xPyKuGnFwMiotbNNUlow1
         gD6Rdj2nET9m1rrtAYKm3leXQndz/bflLirpsmgY4Ndb/C74DBbZgH/95xkWrhZd4/lM
         AjvsMjhMgPZIoMEpT8ytriVMKmWluwwVnt82g=
Date: Tue, 24 Nov 2009 20:45:28 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [PATCH -tip v5 03/10] kprobes: Introduce kprobes jump
	optimization
Message-ID: <20091124194524.GA5071@nowhere>
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com> <20091123232141.22071.53317.stgit@dhcp-100-2-132.bos.redhat.com> <20091124024417.GA6752@nowhere> <4B0BFCF0.3060607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0BFCF0.3060607@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 10:34:08AM -0500, Masami Hiramatsu wrote:
> > And this comment doesn't tell us much what this brings us.
> > The changelog tells it stands to avoid a text_mutex deadlock.
> > I'm not sure why we would deadlock without it.
> 
> As Mathieu and I discussed on LKML (http://lkml.org/lkml/2009/11/21/187)
> text_mutex will be locked on the way of cpu-hotplug.
> Since kprobes locks text_mutex too and stop_machine() refers online_cpus,
> it will cause a dead-lock. So, I decided to use get_online_cpus() to
> locking hotplug while optimizing/unoptimizng.


Ah ok :)
Could you add a comment in the code that explains it?

Thanks.

