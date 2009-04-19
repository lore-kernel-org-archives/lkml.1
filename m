Return-Path: <linux-kernel-owner+w=401wt.eu-S1760650AbZDSPci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760650AbZDSPci (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 11:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758511AbZDSPca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 11:32:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35618 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907AbZDSPc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 11:32:29 -0400
Date: Sun, 19 Apr 2009 16:32:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Zhenwen Xu <helight.xu@gmail.com>
Cc: linux-kernel@vger.kernel.org, eparis@redhat.com, linux-audit@redhat.com
Subject: Re: [PATCH] this mutex_lock is miss used
Message-ID: <20090419153228.GU26366@ZenIV.linux.org.uk>
References: <20090419140355.GA16609@helight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090419140355.GA16609@helight>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19, 2009 at 10:03:55PM +0800, Zhenwen Xu wrote:
> 
> This mutex_lock and mutex_unlock has no use in such way.

Incorrect.  They delay sending response until we are out of audit_receive().

> It should be like this way:

No, it should not.  In particular, it should *NOT* be held while sending
these packets.
