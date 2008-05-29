Return-Path: <linux-kernel-owner+w=401wt.eu-S1759344AbYE2Xfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344AbYE2Xfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 19:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbYE2Xfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 19:35:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754584AbYE2Xfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 19:35:39 -0400
Date: Thu, 29 May 2008 16:35:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Subject: Re: [RFC][Patch 5/5]integrity: IMA as an integrity service provider
Message-Id: <20080529163501.5a672b8f.akpm@linux-foundation.org>
In-Reply-To: <1212097834.15923.7.camel@localhost.localdomain>
References: <1211555145.16195.18.camel@new-host>
	<20080528012242.a0e98d87.akpm@linux-foundation.org>
	<1212031046.4747.57.camel@new-host.home>
	<20080528203013.5a927d30.akpm@linux-foundation.org>
	<1212097834.15923.7.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 17:50:34 -0400
Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> 
> On Wed, 2008-05-28 at 20:30 -0700, Andrew Morton wrote:
> 
> > > ...
> > >
> > > > - All the games with mtimes should be described in the changelog too.
> > > 
> > > Ok. The timespec_recent and mtime issues are part of the same problem
> > > of detecting when a file has been modified.
> > 
> > Can't use inode.i_version?
> 
> i_version is now working on my system.

Oh good.

>  It looks good. Is
> there anything that I need to be concerned about, such as
> limited filesystem support or the i_version is not updated 
> by file_close for mmaped files?

erk, I'm not an i_version person.  It seems that it's only used on
directories (to patch up readdir coherency problems) so I guess I
misled you there.

There's file_struct.f_version, which is no good.

i_generation is no good either.

We've documented these things so wonderfully!

i_writecount looks good?
