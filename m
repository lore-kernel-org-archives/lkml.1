Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbYHLTZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbYHLTZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 15:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYHLTZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 15:25:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43400 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbYHLTZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 15:25:14 -0400
Date: Tue, 12 Aug 2008 15:25:11 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mimi Zohar <zohar@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com,
       Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/4] integrity: Linux Integrity Module(LIM)
Message-ID: <20080812192511.GA18034@infradead.org>
References: <20080808184349.999902616@linux.vnet.ibm.com> <1218221761.4444.13.camel@localhost.localdomain> <20080809185340.GC22905@infradead.org> <OF0AEBDCA2.1E27B823-ON852574A1.000FEE48-852574A1.004C3185@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF0AEBDCA2.1E27B823-ON852574A1.000FEE48-852574A1.004C3185@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 09:52:13AM -0400, Mimi Zohar wrote:
> We started out with the integrity_inode_permission() hook call in 
> inode_permission(), but because of the removal of the nameidata 
> parameter in the last merge, based on discussions
> http://marc.info/?l=linux-security-module&m=121797845308246&w=2,
> the call to integrity_inode_permission() was moved up to the caller,
> where either a file or path are available.  Any suggestions?

vfs_permission and file_permission are just small wrappers around
inode_permission.  In hindsight they actualyl were a wrong idea and
will probably go away in the not so distant future.  Note that there
are various callers of inode_permission that don't have a vfsmount
anywhere near.

