Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbZCLTOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbZCLTOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 15:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbZCLTOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 15:14:36 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60070 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbZCLTOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 15:14:34 -0400
Subject: Re: [RFC][PATCH 09/11] check files for checkpointability
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20090309173837.GC7561@us.ibm.com>
References: <20090309173837.GC7561@us.ibm.com>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 12:14:29 -0700
Message-Id: <1236885269.30142.106.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-09 at 10:38 -0700, Matt Helsley wrote:
> On Thu, Mar 05, 2009 at 08:39:10AM -0800, Dave Hansen wrote:
> > +static void __scan_files_for_cr(struct files_struct *files)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < files->fdtab.max_fds; i++) {
> > +		struct file *f = fcheck_files(files, i);
> > +		if (!f)
> > +			continue;
> > +		if (cr_file_supported(f))
> > +			continue;
> > +		files_deny_checkpointing(files);
> 
> At this point couldn't we skip the rest of the loop iterations?

As it stands, yeah.  That makes sense.

> Might it also be useful to print a path to f here? So not only would
> the log show the location in the kernel source but we'd also get some
> idea of which file caused the problem? Of course "f" isn't always
> available everywhere we call files_deny_checkpointing()..

Also a good suggestion.  That would help the readability of the warning
a bunch.

-- Dave

