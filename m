Return-Path: <linux-kernel-owner+w=401wt.eu-S1752874AbZGQUBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbZGQUBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbZGQUBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:01:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34717 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbZGQUBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:01:18 -0400
Date: Fri, 17 Jul 2009 22:01:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sage Weil <sage@newdream.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/20] ceph: debugging
Message-ID: <20090717200114.GA6173@basil.fritz.box>
References: <1247693090-27796-15-git-send-email-sage@newdream.net> <1247693090-27796-16-git-send-email-sage@newdream.net> <1247693090-27796-17-git-send-email-sage@newdream.net> <1247693090-27796-18-git-send-email-sage@newdream.net> <1247693090-27796-19-git-send-email-sage@newdream.net> <87d480x16p.fsf@basil.nowhere.org> <Pine.LNX.4.64.0907161014330.8026@cobra.newdream.net> <Pine.LNX.4.64.0907171010470.23194@cobra.newdream.net> <20090717185641.GH8046@one.firstfloor.org> <Pine.LNX.4.64.0907171247570.23194@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907171247570.23194@cobra.newdream.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 12:52:33PM -0700, Sage Weil wrote:
> > > 		 ceph_file_part(__FILE__, sizeof(__FILE__)),		\
> > > 		 __LINE__, args);
> > 
> > That seems like a wasteful way to do this -- i bet you could
> > shrink binary size with debugging on considerably if you move
> > the file_part into a function.
> 
> If you mean ceph_file_part shouldn't be inline, definitely.  Beyond that 
> I'm not sure what more to change... it's just a few extra chars on the 
> format string and 2 calls instead of 1?

Yes, but you have hundreds/thousands of these calls don't you?

If you have two calls here instead of one and that costs let's say
20 bytes of code and 1000 calls it's already 20K of binary size.

Perhaps code size is not your highest priority now, but 
obvious inefficiencies like this are not good.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
