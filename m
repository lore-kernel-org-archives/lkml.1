Return-Path: <linux-kernel-owner+w=401wt.eu-S1754933AbXINK0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbXINK0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 06:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXINKZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 06:25:51 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41281 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751010AbXINKZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 06:25:50 -0400
Date: Fri, 14 Sep 2007 20:25:45 +1000
From: Greg Banks <gnb@sgi.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       nfs@lists.sourceforge.net, unionfs@filesystems.org,
       linux-cifs-client@lists.samba.org, ecryptfs-devel@lists.sourceforge.net,
       reiserfs-devel@vger.kernel.org
Subject: Re: [NFS] [PATCH 2/7] NFS: if ATTR_KILL_S*ID bits are set, then skip mode change
Message-ID: <20070914102545.GF21965@sgi.com>
References: <200709041437.l84Eb4lw010007@dantu.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709041437.l84Eb4lw010007@dantu.rdu.redhat.com>
User-Agent: Mutt/1.5.5.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2007 at 10:37:04AM -0400, Jeff Layton wrote:
> If the ATTR_KILL_S*ID bits are set then any mode change is only for
> clearing the setuid/setgid bits. For NFS skip the mode change and
> let the server handle it.

You're assuming the server will remove setuid and setgid bits on WRITE?
I don't see that behaviour specified in the RFC, at least for v3.
The RFC specifies a behaviour for the mtime attribute as a side
effect of WRITE, but says nothing about mode.  This means server
implementations are free to clobber setuid or not.  A quick experiment
shows that at least the Irix server will *NOT* clobber those bits.
So with an Irix server you've now lost this Linux-specific "security
feature".

I'm curious about the reasons behind this change.  You mention
credential issues; how exactly is it that you have the correct creds
to perform a WRITE rpc but not a SETATTR rpc?

Greg.
-- 
Greg Banks, R&D Software Engineer, SGI Australian Software Group.
Apparently, I'm Bedevere.  Which MPHG character are you?
I don't speak for SGI.
