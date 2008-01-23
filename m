Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395AbYAXRGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbYAXRGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759570AbYAXRDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 12:03:34 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4056 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759549AbYAXRDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 12:03:32 -0500
Date: Wed, 23 Jan 2008 20:59:30 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Cedric Le Goater <clg@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 1/2] Extend sys_clone and sys_unshare system calls API
Message-ID: <20080123205930.GA5233@ucw.cz>
References: <478DFF8F.9030006@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478DFF8F.9030006@openvz.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-01-16 15:58:55, Pavel Emelyanov wrote:
> There's only one bit in the clone_flags left, so we won't be able 
> to create more namespaces after we make it busy. Besides, for 
> checkpoint/restart jobs we might want to create tasks with given
> pids (virtual of course). And nobody knows for sure what else might 
> be required from clone() in the future.
> 
> This is an attempt to create a extendable API for clone and unshare.
> Actually this patch is a request for comment about the overall
> design. If it will turn out to "look good", then we'll select some
> better names for new flag and data types.
> 
> I use the last bit in the clone_flags for CLONE_LONGARG. When set it
> will denote that the child_tidptr is not a pointer to a tid storage,
> but the pointer to the struct long_clone_struct which currently 
> looks like this:
> 
> struct long_clone_arg {
> 	int size;
> };

Ugly as night, I'd say. (Al said it better). What about just adding
clone2 syscall, that takes u64?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
