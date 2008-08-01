Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbYHASmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbYHASmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbYHASmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:42:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41866 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbYHASmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:42:14 -0400
Message-ID: <48935205.3090807@zytor.com>
Date: Fri, 01 Aug 2008 11:12:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: sukadev@us.ibm.com, Andrew Morton <akpm@osdl.org>, serue@us.ibm.com,
       matthltc@us.ibm.com, Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>
Subject: Per-instance devpts
References: <20080412172933.GA19295@us.ibm.com> <1208027215.28187.17.camel@x61.ebiederm.org>
In-Reply-To: <1208027215.28187.17.camel@x61.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the issue of PTY namespaces came up (and was rejected) back in 
April, I have thought a little bit about changing ptys to be tied 
directly into a devpts instance.  devpts would then be a "normal" 
filesystem, which can be mounted multiple times (or not at all).  pty's 
would then become private to a devpts instance.

This is what it would appear would have to change, and I'd like to get 
people's feeing for the user-space impact:

1. /dev/ptmx would have to change to a symlink, ptmx -> pts/ptmx.
2. Permissions on /dev/ptmx would not be persistent, and would have to
    be set via devpts mount options (unless they're 0666 root.tty, which
    would presumably be the default.)
3. The /proc/sys/kernel/pty limit would be global; a per-filesystem
    limit could be added on top or instead (presumably via a filesystem
    mount options.)

I worry #1 would have substantial user-space impact, but I don't see a 
way around it, since there would be no obvious way to associate 
/dev/ptmx with a filesystem.

	-hpa
