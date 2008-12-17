Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759680AbYLQIDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680AbYLQIDa (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 03:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbYLQIDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 03:03:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48383 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbYLQIDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 03:03:19 -0500
Date: Wed, 17 Dec 2008 08:03:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/15] sanitize AUDIT_MQ_SENDRECV
Message-ID: <20081217080315.GZ28946@ZenIV.linux.org.uk>
References: <E1LCohe-0000C7-TH@ZenIV.linux.org.uk> <20081216235656.d7985f1d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216235656.d7985f1d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 11:56:56PM -0800, Andrew Morton wrote:
> > +		if (copy_from_user(&ts, u_abs_timeout, 
> > +					sizeof(struct timespec)))
> 
> Well that's odd.  afacit timespec has different sizes on 32-bit and
> 64-bit userspace.
> 
> But the old audit code did this copy too, and it presumably worked.

compat_mq_timedsend() et.al. essentially do copy_in_user() converting to
64bit and theh call sys_mq_...().  So you get kernel-native layout in
the log.

Similar for notification in compat_mq_notify(), etc.
