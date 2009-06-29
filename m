Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbZF2NqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbZF2NqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 09:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbZF2Npx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 09:45:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38742 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbZF2Npw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 09:45:52 -0400
Subject: Re: [PATCH] fs: allow d_instantiate to be called with negative
 parent dentry
From: Eric Paris <eparis@redhat.com>
To: Jeremy Kerr <jk@ozlabs.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, cbe-oss-dev@ozlabs.org
In-Reply-To: <1246257118.265649.273423097532.1.gpush@pingu>
References: <1246257118.265649.273423097532.1.gpush@pingu>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 09:45:43 -0400
Message-Id: <1246283143.754.16.camel@dhcp235-23.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-29 at 14:31 +0800, Jeremy Kerr wrote:
> The new fsnotify infrastructure (starting at 90586523) causes an oops in
> spufs, where we populate a directory with files before instantiating the
> directory itself. The new changes seem to have introduced an assumption
> that a dentry's parent will be positive when instantiating.
> 
> This change makes it once again possible to d_instantiate a dentry
> with a negative parent, and brings __fsnotify_d_instantiate() into
> line with inotify_d_instantiate(), which already has this NULL check.
> 
> Signed-off-by: Jeremy Kerr <jk@ozlabs.org>

This problem was introduced based on a private off list comment from Al
Viro back on Feb 17th when he was reviewing my code:

fsnotify_d_instantiate(): check for NULL inode in parent?  Really?
BTW, where's the codepath without that stuff?  I mean, for sane
boxen that have *notify configured out.  Idiotify is at least
configurable away...

>From that comment I dropped the check for dentry->d_parent->d_inode.
The old behavior (which inotify had) is exactly what you propose and
would cause no problems for anything.  I'll leave it up to Al if he
wants to argue that the spufs logic is illegal but I'll put this patch
into my tree and send it toward Linus.

-Eric

