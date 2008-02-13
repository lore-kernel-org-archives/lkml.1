Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbYBMM6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbYBMM6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 07:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760587AbYBMM5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 07:57:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759448AbYBMM5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 07:57:53 -0500
Date: Wed, 13 Feb 2008 07:57:38 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Nix <nix@esperi.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org
Subject: Re: Upgrade to 2.6.24 breaks NFS service
Message-ID: <20080213075738.086f7b32@barsoom.rdu.redhat.com>
In-Reply-To: <20080213021912.b127c4a7.akpm@linux-foundation.org>
References: <87lk5pjkro.fsf@hades.wkstn.nix>
	<20080213021912.b127c4a7.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 02:19:12 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> (cc linux-nfs)
> 
> On Wed, 13 Feb 2008 08:58:03 +0000 Nix <nix@esperi.org.uk> wrote:
> 
> > I upgraded from 2.6.23.10 to 2.6.24.2 yesterday, and found NFS
> > service failing.
> > 
> > To be specific, all locks were blocking forever, with an endless
> > flood of
> > 
> > Feb 12 22:53:10 loki notice: kernel: statd: server localhost not
> > responding, timed out Feb 12 22:53:10 loki notice: kernel: lockd:
> > cannot monitor esperi Feb 12 22:53:45 loki notice: kernel: statd:
> > server localhost not responding, timed out Feb 12 22:53:45 loki
> > notice: kernel: lockd: cannot monitor esperi Feb 12 22:54:20 loki
> > notice: kernel: statd: server localhost not responding, timed out
> > Feb 12 22:54:20 loki notice: kernel: lockd: cannot monitor esperi
> > Feb 12 22:54:55 loki notice: kernel: statd: server localhost not
> > responding, timed out Feb 12 22:54:55 loki notice: kernel: lockd:
> > cannot monitor esperi Feb 12 22:55:20 esperi notice: kernel: lockd:
> > server loki.wkstn.nix not responding, still trying
> > 
> > (esperi is a UML instance on the same machine, connected via a
> > bridged TUN/TAP interface: the bridge, and network service to
> > esperi and to the rest of the local net across that bridge, was
> > fine.)
> > 
> > I'm currently using NFSv3 atop nfs-utils 1.1.0.33-gdd08789, with
> > daemons being started in the suggested order (portmap, mountd, statd
> > --no-notify, nfsd). This evening I'm going to try to upgrade to
> > nfs-utils HEAD and see if this continues.
> > 
> 

If upgrading nfs-utils doesn't help, on this box, could you run:

# rpcinfo -p localhost

send the output? statd expects that lockd will always be listening on a
UDP socket and some changes recently made it so that when there are
only TCP mounts that it doesn't necessarily do so. That may be the
problem here.

-- 
Jeff Layton <jlayton@redhat.com>
