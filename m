Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbZIUIUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbZIUIUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 04:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbZIUIUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 04:20:07 -0400
Received: from mail2.shareable.org ([80.68.89.115]:34813 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbZIUIUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 04:20:06 -0400
Date: Mon, 21 Sep 2009 09:20:09 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org
Subject: Re: [PATCH] vfs: new FROM_ACCESS flag
Message-ID: <20090921082008.GB20006@shareable.org>
References: <20090921013048.2763.1494.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921013048.2763.1494.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> This new acc_mode flag is just to tell the security system this
> inode permission check is from the access system call.  The security
> system can use this information as it finds appropriete.  In
> particular SELinux plans to use this flag to alter what we choose to
> audit and what we do not choose to audit.

Does "as it finds appropriate" mean robust applications should try an
operation anyway even if access() says no from now on?

Btw, since you're looking at access(), the kernel could do with
euidaccess() or a flag ACCESS_EUID.  (Either would be trivial to implement).

Glibc provides eaccess/euidaccess functions, but they work by calling
stat() and checking the mode bits when euid != ruid || egid != rgid,
which is clearly not very nice with ACLs, and perhaps not ideal for
SELinux's auditing of access calls either.

-- Jamie
