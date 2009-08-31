Return-Path: <linux-kernel-owner+w=401wt.eu-S1752391AbZHaRT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbZHaRT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 13:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbZHaRT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 13:19:59 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:45483 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbZHaRT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 13:19:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p4K604JRWEsqnBExFLHxt0oBztqqqerpXgg3AWNDzA249Kh3lUx7tMx5EN9YKxl+uS
         zetSS30iwgvuihshdyzNAV/Hj10bgBHbvv3YxYoB6fFCUAVeJ9aJOGUzd2NiquIRmL2r
         9BbfpuoC20BVJCXXPShFRyRskUSloqMQUpOFM=
Date: Mon, 31 Aug 2009 21:19:56 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stefani Seibold <stefani@seibold.net>,
       Christoph Hellwig <hch@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix proc_file_write missing ppos update
Message-ID: <20090831171956.GA3036@x200.localdomain>
References: <1251563892.13287.11.camel@wall-e> <1251659144.20987.18.camel@wall-e> <20090831063334.GB7821@x200.localdomain> <200908311744.52972.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908311744.52972.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 05:44:52PM +0200, Arnd Bergmann wrote:
> On Monday 31 August 2009, Alexey Dobriyan wrote:
> > Out-of-tree argument means almost nothing.
> > 
> > ...
> >
> > You'd better start converting to struct file_operations::write now.
> 
> Maybe a purely mechanical conversion to file_operations would be a nice first
> step, just so we can remove read_proc and write_proc? Taking scsi_proc.c
> as an example, this should be really straightforward and lets us get
> rid of the write_proc and read_proc callbacks from proc_dir_entry without
> having to rewrite all the remaining drivers that use it.
> 
> Obviously, someone who understands the specific driver code better should
> then clean up the code by converting to seq_file operations or something
> else that is appropriate there.

I don't like any churn in that area. Everything is ready for ->proc_fops usage.
So we should simply convert users away.
Actually most of SCSI and IDE is already done, just wasn't sent yet.

After conversion, ->read_proc, ->write_proc, create_proc_read_entry(),
create_proc_entry() will become deprecated for a while, then gone.
