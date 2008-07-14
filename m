Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbYGNQ2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbYGNQ2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbYGNQ2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:28:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029AbYGNQ2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:28:24 -0400
Message-ID: <487B7E37.9050600@redhat.com>
Date: Mon, 14 Jul 2008 12:26:31 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Theodore Tso <tytso@mit.edu>, "Frank Ch. Eigler" <fche@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] simple dprobe like markers for the kernel
References: <1215638551.3444.39.camel__22002.9595810503$1215638656$gmane$org@localhost.localdomain>	 <y0m1w22qxoj.fsf@ton.toronto.redhat.com>	 <1215697794.3353.5.camel@localhost.localdomain>	 <20080710142208.GC1213@redhat.com>	 <1215700996.3353.30.camel@localhost.localdomain>	 <20080710153017.GB25939@mit.edu> <1215886965.3360.16.camel@localhost.localdomain>
In-Reply-To: <1215886965.3360.16.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

James Bottomley wrote:
> This is just an incremental update based on feedback.  The most
> significant was that making the marker a compiler barrier will free the
> inserter from worrying about the mark sliding around changes to named
> variables (and thus having to worry about this in placement) at
> practically zero optimisation cost.  I also updated the code to drop and
> asm section instead of using the static variable scheme.  I also added
> documentation and made the module loader ignore them (since modules
> don't go through the vmlinux.lds transformations).

I'm very interested in your approach.

IMHO, as Aoki investigated, the overhead of markers is not so big
unless we put a lot of them into kernel. And from "active"
overhead point of view, it takes less than tens of nano-seconds,
while kprobes takes hundreds of nano-seconds. Kprobe also has a
limitation of probable points, it can't probe "__kprobes" marked
functions. So, original markers still has advantages.

However, your approach is also useful, especially for embedding
thousands of markers in kernel or drivers.

So I think it's better to use both of them as the situation demands.

I just have one comment on its name. Since it doesn't trace
anything, so I'd rather like notation() or note_mark() than
trace_simple(). :-)

Thank you,

> 
> I also added a simple versioning scheme (basically tack the version on
> to the end of the section name).  It can be used simply and even
> provides backwards compatibility (just emit the old and the new
> sections).
> 
> If everyone's happy with this, I'll follow it up with the systemtap
> changes to make use of them ... they've been incredibly helpful
> debugging some of the CDROM problems for me so far.
> 
> James

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

