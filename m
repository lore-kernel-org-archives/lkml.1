Return-Path: <linux-kernel-owner+w=401wt.eu-S1759411AbXEPHRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbXEPHRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 03:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbXEPHRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 03:17:22 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:42708 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755695AbXEPHRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 03:17:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=YVW+A99jQqanMZoHTZ4oSly6eJEMVSrYTqANQmKnY0pmxFNoIFPA2STaAMjWa5+2A0BNDvhG+p6VcKFyIVyVusAl9wzkumXg+VdJFwWjgIfunQJd2fdzXkkh+rxwPm1P+WOfZVapLNpeFHyo7teCF6ZqbOnSPMQE3DH4zBKoUzs=  ;
X-YMail-OSG: r8ICYc8VM1m_EL.th1e8DeFezfv4OUo4ybpOBDC5hFzS4LIiDCRkZaTVYl.ghDmFEZtKeaWV7A--
Message-ID: <464AAFF5.2040308@yahoo.com.au>
Date: Wed, 16 May 2007 17:17:09 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: David Howells <dhowells@redhat.com>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dchinner@sgi.com
Subject: Re: [PATCH 2/2] AFS: Implement shared-writable mmap
References: <20070515155224.29345.22719.stgit@warthog.cambridge.redhat.com> <20070515155231.29345.6212.stgit@warthog.cambridge.redhat.com> <20070516071054.GA14222@infradead.org>
In-Reply-To: <20070516071054.GA14222@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, May 15, 2007 at 04:52:31PM +0100, David Howells wrote:
> 
>>+int afs_page_mkwrite(struct vm_area_struct *vma, struct page *page)
>>+{
>>+	struct afs_vnode *vnode = AFS_FS_I(vma->vm_file->f_mapping->host);
>>+	struct key *key = vma->vm_file->private_data;
>>+	int ret;
>>+
>>+	_enter("{{%x:%u},%x},{%lx}",
>>+	       vnode->fid.vid, vnode->fid.vnode, key_serial(key), page->index);
>>+
>>+	lock_page(page);
>>+	ret = afs_prepare_write(vma->vm_file, page, 0, 0);
>>+	unlock_page(page);
>>+
>>+	_leave(" = %d", ret);
>>+	return ret;
>>+}
> 
> 
> It looks like you really want Dave's generic page_mkwrite.

Is that appropriate for a non buffer based filesystem?


> And we should
> really get that one merged for 2.6.22.

Dave asked me about that the other day (in relation to the ->fault ops)...
I have no problem merging it for 2.6.22 and rebasing my patches on top.

-- 
SUSE Labs, Novell Inc.
