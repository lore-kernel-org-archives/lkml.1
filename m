Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbZCYT1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbZCYT1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 15:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbZCYT1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 15:27:12 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:45497 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbZCYT1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:27:11 -0400
Date: Wed, 25 Mar 2009 13:26:53 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Add a 'wait-scan' command to /proc/scsi/scsi.
Message-ID: <20090325192653.GS14127@parisc-linux.org>
References: <1238007647-25752-1-git-send-email-notting@redhat.com> <20090325190137.GA8509@infradead.org> <20090325190321.GB25176@nostromo.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325190321.GB25176@nostromo.devel.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 03:03:21PM -0400, Bill Nottingham wrote:
> Then where is a better place to put this, as scsi_wait_scan.ko is
> a ridiculous interface for userspace?

It would be nice if people would comment on "ridiculous interface"s when
they're asked for feedback, instead of waiting more than two years.

I think you're misunderstanding how to use scsi_wait_scan.  The idea was
that the bit of userspace that probes all the device drivers would do:

modprobe fusion.ko
modprobe aic79xx.ko
modprobe sym53c8xx.ko
modprobe scsi_wait_scan
rmmod scsi_wait_scan

et voila, you're done.  It seems like you want random other bits of
userspace to wait for scsi scanning to be done, and that wasn't the
original intent.


I suppose we could add Yet Another Damn Sysfs File, say
/sys/bus/scsi/wait_scan

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
