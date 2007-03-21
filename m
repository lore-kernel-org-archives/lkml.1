Return-Path: <linux-kernel-owner+w=401wt.eu-S932798AbXCUQNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798AbXCUQNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932835AbXCUQNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:13:04 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:43126 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798AbXCUQNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:13:01 -0400
Date: Wed, 21 Mar 2007 09:12:08 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk
Subject: Re: [PATCH] Turn do_sync_file_range() into do_sync_mapping_range()
Message-ID: <20070321161208.GF23274@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20070320214626.GC23274@ca-server1.us.oracle.com> <20070321144426.GA25213@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321144426.GA25213@infradead.org>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 02:44:26PM +0000, Christoph Hellwig wrote:
> On Tue, Mar 20, 2007 at 02:46:26PM -0700, Mark Fasheh wrote:
> > do_sync_file_range() accepts a file * from which it takes an address_space
> > to sync. Abstract out the bulk of the function into do_sync_mapping_range()
> > which takes the address_space directly. This way callers who want to sync an
> > address_space directly can take advantage of the functionality provided.
> > 
> > do_sync_file_range() is preserved as a 3 line wrapper around
> > do_sync_mapping_range().
> > 
> > Ocfs2 in particular would like to use this to initiate a sync of a specific
> > inode range during truncate, where a file * may not be available.
> 
> Looks good to me, but I agree with Andrew that we should simply
> kill do_sync_file_range, espcially as at least one of the callers
> has file->f_mapping guaranteed != NULL;

Ok - I'll post an updated patch series today. Thank you all for taking the
time to look at this.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
