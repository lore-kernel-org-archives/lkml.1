Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbXEPHLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbXEPHLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 03:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbXEPHLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 03:11:03 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44231 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639AbXEPHLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 03:11:01 -0400
Date: Wed, 16 May 2007 08:10:54 +0100
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: akpm@osdl.org, nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, dchinner@sgi.com
Subject: Re: [PATCH 2/2] AFS: Implement shared-writable mmap
Message-ID: <20070516071054.GA14222@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>, akpm@osdl.org,
	nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dchinner@sgi.com
References: <20070515155224.29345.22719.stgit@warthog.cambridge.redhat.com> <20070515155231.29345.6212.stgit@warthog.cambridge.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515155231.29345.6212.stgit@warthog.cambridge.redhat.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 04:52:31PM +0100, David Howells wrote:
> +int afs_page_mkwrite(struct vm_area_struct *vma, struct page *page)
> +{
> +	struct afs_vnode *vnode = AFS_FS_I(vma->vm_file->f_mapping->host);
> +	struct key *key = vma->vm_file->private_data;
> +	int ret;
> +
> +	_enter("{{%x:%u},%x},{%lx}",
> +	       vnode->fid.vid, vnode->fid.vnode, key_serial(key), page->index);
> +
> +	lock_page(page);
> +	ret = afs_prepare_write(vma->vm_file, page, 0, 0);
> +	unlock_page(page);
> +
> +	_leave(" = %d", ret);
> +	return ret;
> +}

It looks like you really want Dave's generic page_mkwrite.  And we should
really get that one merged for 2.6.22.

