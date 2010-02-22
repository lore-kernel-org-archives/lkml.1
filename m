Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab0BVRYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 12:24:52 -0500
Received: from adelie.canonical.com ([91.189.90.139]:54603 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab0BVRYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 12:24:50 -0500
Message-ID: <4B82BDDD.9020407@canonical.com>
Date: Mon, 22 Feb 2010 09:24:45 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: john.johansen@canonical.com
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Fix __d_path for lazy unmounts
References: <1266668858-15253-1-git-send-email-john.johansen@canonical.com>
In-Reply-To: <1266668858-15253-1-git-send-email-john.johansen@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john.johansen@canonical.com wrote:
> From: John Johansen <john.johansen@canonical.com>
> 
> When __d_path() hits a lazily unmounted mount point, it tries to prepend
> the name of the lazily unmounted dentry to the path name.  It gets this wrong,
> and also overwrites the slash that separates the name from the following
> pathname component. This patch fixes that; if a process was in directory
> /foo/bar and /foo got lazily unmounted, the old result was ``foobar'' (note the
> missing slash), while the new result with this patch is ``/foo/bar''.
> 
It seems I left out the basic test for this.  From a shell you can do

> mkdir /tmp/foo
> sudo mount --bind /home/jj /tmp/foo   #substitute /home/jj as you wish
> cd /tmp/foo/bar       # assumes /home/jj/bar exists
> /bin/pwd
/tmp/foo/bar
> sudo umount -l /tmp/foo
> /bin/pwd
jjbar
> > cd ..
> > /bin/pwd
jj


