Return-Path: <linux-kernel-owner+w=401wt.eu-S1752955AbXCUOow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbXCUOow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 10:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbXCUOow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 10:44:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58839 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbXCUOot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 10:44:49 -0400
Date: Wed, 21 Mar 2007 14:44:26 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ftp.linux.org.uk
Subject: Re: [PATCH] Turn do_sync_file_range() into do_sync_mapping_range()
Message-ID: <20070321144426.GA25213@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mark Fasheh <mark.fasheh@oracle.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	viro@ftp.linux.org.uk
References: <20070320214626.GC23274@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320214626.GC23274@ca-server1.us.oracle.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 02:46:26PM -0700, Mark Fasheh wrote:
> do_sync_file_range() accepts a file * from which it takes an address_space
> to sync. Abstract out the bulk of the function into do_sync_mapping_range()
> which takes the address_space directly. This way callers who want to sync an
> address_space directly can take advantage of the functionality provided.
> 
> do_sync_file_range() is preserved as a 3 line wrapper around
> do_sync_mapping_range().
> 
> Ocfs2 in particular would like to use this to initiate a sync of a specific
> inode range during truncate, where a file * may not be available.

Looks good to me, but I agree with Andrew that we should simply
kill do_sync_file_range, espcially as at least one of the callers
has file->f_mapping guaranteed != NULL;

