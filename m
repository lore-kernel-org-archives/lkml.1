Return-Path: <linux-kernel-owner+w=401wt.eu-S1752106AbZLaAow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbZLaAow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 19:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbZLaAow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 19:44:52 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:64136 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZLaAov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 19:44:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kOa+Vz8y/qPiciohD9cAmNI+314vmI6fSdcsgePyOntx/qSYYJz1aPJXz7htHEks9v
         fQq6a1jXT2V5Cu4agdEb/2slbQB3Ozld3BhKeYrLAjez4oTonq/5feiTQN6iQ0NvcU6E
         BNCvXIAwI43EsHIEY9URxesGGTgsuYhSF9XDE=
Date: Thu, 31 Dec 2009 01:44:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC Patch 2/2][Bugfix][x86][hw-breakpoint] Fix return-code to
	notifier chain in hw_breakpoint_handler
Message-ID: <20091231004446.GD23808@nowhere>
References: <20091226175533.149765731@linux.vnet.ibm.com> <20091226182833.GC9494@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091226182833.GC9494@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 26, 2009 at 11:58:33PM +0530, K.Prasad wrote:
> +		/*
> +		 * Further processing in do_debug() is needed for a) user-space
> +		 * breakpoints (to generate signals) and b) when the system has
> +		 * taken exception due to multiple causes
> +		 */
> +		if (bp->attr.bp_addr < TASK_SIZE)
> +			rc = NOTIFY_DONE;



BTW, I'm not sure this is the right way to check if we want to send
a signal or not. Although it's not yet supported, we'll probably
bring the support for userspace breakpoints by perf.

May be we should put a "ptrace" flag in struct hw_perf_event instead.

