Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbZBZVAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbZBZVAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbZBZVAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:00:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755078AbZBZVAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:00:22 -0500
Date: Thu, 26 Feb 2009 13:00:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       menage@google.com, lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com
Subject: Re: [PATCH 1/2] cgroup allow subsys to set default mode of its own
 file
Message-Id: <20090226130005.3282cb02.akpm@linux-foundation.org>
In-Reply-To: <20090225163555.d2a0b24c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090225163555.d2a0b24c.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009 16:35:55 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

>  When I wrote tools for maintain cgroup, I can't find which file is
>  writable intarfece or not via cgroup file systems. (finally, I did
>  dirty approach.)
>  IMHO, showing "this file is read-only" in explicit way is useful
>  for user-land (tools). In other story, a file whose name sounds read-only
>  may have "trigger" operation and support reseting. In this case,
>  "writable" is informative.

Well, we have compatibility issues here.  If we make this change, and
people write tools which depend upon that change then those tools might
break when run upon older kernels.  Or they need back-compatibility
additions, which increases the testing burden of those tools.

One way in which we could improve this situation is to backport these
changes into earlier kernels, although I don't know which versions.

What do we think?
