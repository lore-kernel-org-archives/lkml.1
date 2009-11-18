Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbZKRI5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbZKRI5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 03:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbZKRI5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 03:57:37 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39540 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbZKRI5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 03:57:36 -0500
Date: Wed, 18 Nov 2009 05:19:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-nfs@vger.kernel.org, ebiederm@xmission.com, adobriyan@gmail.com,
       viro@ZenIV.linux.org.uk, jamie@shareable.org
Subject: Re: [PATCH 0/2] vfs: ensure that dentries are revalidated on open
	(try #2)
Message-ID: <20091118041906.GB1395@ucw.cz>
References: <1257870456-31188-1-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257870456-31188-1-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This is the second attempt to fix this problem. The first one attempted
> to fix this in procfs, but Eric Biederman pointed out that file bind
> mounts have a similar problem. This set attempts to fix the issue at a
> higher level, in the generic VFS layer.
> 
> In certain situations, when it knows that they are valid, the path
> walking code will skip revalidating dentries that it finds in the cache.
> This causes problems with filesystems such as NFSv4 and CIFS that depend
> on the d_revalidate routine to do opens during lookup.

...and it allows bypassing directory permissions. Could we fix both
here?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
