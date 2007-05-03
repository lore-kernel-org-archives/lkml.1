Return-Path: <linux-kernel-owner+w=401wt.eu-S1162019AbXECOg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162019AbXECOg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 10:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162021AbXECOgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 10:36:55 -0400
Received: from mail.samba.org ([66.70.73.150]:60375 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162019AbXECOgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 10:36:54 -0400
Subject: Re: [linux-cifs-client] Re: SMB2 file system - should it be a
	distinct module
From: simo <idra@samba.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Steve French <smfrench@gmail.com>, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070503141742.GB20328@infradead.org>
References: <524f69650704301552j13cd46e5y53a233af753e0548@mail.gmail.com>
	 <20070501090657.GA17949@infradead.org>
	 <1178198489.28758.14.camel@localhost.localdomain>
	 <20070503141742.GB20328@infradead.org>
Content-Type: text/plain
Organization: Samba Team
Date: Thu, 03 May 2007 10:36:53 -0400
Message-Id: <1178203013.28758.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-03 at 15:17 +0100, Christoph Hellwig wrote:
> On Thu, May 03, 2007 at 09:21:29AM -0400, simo wrote:
> > Separate modules would mean the user have to know which protocol to
> > choose each time. And this make little sense.
> 
> Of course it makes a lot of sense.  We don't have anyfs.ko either
> because some ubuntu users are too braindead to know what's on their
> disk.
> 
> > You really want to auto-negotiate which protocol to use, because you
> > could have at the same time a connection to a Vista/Longhorn (SMB2)
> > machine and one to a Windows 2000 server (plain SMB) in the same domain
> > using the same credentials.
> 
> So what?

I guess DFS referrals can work cross protocol, so if you are redirected
from a longhorn server to a windoes 2000 or a samba server you want to
be able to follow the DFS referral and not return an error.
To do that you need to have either 1 module that support both protocols
or a way from one module to call the other. Just separating the 2
without any glue will not work (or you will have to add some userspace
upcall hack to make it work).

Simo.

-- 
Simo Sorce
Samba Team GPL Compliance Officer
email: idra@samba.org
http://samba.org

