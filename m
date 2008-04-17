Return-Path: <linux-kernel-owner+w=401wt.eu-S933568AbYDQL7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568AbYDQL7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 07:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbYDQL7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 07:59:08 -0400
Received: from verein.lst.de ([213.95.11.210]:54002 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbYDQL7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 07:59:07 -0400
Date: Thu, 17 Apr 2008 13:58:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: swhiteho@redhat.com
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 36/48] [GFS2] fix file_system_type leak on gfs2meta mount
Message-ID: <20080417115848.GA8642@lst.de>
References: <12084216241802-git-send-email-swhiteho@redhat.com> <12084216262937-git-send-email-swhiteho@redhat.com> <12084216281152-git-send-email-swhiteho@redhat.com> <12084216301107-git-send-email-swhiteho@redhat.com> <12084216323165-git-send-email-swhiteho@redhat.com> <1208421634101-git-send-email-swhiteho@redhat.com> <12084216372363-git-send-email-swhiteho@redhat.com> <12084216391215-git-send-email-swhiteho@redhat.com> <12084216402644-git-send-email-swhiteho@redhat.com> <12084216431261-git-send-email-swhiteho@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12084216431261-git-send-email-swhiteho@redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 09:39:12AM +0100, swhiteho@redhat.com wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> get_gfs2_sb does a get_fs_type without doing a put_filesystem and
> thus leaking a file_system_type reference everytime it's called.
> 
> Just use gfs2_fs_type directly instead of doing the lookup and thus
> fix the problem.

Btw, after this patch we should remove the get_fs_type export.  It's
not used by modules and because put_filesystem is not exported every
modular user would fundamentally have the same leak as the one fixed in
this patch.

