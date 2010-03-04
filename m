Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0CDNwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 08:52:37 -0500
Received: from fn.samba.org ([216.83.154.106]:45385 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab0CDNwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 08:52:36 -0500
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Mar 2010 08:52:36 EST
Subject: Re: [linux-cifs-client] [RFC PATCH] CIFS posix acl permission
 checking
From: simo <idra@samba.org>
To: Jon Severinsson <jon@severinsson.net>
Cc: linux-cifs-client@lists.samba.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <201003041150.08341.jon@severinsson.net>
References: <201003041150.08341.jon@severinsson.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Samba Team
Date: Thu, 04 Mar 2010 08:44:22 -0500
Message-ID: <1267710262.2375.280.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 11:50 +0100, Jon Severinsson wrote:
> Hello
> 
> Early this weak I sent a patch implementing posix acl permission checking in 
> the linux cifs filesystem module. Unfortunately I only sent it to linux-fsdev 
> as I was unaware of the linux-cifs-client list. I later tried to submit it to 
> linux-cifs-client as well, but my message seems to have been lost in the 
> moderation queue, so I subscribed and am trying again.
> 
> I don't believe my patch is perfect, but I think it's a good start, and would 
> like some comments from more experienced cifs developers to be able to get it 
> into shape for inclusion in the kernel. 
> 
> I did get some comments from Matthew Wilcox at linux-fsdev, but unfortunately 
> he never followed up on my response, so I'm including some unresolved 
> questions I still have, as well as attaching the patch for further comments.

Hi Jon,
although you did a good job with the code itself, I have to say that I
think the approach is just wrong. Checking ACLs on the client is simply
the wrong way to go. It is just racy and it is not authoritative anyway.

It is like trying to look up a path using a cached directory listing and
then try to open by inode. It simply doesn't work, by the time you do
that, things may have been completely changed on the server.

And we are not counting the problem that with CIFS (and samba in
particular) the client have no way to know what are the real credentials
assigned to the session and that the client may have no idea what the
users and groups in the ACL are (if client and server do not use exactly
the same user database).

The right way is to let the server enforce ACLs, and use multisessions
mounts if multiple users are involved. Time would be better spent
working in that direction IMO.

Simo.

-- 
Simo Sorce
Samba Team GPL Compliance Officer <simo@samba.org>
Principal Software Engineer at Red Hat, Inc. <simo@redhat.com>

