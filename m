Return-Path: <linux-kernel-owner+w=401wt.eu-S1765589AbZDAOXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765589AbZDAOXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759578AbZDAOXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:23:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46442 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761423AbZDAOXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:23:14 -0400
Date: Wed, 1 Apr 2009 15:23:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [rfc] scale dcache locking
Message-ID: <20090401142312.GD28946@ZenIV.linux.org.uk>
References: <20090329155539.275927173@nick.local0.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090329155539.275927173@nick.local0.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 02:55:39AM +1100, npiggin@suse.de wrote:
> This is my sketch for improving dcache locking scalability. So far I've
> only really been looking at core code to get an idea of how it might look,
> so most configurable functionality is broken (and unfortunately it might
> well be something in there which will cause a fundamental problem for me).

Umm...  Some of that makes obvious sense per se, some...  In particular,
all of a sudden we get contention between multiple dput() on the same
dentry, which is dirt-common for directory ones.
