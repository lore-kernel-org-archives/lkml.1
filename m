Return-Path: <linux-kernel-owner+w=401wt.eu-S1765696AbXJSMkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765696AbXJSMkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 08:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757507AbXJSMj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 08:39:56 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:45867 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886AbXJSMjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 08:39:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BXUbqgkQhtWF3RTUoRsTzRVNhrhWcLQBpqzygpJmFD4yUhNCn4rsQ4EN0zThr3OrB3OFN+PwVpTesXGSOYFO2EyRTOx+dItJJDrv/EkI5+2/EpOrNSUIzD1hObDaAvXplyPWJ48O3ouFf7OozjUuwQ488hc+4D9WtlZDzME6UvQ=
Message-ID: <1865922a0710190539j4eec697dmffeb7c97b9601c63@mail.gmail.com>
Date: Fri, 19 Oct 2007 14:39:48 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Version 8 (2.6.23) Smack: Simplified Mandatory Access Control Kernel
Cc: "Casey Schaufler" <casey@schaufler-ca.com>, torvalds@osdl.org,
       akpm@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071018051031.GN8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47158CE4.30706@schaufler-ca.com>
	 <20071018045705.GM8181@ftp.linux.org.uk>
	 <20071018051031.GN8181@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> On Thu, Oct 18, 2007 at 05:57:05AM +0100, Al Viro wrote:
> > On Tue, Oct 16, 2007 at 09:17:40PM -0700, Casey Schaufler wrote:
>
> > Think what happens if CPU1 adds to list and CPU2 sees write to smk_known
> > *before* it sees write to ->smk_next.  We see a single-element list and
> > we'll be lucky if that single entry won't be FUBAR.
>
> While we are at it, what protects smack_cipso_count?
> -

My fault. I sent to Casey a one-liner patch to make "smack_cipso_count++"
be protected by the smk_cipsolock spinlock.

We don't need a lock in the reading side since we don't do a write operation
depending on that read, right ?.

-- 
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
