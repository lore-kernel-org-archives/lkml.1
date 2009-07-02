Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbZGBKMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbZGBKMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 06:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbZGBKMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 06:12:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57546 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742AbZGBKMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 06:12:39 -0400
Message-ID: <4A4C887F.2050508@redhat.com>
Date: Thu, 02 Jul 2009 18:14:23 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Eugene Teo <eteo@redhat.com>,
       viro@zeniv.linux.org.uk
Subject: Re: [Patch] allow file truncations when both suid and write  permissions
 set
References: <20090625090146.6616.9720.sendpatchset@localhost.localdomain>	 <4A4BA6F8.7090905@redhat.com> <4A4BB898.10909@redhat.com>	 <7e0fb38c0907011229h328c8c48i55df5e234b7d367d@mail.gmail.com> <1246479341.22562.71.camel@dhcp235-23.rdu.redhat.com>
In-Reply-To: <1246479341.22562.71.camel@dhcp235-23.rdu.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> So NAK on both Amerigo's and Eric's patch.  ATTR_FORCE is wrong.
> ATTR_FORCE here is going to force the security system to accept ALL of
> the attr changes, not just the ATTR_KILL_SUID and/or ATTR_KILL_SGID you
> |= in from should_remove_suid.
> You need to follow esandeen's recommendation, change file_remove_suid()
> to dentry_remove_suid() and then use dentry_remove_suid() in do_truncate
> instead of what you are currently trying to do (and I think that's
> supposed to be done under the i_mutex right?)
>   
But file_remove_suid() actually adds ATTR_FORCE too, in __remove_suid()...

