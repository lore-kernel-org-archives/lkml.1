Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZFEKpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZFEKpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 06:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZFEKp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 06:45:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44754 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbZFEKpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 06:45:25 -0400
Date: Fri, 5 Jun 2009 06:45:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/9] exec_path 1/9: introduce ->exec_path and switch
	/proc/*/exe
Message-ID: <20090605104517.GA11713@infradead.org>
References: <20090526113618.GJ28083@us.ibm.com> <20090526162415.fb9cefef.akpm@linux-foundation.org> <20090531215427.GA29534@x200.localdomain> <20090531151953.8f8b14b5.akpm@linux-foundation.org> <20090603230422.GB853@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603230422.GB853@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 03:04:22AM +0400, Alexey Dobriyan wrote:
> ->exec_path is copied on clone(2) and put at do_exit() time.
> 
> ->exec_path is going to replace struct mm_struct::exe_file et al
> and allows to remove VM_EXECUTABLE flag while keeping readlink("/proc/*/exe")
> without loop over all VMAs.

Why don't you leave it in mm_struct?  That'll avoid having to mess with
it in clone, and given that exec always replaces the whole VM it's a
more natural fit anyway.

But yeah, a path seems much more suitable than keeping a file.
