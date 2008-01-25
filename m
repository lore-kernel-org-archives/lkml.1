Return-Path: <linux-kernel-owner+w=401wt.eu-S1756351AbYAYQnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbYAYQnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 11:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754101AbYAYQnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 11:43:14 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52956 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753600AbYAYQnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 11:43:12 -0500
Date: Fri, 25 Jan 2008 11:42:29 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, linux-ext4@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] ext3 freeze feature
Message-ID: <20080125164229.GD17907@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	Takashi Sato <t-sato@yk.jp.nec.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080125195938t-sato@mail.jp.nec.com> <20080125121851.GA3361@dmon-lap.sw.ru> <20080125133329.GB8184@mit.edu> <479A0F91.2030206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479A0F91.2030206@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 10:34:25AM -0600, Eric Sandeen wrote:
> > But it was this concern which is why ext3 never exported freeze
> > functionality to userspace, even though other commercial filesystems
> > do support this.  It wasn't that it wasn't considered, but the concern
> > about whether or not it was sufficiently safe to make available.
> 
> What's the safety concern; that the admin will forget to unfreeze?

That the admin would manage to deadlock him/herself and wedge up the
whole system...

> I'm also not sure I see the point of the timeout in the original patch;
> either you are done snapshotting and ready to unfreeze, or you're not;
> 1, or 2, or 3 seconds doesn't really matter.  When you're done, you're
> done, and you can only unfreeze then.  Shouldn't this be done
> programmatically, and not with some pre-determined timeout?

This is only a guess, but I suspect it was a fail-safe in case the
admin did manage to deadlock him/herself.  

I would think a better approach would be to make the filesystem
unfreeze if the file descriptor that was used to freeze the filesystem
is closed, and then have explicit deadlock detection that kills the
process doing the freeze, at which point the filesystem unlocks and
the system can recover.

					- Ted
