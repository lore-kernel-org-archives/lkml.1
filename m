Return-Path: <linux-kernel-owner+w=401wt.eu-S1752737AbZH3IJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbZH3IJl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 04:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZH3IJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 04:09:40 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:2135 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbZH3IJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 04:09:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eA365xsuHymnMvNUK7MdmEOXsrjZp4ATG+oFJysBq/2iM5hwS8CM1KnBHlhbWwPCcc
         sZCy1suQ1GPj+P+S2JS5wj1VmoSJNc8mP5jXiSybH74y5BwUzr2LY623b0LKz8QNRhEg
         IWf2PXSvfxj8zEQhvY4rYroWNNPHA1KVU8AGw=
Date: Sun, 30 Aug 2009 12:09:37 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Stefani Seibold <stefani@seibold.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix proc_file_write missing ppos update
Message-ID: <20090830080937.GA13999@x200.localdomain>
References: <1251563892.13287.11.camel@wall-e> <20090829231650.GA29419@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090829231650.GA29419@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 29, 2009 at 07:16:50PM -0400, Christoph Hellwig wrote:
> On Sat, Aug 29, 2009 at 06:38:12PM +0200, Stefani Seibold wrote:
> > The following fix a long standing issue in the proc_file_write function,
> > which doesn't update the ppos file position pointer.
> 
> The right fix is to get rid of the last remaining
> read_proc_t/write_proc_t instances and switch everyone to implement file
> operations.  Alexey has been working on this on and off for a while.

Yes, please, ->write_proc is going to end very soon.

As for prevoius arguments:
- changing ->write_proc signature is _of course_ going to break
  out-of-tree stuff
- ->proc_fops worked since forever, and since it's struct file_operations,
  nobody prohibits implementing ->write with pos update and what not.
- seq_file is not relevant to this issue because seq_file is for read path
  only.

Back into SCSI pile of users.
