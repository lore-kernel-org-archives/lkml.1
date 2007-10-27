Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbXJ0JfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbXJ0JfW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 05:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbXJ0JfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 05:35:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47159 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbXJ0JfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 05:35:03 -0400
Subject: Networked filesystems vs backing_dev_info
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, sfrench@samba.org,
       jaharkes@cs.cmu.edu, Andrew Morton <akpm@linux-foundation.org>,
       vandrove@vc.cvut.cz
Content-Type: text/plain
Date: Sat, 27 Oct 2007 11:34:26 +0200
Message-Id: <1193477666.5648.61.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I had me a little look at bdi usage in networked filesystems.

 NFS, CIFS, (smbfs), AFS, CODA and NCP

And of those, NFS is the only one that I could find that creates
backing_dev_info structures. The rest seems to fall back to
default_backing_dev_info.

With my recent per bdi dirty limit patches the bdi has become more
important than it has been in the past. While falling back to the
default_backing_dev_info isn't wrong per-se, it isn't right either. 

Could I implore the various maintainers to look into this issue for
their respective filesystem. I'll try and come up with some patches to
address this, but feel free to beat me to it.

peterz

