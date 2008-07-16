Return-Path: <linux-kernel-owner+w=401wt.eu-S1760333AbYGPOrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760333AbYGPOrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760235AbYGPOrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:47:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760229AbYGPOrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:47:35 -0400
Message-ID: <487E09DB.3000205@linux-foundation.org>
Date: Wed, 16 Jul 2008 09:46:51 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Richard Kennedy <richard@rsk.demon.co.uk>, penberg@cs.helsinki.fi,
       mpm@selenic.com, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH][RFC] slub: increasing order reduces memory usage of some
 key caches
References: <1216211371.3122.46.camel@castor.localdomain>	 <487DF5D4.9070101@linux-foundation.org>	 <1216216730.3122.60.camel@castor.localdomain>	 <487DFFBE.5050407@linux-foundation.org> <19f34abd0807160733q2594bd9fk268703d2aedc8254@mail.gmail.com>
In-Reply-To: <19f34abd0807160733q2594bd9fk268703d2aedc8254@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:

> Hm, I don't think so? I thought that those 1 and 2 were not orders,
> but in fact the number of pages. Which seems correct, since now you
> have 4096 / 208 = 19 :-)

Makes sense. So the problem is that for some reason his kernel chose order 0 for dentries. Mine choose order 1 and everything was fine. Maybe related to the number of processors (my box has 8)? We added some logic in 2.6.26 to increase slab sizes if lots of processors are present.
