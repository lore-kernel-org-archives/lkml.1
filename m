Return-Path: <linux-kernel-owner+w=401wt.eu-S1756724AbZJBQgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbZJBQgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 12:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756460AbZJBQgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 12:36:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53585 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbZJBQgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 12:36:19 -0400
Date: Fri, 2 Oct 2009 18:36:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sage Weil <sage@newdream.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       yehuda@newdream.net
Subject: Re: [PATCH 19/21] ceph: ioctls
Message-ID: <20091002163618.GN1656@one.firstfloor.org>
References: <1253641129-28434-13-git-send-email-sage@newdream.net> <1253641129-28434-14-git-send-email-sage@newdream.net> <1253641129-28434-15-git-send-email-sage@newdream.net> <1253641129-28434-16-git-send-email-sage@newdream.net> <1253641129-28434-17-git-send-email-sage@newdream.net> <1253641129-28434-18-git-send-email-sage@newdream.net> <1253641129-28434-19-git-send-email-sage@newdream.net> <1253641129-28434-20-git-send-email-sage@newdream.net> <87ske2sa2n.fsf@basil.nowhere.org> <Pine.LNX.4.64.0910020840180.16283@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0910020840180.16283@cobra.newdream.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes.  I suspect an explicit
> 
> 	struct in6_addr osd_addr;
> 	__be16 osd_port;
> 
> makes more sense.  Then legacy IPv4 addresses can just be represented as 
> ::ffff:1.2.3.4.  That seems like the simplest route?

You would need to decide internally then if you want to use
the ipv6 socket API (requiring ipv6 to be loaded) or map 
manually. Using af_family might be cleaner.

> 
> I should similarly update the struct ceph_entity_addr as well (it also 
> embeds a sockaddr_in).  And/or embed that struct here.

You could also use struct sockaddr_storage, it's designed to contain arbitary
address types (basically it has a lot of padding)

Trap: if you ever copy it out you have to make sure to not leak
kernel memory in the padding of course.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
