Return-Path: <linux-kernel-owner+w=401wt.eu-S934990AbZDCQWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934990AbZDCQWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764359AbZDCQWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 12:22:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46672 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764869AbZDCQWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 12:22:36 -0400
Date: Fri, 3 Apr 2009 09:22:17 -0700
From: Chris Wright <chrisw@redhat.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Izik Eidus <ieidus@redhat.com>, Chris Wright <chrisw@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, linux-mm@kvack.org, avi@redhat.com,
       riel@redhat.com, jeremy@goop.org, mtosatti@redhat.com, hugh@veritas.com,
       corbet@lwn.net, yaniv@redhat.com, dmonakhov@openvz.org
Subject: Re: [PATCH 5/4] update ksm userspace interfaces
Message-ID: <20090403162217.GB13121@x200.localdomain>
References: <49D23CD1.9090208@codemonkey.ws> <20090331162525.GU9137@random.random> <49D24A02.6070000@codemonkey.ws> <20090402012215.GE1117@x200.localdomain> <49D424AF.3090806@codemonkey.ws> <20090402053114.GF1117@x200.localdomain> <49D4BE64.8020508@redhat.com> <49D5E1EE.6030707@redhat.com> <49D5E9B5.1020101@redhat.com> <49D5EE1F.4060009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D5EE1F.4060009@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gerd Hoffmann (kraxel@redhat.com) wrote:
> mmput() call was in ->release() callback, ->release() in turn never was
> called because the kernel didn't zap the mappings because of the
> reference ...

Don't have this issue.  That mmput() is not tied to zapping mappings,
rather zapping files.  IOW, I think you're saying exit_mmap() wasn't
running due to your get_task_mm() (quite understandable, you still hold
a ref), whereas this ref is tied to exit_files().

So do_exit would do:

	exit_mm
	  mmput <-- not dropped yet
	exit_files
	  ->release
	    mmput <-- dropped here

thanks,
-chris
