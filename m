Return-Path: <linux-kernel-owner+w=401wt.eu-S1762258AbYDPK1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762258AbYDPK1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 06:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756960AbYDPK1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 06:27:39 -0400
Received: from yw-out-2122.google.com ([74.125.46.25]:63187 "EHLO
	yw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbYDPK1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 06:27:39 -0400
MIME-Version: 1.0
Message-ID: <da08e304-eb95-4ace-a069-de1a57b86e9f@e39g2000hsf.googlegroups.com>
Date: Wed, 16 Apr 2008 03:27:26 -0700 (PDT)
In-Reply-To: <ajcri-65w-13@gated-at.bofh.it>
X-IP: 86.53.68.233
References: <ajbvb-3Ur-21@gated-at.bofh.it> <ajcri-65w-13@gated-at.bofh.it>
User-Agent: G2/1.0
X-HTTP-UserAgent: Mozilla/5.0 (X11; U; x86_64 Linux; en_GB; rv:1.8.0.4) 
	Gecko/20060508 Firefox/1.5.0.4,gzip(gfe),gzip(gfe)
Subject: Re: RFC: Self-snapshotting in Linux
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: Ben Nizette <bn@niasdigital.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Nizette wrote:
> On Wed, 2008-04-16 at 16:44 +0800, Peter Teoh wrote:
> > Essentially, to reiterate the key idea:   able to snapshot the current
> > kernel+userspace permanent.....restore from another snapshot....and
> > then switch back again if needed etc.....will the implementation be
> > difficult...if not impossible????
> >
>
> As I see it the main thing is that VMWare doesn't have to worry about
> trying to put hardware in to (and pull out of) low power modes.  VMWare
> hardware is never left in an undefined state by poorly written drivers
> etc.
>
> I think hibernation is about what you want; snapshotting as you describe
> it should fall down for about the same reasons

I guess there is the hardware / drivers issue.  I would like to claim
I've found hibernation to be reliable but unfortunately that's not
100% true.  As you say, that's inherent to snapshotting on
unvirtualised hardware - calling it snapshotting instead of
hibernation wouldn't change anything.

I think VMware's real advantages are more about management and
convenience.
1) Disk virtualisation.  It's much more convenient to create a VMware
image than a new linux partition.   Linux will let you use disk images
on a filesystem using the loopback driver, but that tends not to be
well supported by installers.  wubi[1] is the obvious counterexample
here.
2) Linux hibernation does the in-memory snapshot OK, but the
*filesystem* obviouslly isn't a part of that snapshot.  In some
unfortunate circumstances, you can end up resuming a memory image
which is not consistent with the filesystem and corrupting it.
IMHO filesystems need to include a "last modified" timestamp and check
it on resume.

[1] http://wubi-installer.org/
