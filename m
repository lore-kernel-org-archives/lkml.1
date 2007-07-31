Return-Path: <linux-kernel-owner+w=401wt.eu-S1758797AbXGaWWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797AbXGaWWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758865AbXGaWV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:21:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334AbXGaWV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:21:57 -0400
Date: Wed, 1 Aug 2007 00:21:41 +0200
From: Karel Zak <kzak@redhat.com>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, sfrench@samba.org,
       trond.myklebust@fys.uio.no, mark.fasheh@oracle.com,
       kurt.hackel@oracle.com
Subject: Re: request for patches: showing mount options
Message-ID: <20070731222141.GB3180@petra.dvoda.cz>
References: <E1IEQ7q-0000qE-00@dorka.pomaz.szeredi.hu> <46AA4AC5.2050200@oracle.com> <E1IEW21-0001kL-00@dorka.pomaz.szeredi.hu> <46AA51CA.7030105@oracle.com> <E1IEezF-0002g6-00@dorka.pomaz.szeredi.hu> <46AE01C2.3000008@oracle.com> <E1IFnSa-0002BL-00@dorka.pomaz.szeredi.hu> <46AF450D.5020106@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AF450D.5020106@oracle.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 10:19:57AM -0400, Chuck Lever wrote:
> The removal of /etc/mtab in favor of /proc/mounts is a new requirement, 
> and is not as trivial as you might hope.  Internally the NFS client 
> represents the mount options as a binary data structure, and it contains 
> only the information that has traditionally been passed into the kernel 
> by the current mount command.  The user-space-only options are not 
> passed to the kernel nor stored in the data structure.
> 
> Adding facilities to store information about every possible mount 
> option, including the user-space-only ones, will take a bit of time, but 
> is possible, if not straightforward.  We just have to understand all the 
> dependencies.

 I still have doubts. The removal of /etc/mtab is nice, but a little
 unreal wish. Do we really want to store non-kernel data (options) in
 kernel? What about options that are not closely related to any
 filesystem -- for example "loop="?

 Maybe we can replace /etc/mtab with something more useful
 (e.g. /var/run/mount/<mntid>.tab) for really user-space-only information.

 It doesn't mean that Miklos's audit of all filesystems and request
 for patches is bad thing. The /proc/mounts has to provide complete
 information at least about kernel mount options.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
