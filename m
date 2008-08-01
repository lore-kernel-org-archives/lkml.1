Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbYHATfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbYHATfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 15:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbYHATfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 15:35:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47013 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbYHATfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 15:35:32 -0400
Date: Fri, 1 Aug 2008 20:35:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Containers <containers@lists.osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: Per-instance devpts
Message-ID: <20080801193505.GS28946@ZenIV.linux.org.uk>
References: <20080412172933.GA19295@us.ibm.com> <1208027215.28187.17.camel@x61.ebiederm.org> <48935205.3090807@zytor.com> <1217618624.20260.50.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217618624.20260.50.camel@nimitz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 12:23:44PM -0700, Dave Hansen wrote:
> On Fri, 2008-08-01 at 11:12 -0700, H. Peter Anvin wrote:
> > 1. /dev/ptmx would have to change to a symlink, ptmx -> pts/ptmx.
> ...
> > I worry #1 would have substantial user-space impact, but I don't see a 
> > way around it, since there would be no obvious way to associate 
> > /dev/ptmx with a filesystem.
> 
> Are your worries just about replacing what is now a normal file with a
> symlink, and the behavioral changes that come with that?  
> 
> I wonder if using a bind mount for the file would be more robust.  We
> wouldn't, of course, be able to do it persistently, but I bet it would
> be something we could count on udev to do for us.

Not on my boxen.  However, devpts tends to be mounted by initscripts,
which is where one would naturally do that.
