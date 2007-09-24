Return-Path: <linux-kernel-owner+w=401wt.eu-S1760631AbXIXRFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760631AbXIXRFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761757AbXIXRE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:04:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761442AbXIXREz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:04:55 -0400
Date: Mon, 24 Sep 2007 13:04:39 -0400
From: Dave Jones <davej@redhat.com>
To: Antoine Martin <antoine@nagafix.co.uk>
Cc: tytso@thunk.org, Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: bug in fsck or ext2/ext3?
Message-ID: <20070924170439.GF8127@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Antoine Martin <antoine@nagafix.co.uk>, tytso@thunk.org,
	Linux Kernel Development <linux-kernel@vger.kernel.org>
References: <46F7EC47.9010803@nagafix.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F7EC47.9010803@nagafix.co.uk>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 05:56:39PM +0100, Antoine Martin wrote:

 > I've got this snapshot of an ext3 filesystem with a directory that
 > simply cannot be removed! (image below is just 1.2MB)
 > As root:
 > # wget http://users.nagafix.co.uk/~antoine/root-broken.bz2
 > # bunzip2 root-broken.bz2
 > # mount -o loop -t ext2 root-broken ./tmp
 > # rm -fr tmp/chroot.broken
 > rm: cannot remove directory (...)
 > Same result when trying to do anything to those files chown/chmod/touch:
 > "Operation not permitted"
 > 
 > Tested with e2fsprogs v1.39 on 3 systems.
 > Not sure where else to post this...

Various files in the directories it complains about have their 'i'
bit set.  lsattr will show you.   chattr -i those files, and the
directory is removable again.

	Dave

-- 
http://www.codemonkey.org.uk
