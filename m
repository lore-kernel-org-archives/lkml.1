Return-Path: <linux-kernel-owner+w=401wt.eu-S933417AbZGPVV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417AbZGPVV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 17:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933359AbZGPVV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 17:21:58 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:43515 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933404AbZGPVV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 17:21:58 -0400
Subject: Re: [PATCH 16/20] ceph: nfs re-export support
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Sage Weil <sage@newdream.net>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0907161241300.8026@cobra.newdream.net>
References: <1247693090-27796-8-git-send-email-sage@newdream.net>
	 <1247693090-27796-9-git-send-email-sage@newdream.net>
	 <1247693090-27796-10-git-send-email-sage@newdream.net>
	 <1247693090-27796-11-git-send-email-sage@newdream.net>
	 <1247693090-27796-12-git-send-email-sage@newdream.net>
	 <1247693090-27796-13-git-send-email-sage@newdream.net>
	 <1247693090-27796-14-git-send-email-sage@newdream.net>
	 <1247693090-27796-15-git-send-email-sage@newdream.net>
	 <1247693090-27796-16-git-send-email-sage@newdream.net>
	 <1247693090-27796-17-git-send-email-sage@newdream.net>
	 <20090716192755.GE2495@fieldses.org>
	 <Pine.LNX.4.64.0907161241300.8026@cobra.newdream.net>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 17:21:51 -0400
Message-Id: <1247779311.12292.162.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 3 sum rcpts/h 9 sum msgs/h 3 total rcpts 883 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=_URIID_)
X-UiO-Scanned: DA49A938B43E53DAEF55BD5C20494A052007AF3D
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 3 total 64 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 12:50 -0700, Sage Weil wrote:
> On Thu, 16 Jul 2009, J. Bruce Fields wrote:
> > On Wed, Jul 15, 2009 at 02:24:46PM -0700, Sage Weil wrote:
> > > Basic NFS re-export support is included.  This mostly works.  However,
> > > Ceph's MDS design precludes the ability to generate a (small)
> > > filehandle that will be valid forever, so this is of limited utility.
> > 
> > Is there any hope of fixing that?
> 
> Yes, but it requires some additional ondisk metadata the MDS isn't 
> maintaining yet (a parent directory backpointer on file objects).  
> 
> The MDS changes will mean more random IO for rename intensive workloads, 
> but the backpointers would also be useful for rebuilding the directory 
> tree in the event of some catastrophic metadata loss or corruption.  
> (Currently they're only there for directories, not all files.)

Note that a filehandle that contains parent directory information is
still not one that is valid forever. It will change in the case of a
cross-directory rename, and so isn't a filehandle in the NFSv2/v3 sense.
Even in the NFSv4 case, it would have to be labelled as 'volatile'.

Cheers
    Trond

