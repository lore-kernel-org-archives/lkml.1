Return-Path: <linux-kernel-owner+w=401wt.eu-S1754386AbYA2VH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbYA2VH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 16:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYA2VHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 16:07:12 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:51132 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYA2VHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 16:07:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=lBGYd8ZwdAuPmPWUD4dsbMfKc+cr6CafE4mcHaKGnuK4265Y2UUpXbyOgu2lHOykU1Ag1FbFTHzYoHz5mc0CALnmFGnjNJO3fU2QCB0G5qJ4EsMx2YH7e7wQAINYJlGg+IRiXaMYlUFG/dlf1RFsEkzHmrINXV6EtkEH478w2t0=
Date: Wed, 30 Jan 2008 00:06:56 +0300
To: pierre.peiffer@bull.net
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 2.6.24-rc8-mm1 09/15] (RFC) IPC: new kernel API to change an ID
Message-ID: <20080129210656.GB1990@martell.zuzino.mipt.ru>
References: <20080129160229.612172683@bull.net> <20080129162000.454857358@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129162000.454857358@bull.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 05:02:38PM +0100, pierre.peiffer@bull.net wrote:
> This patch provides three new API to change the ID of an existing
> System V IPCs.
> 
> These APIs are:
> 	long msg_chid(struct ipc_namespace *ns, int id, int newid);
> 	long sem_chid(struct ipc_namespace *ns, int id, int newid);
> 	long shm_chid(struct ipc_namespace *ns, int id, int newid);
> 
> They return 0 or an error code in case of failure.
> 
> They may be useful for setting a specific ID for an IPC when preparing
> a restart operation.
> 
> To be successful, the following rules must be respected:
> - the IPC exists (of course...)
> - the new ID must satisfy the ID computation rule.
> - the entry in the idr corresponding to the new ID must be free.

>  ipc/util.c          |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  ipc/util.h          |    1 +
>  8 files changed, 197 insertions(+)

For the record, OpenVZ uses "create with predefined ID" method which
leads to less code. For example, change at the end is all we want from
ipc/util.c .

Also, if ids were A and B at the moment of checkpoint, and during
restart they became B and A you'll get collision in both ways which you
techically can avoid by classic "tmp = A, A = B, B = tmp" but you also
can avoid all other loops just by creating with ID you need.
