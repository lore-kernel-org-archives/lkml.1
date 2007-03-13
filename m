Return-Path: <linux-kernel-owner+w=401wt.eu-S933287AbXCMU2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287AbXCMU2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 16:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933177AbXCMU2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 16:28:35 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:52391 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933287AbXCMU2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 16:28:33 -0400
Subject: Re: [RFC][PATCH 2/7] RSS controller core
From: Dave Hansen <hansendc@us.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>, containers@lists.osdl.org,
       menage@google.com, linux-kernel@vger.kernel.org, xemul@sw.ru
In-Reply-To: <20070313190931.1417c012@lxorguk.ukuu.org.uk>
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru>
	 <20070306140036.4e85bd2f.akpm@linux-foundation.org>
	 <45F3F581.9030503@sw.ru>
	 <20070311045111.62d3e9f9.akpm@linux-foundation.org>
	 <20070312010039.GC21861@MAIL.13thfloor.at>
	 <1173724979.11945.103.camel@localhost.localdomain>
	 <20070312224129.GC21258@MAIL.13thfloor.at>
	 <20070312220439.677b4787.akpm@linux-foundation.org>
	 <1173806793.6680.44.camel@localhost.localdomain>
	 <20070313190931.1417c012@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 13:28:26 -0700
Message-Id: <1173817706.6680.83.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 19:09 +0000, Alan Cox wrote:
> > stuff is happening by comparing page->count and page->_mapcount, but it
> > certainly wouldn't be conclusive.  But, does this kind of nonsense even
> > happen in practice?  
> 
> "Is it useful for me as a bad guy to make it happen ?"

A very fine question. ;)

To exploit this, you'd need to:
1. need to access common data with another user
2. be patient enough to wait
3. determine when one of those users had actually pulled
   a page in from disk, which sys_mincore() can do, right?

I guess that might be a decent reason to not charge the guy who brings
the page in for the page's entire lifetime.  

So, unless we can change page ownership after it has been allocated,
anyone accessing shared data can get around resource limits if they are
patient.  

-- Dave

