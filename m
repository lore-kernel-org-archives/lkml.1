Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbZDABo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbZDABo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 21:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbZDABoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 21:44:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47485 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521AbZDABon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 21:44:43 -0400
Date: Wed, 1 Apr 2009 03:40:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       adobriyan@gmail.com, dhowells@redhat.com, ebiederm@xmission.com,
       hch@lst.de
Subject: Re: + mm-remove-struct-mm_struct-exe_file-et-al.patch added to -mm
	tree
Message-ID: <20090401014037.GA32051@redhat.com>
References: <200903302344.n2UNi3xd027136@imap1.linux-foundation.org> <20090331144051.GA3951@redhat.com> <20090401003223.GH29821@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401003223.GH29821@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31, Matt Helsley wrote:
>
> On Tue, Mar 31, 2009 at 04:40:51PM +0200, Oleg Nesterov wrote:
> >
> > But, as a advocatus diaboli... There was anotrher reason for ->exe_file,
> > iirc.
> >
> > bprm->file->f_op->mmap() can change vma->vm_file, this means proc_exe_link()
> > can report the "wrong" path. The original file is not pinned in this case.
>
> That's _my_ reason for it. However no mainline code does that and hence it was
> not the reason Andrew accepted it.

Good.

> I still prefer ->exe_file because I think it's a win not to walk the
> VMAs with mmap sem when doing a readlink on /proc/*/exe. It's also less
> sensitive to the order in which VMAs appear should that ever change.

I agree with Alexey, I don't think the VMAs walking can be a problem.

But even if it is problem, we could make a much more simple patch
to avoid it? Just add "struct path exe_path" to ->mm, no?

Oleg.

