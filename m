Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760173AbYLQJku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbYLQJku (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 04:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760064AbYLQJkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 04:40:25 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43842 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760032AbYLQJkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 04:40:22 -0500
Date: Wed, 17 Dec 2008 09:40:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: James Morris <jmorris@namei.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/15] sanitize AUDIT_MQ_SENDRECV
Message-ID: <20081217094015.GD28946@ZenIV.linux.org.uk>
References: <E1LCohe-0000C7-TH@ZenIV.linux.org.uk> <alpine.LRH.1.10.0812171839080.22856@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.1.10.0812171839080.22856@tundra.namei.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 06:40:54PM +1100, James Morris wrote:
> On Wed, 17 Dec 2008, Al Viro wrote:
> 
> > 
> > * logging the original value of *msg_prio in mq_timedreceive(2)
> >   is insane - the argument is write-only (i.e. syscall always
> >   ignores the original value and only overwrites it).
> 
> I wonder if any existing certifications need to be amended.

I rather doubt it, but I really don't know the bureaucracy of that.
Just to clarify:
	Old code logs the value of *msg_prio; that value is always
ignored by syscall (it may store something there, but that's it -
pure output parameter)
	New code does not change the format of log message; the value
in that field of the message is replaced with 0.  That's the only
difference.

Whether that requires amending of the existing certs... bugger if I know.
