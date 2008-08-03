Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbYHCFKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbYHCFKY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 01:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbYHCFKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 01:10:08 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45384 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbYHCFKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 01:10:07 -0400
Date: Sat, 2 Aug 2008 22:08:00 -0700
From: sukadev@us.ibm.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@osdl.org>,
       serue@us.ibm.com, matthltc@us.ibm.com,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       sukadev@us.ibm.com
Subject: Re: Per-instance devpts
Message-ID: <20080803050800.GA4322@us.ibm.com>
References: <20080412172933.GA19295@us.ibm.com> <1208027215.28187.17.camel@x61.ebiederm.org> <48935205.3090807@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48935205.3090807@zytor.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin [hpa@zytor.com] wrote:
> Since the issue of PTY namespaces came up (and was rejected) back in April, 
> I have thought a little bit about changing ptys to be tied directly into a 
> devpts instance.  devpts would then be a "normal" filesystem, which can be 
> mounted multiple times (or not at all).  pty's would then become private to 
> a devpts instance.

Sorry, I thought we were going with a complete device namespace - since that
would address other devices as well and would avoid the following user-space
issue. 

I guess this issue came up in OLS recently and have been looking into this
again.  I have some helper patches to explore multiple mounts of devpts
without namespace stuff and can send them out in a couple of days.

>
> This is what it would appear would have to change, and I'd like to get 
> people's feeing for the user-space impact:
>
> 1. /dev/ptmx would have to change to a symlink, ptmx -> pts/ptmx.

IIRC, /dev/tty also needs a similar symlink.

> 2. Permissions on /dev/ptmx would not be persistent, and would have to
>    be set via devpts mount options (unless they're 0666 root.tty, which
>    would presumably be the default.)
> 3. The /proc/sys/kernel/pty limit would be global; a per-filesystem
>    limit could be added on top or instead (presumably via a filesystem
>    mount options.)
>
> I worry #1 would have substantial user-space impact, but I don't see a way 
> around it, since there would be no obvious way to associate /dev/ptmx with 
> a filesystem.

Sukadev
