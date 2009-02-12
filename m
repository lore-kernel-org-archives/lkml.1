Return-Path: <linux-kernel-owner+w=401wt.eu-S1758933AbZBLL1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933AbZBLL1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 06:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758547AbZBLL1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 06:27:16 -0500
Received: from fogou.chygwyn.com ([195.171.2.24]:43898 "EHLO fogou.chygwyn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758825AbZBLL1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 06:27:14 -0500
Date: Thu, 12 Feb 2009 11:22:20 +0000
From: steve@chygwyn.com
To: Kirill Kuvaldin <kirill.kuvaldin@gmail.com>
Cc: linux-cluster@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: GFS2 file locking issues
Message-ID: <20090212112220.GA29185@fogou.chygwyn.com>
References: <2d42915c0902110255k3c0741a9s6830765bce6be052@mail.gmail.com> <20090211133648.GA10273@fogou.chygwyn.com> <2d42915c0902110637o2c0a88c7h72b280b972a6162e@mail.gmail.com> <20090211171816.GA14516@fogou.chygwyn.com> <2d42915c0902110957i6c2f645cyfda572a64f19de64@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d42915c0902110957i6c2f645cyfda572a64f19de64@mail.gmail.com>
Organization: ChyGwyn Limited
X-Registered-Office: Digital Technium, Singleton Park, Swansea. SA2 8PP
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Feb 11, 2009 at 08:57:12PM +0300, Kirill Kuvaldin wrote:
> On Wed, Feb 11, 2009 at 8:18 PM,  <steve@chygwyn.com> wrote:
> > cat /proc/mounts
> 
> /dev/mapper/gfsc-lvol0 /gfs2 gfs2 rw,hostdata=jid=0:id=720897:first=1 0 0
> 
> I also tried mounting explicitly specifying lockproto=lock_dlm, but it
> didn't help.
> 
> Is my understanding of locking correct after all? Is that the case if
> the process makes flock on a file, no other processes including ones
> running on other cluster nodes could obtain a lock until the first
> writer releases it?
>
Yes, thats how it is supposed to work.
 
> >
> > It should be listed in the options. That will also tell you if localflocks
> > has been set as well. We do know of a bug in the GFS/GFS2 flock code though,
> > it ought to be using an interruptible wait and it doesn't at the moment.
> > Otherwise I don't know of any other issues.
> >
> > Which kernel version are you using?
> 
> 2.6.18-92.el5xen (from CentOS 5.2)
> 
> 
> Kirill

The CentOS 5.2 kernel is rather old[*], I'd suggest using a
more recent kernel and gfs2-utils. Either something derrived
from a recent upstream (Linus) kernel such as Fedora, or
5.3 and upwards for CentOS. It might not cure this specific
issue, but it will cure a lot of other issues which you might
run across,

Steve.

[*] It was not an officially supported feature even in Red Hat
Enterprise Linux of the same version number. As a result any
bugs found have been fixed in 5.3 and up, rather than in 5.2
update releases.


