Return-Path: <linux-kernel-owner+w=401wt.eu-S1760416AbZDBBWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760416AbZDBBWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 21:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbZDBBWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 21:22:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39609 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbZDBBWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 21:22:31 -0400
Date: Wed, 1 Apr 2009 18:22:15 -0700
From: Chris Wright <chrisw@redhat.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, chrisw@redhat.com, riel@redhat.com, jeremy@goop.org,
       mtosatti@redhat.com, hugh@veritas.com, corbet@lwn.net, yaniv@redhat.com,
       dmonakhov@openvz.org
Subject: Re: [PATCH 4/4] add ksm kernel shared memory driver.
Message-ID: <20090402012215.GE1117@x200.localdomain>
References: <49D20B63.8020709@redhat.com> <49D21B33.4070406@codemonkey.ws> <20090331142533.GR9137@random.random> <49D22A9D.4050403@codemonkey.ws> <20090331150218.GS9137@random.random> <49D23224.9000903@codemonkey.ws> <20090331151845.GT9137@random.random> <49D23CD1.9090208@codemonkey.ws> <20090331162525.GU9137@random.random> <49D24A02.6070000@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D24A02.6070000@codemonkey.ws>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Anthony Liguori (anthony@codemonkey.ws) wrote:
> The ioctl() interface is quite bad for what you're doing.  You're  
> telling the kernel extra information about a VA range in userspace.   
> That's what madvise is for.  You're tweaking simple read/write values of  
> kernel infrastructure.  That's what sysfs is for.

I agree re: sysfs (brought it up myself before).  As far as madvise vs.
ioctl, the one thing that comes from the ioctl is fops->release to
automagically unregister memory on exit.  This needs to be handled
anyway if some -p pid is added to add a process after it's running,
so less weight there.

thanks,
-chris
