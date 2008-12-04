Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbYLDOJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbYLDOJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 09:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbYLDOJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 09:09:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47378 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbYLDOJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 09:09:09 -0500
Date: Thu, 4 Dec 2008 15:20:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Alasdair G Kergon <agk@redhat.com>,
       Andi Kleen <andi-suse@firstfloor.org>, Milan Broz <mbroz@redhat.com>
Subject: Re: Device loses barrier support (was: Fixed patch for simple barriers.)
Message-ID: <20081204142015.GQ6703@one.firstfloor.org>
References: <Pine.LNX.4.64.0812040009340.15169@hs20-bc2-1.build.redhat.com> <20081204100050.GN6703@one.firstfloor.org> <Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> the 1st write request ends with success
> the 2nd write request ends with -EOPNOTSUPP
> the 3rd write request ends with success
> 
> --- when you first see -EOPNOTSUPP, you have already corrupted filesystem 
> (the 3rd write passed while the filesystem expected that it would be 

There's no passing of requests during pvmove. It's a really strong
barrier.

> finished after the 2nd write) and you are in an interrupt context, where 
> you can't reissue -EOPNOTSUPP request. So what do you want to do?

The barrier aware file systems I know of just resubmit synchronously when 
a barrier fails.

-Andi
