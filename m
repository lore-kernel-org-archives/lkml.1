Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbYHNCKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbYHNCKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 22:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYHNCK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 22:10:26 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:32605 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbYHNCKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 22:10:25 -0400
Subject: Re: [PATCH 4/6] Replace inode flush semaphore with a completion
From: Daniel Walker <dwalker@mvista.com>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, matthew@wil.cx
In-Reply-To: <20080814001938.GC6119@disturbed>
References: <1214556284-4160-1-git-send-email-david@fromorbit.com>
	 <1214556284-4160-5-git-send-email-david@fromorbit.com>
	 <1218597077.6166.15.camel@dhcp32.mvista.com>
	 <20080813075057.GZ6119@disturbed>
	 <1218641641.6166.32.camel@dhcp32.mvista.com>
	 <20080814001938.GC6119@disturbed>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 18:34:49 -0700
Message-Id: <1218677690.6166.51.camel@dhcp32.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-14 at 10:19 +1000, Dave Chinner wrote:
> *However*, given that we already have this exact state in the
> completion itself, I see little reason for adding the additional
> locking overhead and the complexity of race conditions of keeping
> this state coherent with the completion. Modifying the completion
> API slightly to export this state is the simplest, easiest solution
> to the problem....
> 

I'm not suggesting anything concrete at this point, I'm just thinking
about it.

If you assume that most of the time your doing async flushing, you
wouldn't often need to do blocking on the completion .. Another way of
doing it would be drop the completion most of the time, and just use the
flag. Then in the rare case that a function needs to block make a stack
local completion, pass it as a pointer inside the xfs_inode_t, if it's
non-null when the write is finished you would complete().

Daniel

