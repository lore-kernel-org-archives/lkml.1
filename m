Return-Path: <linux-kernel-owner+w=401wt.eu-S1764767AbZLQOTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764767AbZLQOTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 09:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757344AbZLQOTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 09:19:12 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:49228 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243AbZLQOTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 09:19:11 -0500
Date: Thu, 17 Dec 2009 07:19:08 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Liuweni <qingshenlwy@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       viro <viro@zeniv.linux.org.uk>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       strongzgy <strongzgy@gmail.com>, Liu Hui <onlyflyer@gmail.com>
Subject: Re: [PATCH 1/3]posix acl:Add an acl check
Message-ID: <20091217141908.GV7812@parisc-linux.org>
References: <200912172215402654375@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912172215402654375@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 10:15:43PM +0800, Liuweni wrote:
> In this function, the parameter of acl will be called by FOREACH_ACL_ENTRY(macro) 
> without null point check. I add a null point check to it. 

All the callers of posix_acl_valid() currently check for acl being a
null pointer themselves.  Moving the check to posix_acl_valid() certainly
seems like a good idea to me, but you need to delete the check from all
the callers.

Further, it seems like many of the callers might have a PTR_ERR value
for 'acl', so you should also move this check into posix_acl_valid().

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
