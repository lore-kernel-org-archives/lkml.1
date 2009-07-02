Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbZGBMND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbZGBMND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 08:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbZGBMMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 08:12:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56742 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbZGBMMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 08:12:54 -0400
Subject: Re: [Patch] allow file truncations when both suid and write 
 permissions set
From: Eric Paris <eparis@redhat.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Eugene Teo <eteo@redhat.com>,
       viro@zeniv.linux.org.uk
In-Reply-To: <4A4C887F.2050508@redhat.com>
References: <20090625090146.6616.9720.sendpatchset@localhost.localdomain>
	 <4A4BA6F8.7090905@redhat.com> <4A4BB898.10909@redhat.com>
	 <7e0fb38c0907011229h328c8c48i55df5e234b7d367d@mail.gmail.com>
	 <1246479341.22562.71.camel@dhcp235-23.rdu.redhat.com>
	 <4A4C887F.2050508@redhat.com>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 08:12:19 -0400
Message-Id: <1246536739.22562.73.camel@dhcp235-23.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-02 at 18:14 +0800, Amerigo Wang wrote:
> Eric Paris wrote:
> > So NAK on both Amerigo's and Eric's patch.  ATTR_FORCE is wrong.
> > ATTR_FORCE here is going to force the security system to accept ALL of
> > the attr changes, not just the ATTR_KILL_SUID and/or ATTR_KILL_SGID you
> > |= in from should_remove_suid.
> > You need to follow esandeen's recommendation, change file_remove_suid()
> > to dentry_remove_suid() and then use dentry_remove_suid() in do_truncate
> > instead of what you are currently trying to do (and I think that's
> > supposed to be done under the i_mutex right?)
> >   
> But file_remove_suid() actually adds ATTR_FORCE too, in __remove_suid()...

The difference being that it adds it to a private ia_valid that ONLY
contains the SUID/SGID bits that we need to force the removal of.  Not
to the ia_valid that contains ATTR_SIZE and ATTR_FILE.

-Eric

