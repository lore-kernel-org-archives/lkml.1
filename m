Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856AbZJGEiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbZJGEiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 00:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbZJGEiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 00:38:16 -0400
Received: from mail-gx0-f212.google.com ([209.85.217.212]:33869 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbZJGEiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 00:38:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UaA2aHCEucsTynD8Vl1A7Y4/xx6LwFOcdqeBR7edMAFl5ONGz+4GnF29QlwzgAlMsu
         Xta5R/wAAV2/QUWuhRJU/qUzjLwqJWmwEgr2okeOcQ5wuBG7v8UWwuuLizmEyeh5qpHA
         p56QPbR7bLy8xe3U80Byfi+mlAIl/vYikpB/g=
Subject: Re: [tip:perf/core] tracing/events: Add 'signed' field to format
 files
From: Tom Zanussi <tzanussi@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <20091006150510.GA5152@nowhere>
References: <1254809398-8078-2-git-send-email-tzanussi@gmail.com>
	 <tip-26a50744b21fff65bd754874072857bee8967f4d@git.kernel.org>
	 <20091006150510.GA5152@nowhere>
Content-Type: text/plain
Date: Tue, 06 Oct 2009 23:30:02 -0500
Message-Id: <1254889802.28917.156.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 17:05 +0200, Frederic Weisbecker wrote:
> On Tue, Oct 06, 2009 at 01:06:39PM +0000, tip-bot for Tom Zanussi wrote:
> > Commit-ID:  26a50744b21fff65bd754874072857bee8967f4d
> > Gitweb:     http://git.kernel.org/tip/26a50744b21fff65bd754874072857bee8967f4d
> > Author:     Tom Zanussi <tzanussi@gmail.com>
> > AuthorDate: Tue, 6 Oct 2009 01:09:50 -0500
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Tue, 6 Oct 2009 15:04:45 +0200
> > 
> > tracing/events: Add 'signed' field to format files
> > 
> > The sign info used for filters in the kernel is also useful to
> > applications that process the trace stream.  Add it to the format
> > files and make it available to userspace.
> 
> 
> 
> This is something we could already find using the type of
> the field.
> 

Hmm, yeah, we do have the field type but in the form of a string, which
I guess we'd need some kind of type map to get the sign out of.  Since
we already have the sign info, though, it made sense to me to stick it
in the format file, other than the fact that it might break some
existing tools.  I didn't think the final format was nailed down yet so
thought that might not be so important at this point...

Tom

> Also I wonder if that breaks the format definition ABI. I mean:
> event formats are not ABI, except for the TRACE_EVENT_ABI.
> But concerning how we describe the format description, I
> have doubts.
> 
> As an example, I don't know if this patch would break 2.6.32-rc1
> (and then 2.6.32) based perf tools running on a future 2.6.33
> kernel.
> 

