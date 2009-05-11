Return-Path: <linux-kernel-owner+w=401wt.eu-S1759708AbZEKV0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708AbZEKV0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759448AbZEKV0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:26:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759325AbZEKV0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:26:12 -0400
Date: Mon, 11 May 2009 14:19:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: kosaki.motohiro@jp.fujitsu.com, gregkh@suse.de, npiggin@suse.de,
       mel@csn.ul.ie, a.p.zijlstra@chello.nl, cl@linux-foundation.org,
       dave@linux.vnet.ibm.com, san@android.com, arve@android.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 06/11 -mmotm] oom: move oom_adj value from task_struct
 to mm_struct
Message-Id: <20090511141931.f3f48ec2.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0905110141100.24726@chino.kir.corp.google.com>
References: <20090511091640.B9B5.A69D9226@jp.fujitsu.com>
	<alpine.DEB.2.00.0905101724400.31823@chino.kir.corp.google.com>
	<20090511103849.B9BE.A69D9226@jp.fujitsu.com>
	<alpine.DEB.2.00.0905110141100.24726@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 01:43:10 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Mon, 11 May 2009, KOSAKI Motohiro wrote:
> 
> > From technical view, your explanation seems good although I haven't
> > review your patch.
> > but this patch break staging driver rule. I don't like it.
> > 
> > IOW, if greg pull this patch into his staging tree, it might make
> > patch conflict against -mm tree in nearly future.
> > 
> 
> If I am going to break code that is in mainline (like the Android low 
> memory killer is) by moving a member of a data structure, then I'd like to 
> provide a fix for it so that it works after my change.  I'll leave the 
> merging to Andrew and Greg and if they'd prefer I do this patch in two 
> parts, that's fine by me as long as they merge them at the same time.  I 
> thought since this code is mainline that it would be easier to go through 
> in one series.

Yep, this all has to be done as a single commit to avoid creating
points in the commit sequence where the kernel doesn't build.

As I'm cherrypicking my way around the android driver changes I
reworked this patch to apply on plain old mainline.

