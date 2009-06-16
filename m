Return-Path: <linux-kernel-owner+w=401wt.eu-S1761018AbZFPT1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761018AbZFPT1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbZFPT1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:27:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753438AbZFPT1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:27:33 -0400
Date: Tue, 16 Jun 2009 12:26:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: xemul@openvz.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cleanup find_task_by_pid variants
Message-Id: <20090616122650.3cb42134.akpm@linux-foundation.org>
In-Reply-To: <20090616191832.GA23048@lst.de>
References: <20090514165750.GA15934@lst.de>
	<20090616191832.GA23048@lst.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009 21:18:32 +0200
Christoph Hellwig <hch@lst.de> wrote:

> 
> On Thu, May 14, 2009 at 06:57:50PM +0200, Christoph Hellwig wrote:
> > 
> > find_task_by_pid_type_ns is only used to implement find_task_by_vpid and
> > find_task_by_pid_ns, but both of them pass PIDTYPE_PID as first argument.
> > So just fold find_task_by_pid_type_ns into find_task_by_pid_ns and use
> > find_task_by_pid_ns to implement find_task_by_vpid.
> > 
> > While we're at it also remove the exports for find_task_by_pid_ns and
> > find_task_by_vpid - we don't have any modular callers left as the only
> > modular caller of he old pre pid namespace find_task_by_pid (gfs2)
> > was switched to pid_task which operates on a struct pid pointer instead
> > of a pid_t.  Given the confusion about pid_t values vs namespace that's
> > generally the better option anyway and I think we're better of restricting
> > modules to do it that way.
> > 
>
> Is anyone going to pick this up?

I already did: http://userweb.kernel.org/~akpm/mmotm/broken-out/pids-clean-up-find_task_by_pid-variants.patch
