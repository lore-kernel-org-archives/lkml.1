Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbYE3B6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbYE3B6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 21:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbYE3B6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 21:58:13 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:36637 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbYE3B6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 21:58:12 -0400
Subject: Re: [RFC][Patch 5/5]integrity: IMA as an integrity service provider
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
In-Reply-To: <20080529163501.5a672b8f.akpm@linux-foundation.org>
References: <1211555145.16195.18.camel@new-host>
	 <20080528012242.a0e98d87.akpm@linux-foundation.org>
	 <1212031046.4747.57.camel@new-host.home>
	 <20080528203013.5a927d30.akpm@linux-foundation.org>
	 <1212097834.15923.7.camel@localhost.localdomain>
	 <20080529163501.5a672b8f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 29 May 2008 21:58:08 -0400
Message-Id: <1212112688.4722.10.camel@new-host.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-29 at 16:35 -0700, Andrew Morton wrote: 
> On Thu, 29 May 2008 17:50:34 -0400
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > 
> > On Wed, 2008-05-28 at 20:30 -0700, Andrew Morton wrote:
> > 
> > > > ...
> > > >
> > > > > - All the games with mtimes should be described in the changelog too.
> > > > 
> > > > Ok. The timespec_recent and mtime issues are part of the same problem
> > > > of detecting when a file has been modified.
> > > 
> > > Can't use inode.i_version?
> > 
> > i_version is now working on my system.
> 
> Oh good.
> 
> >  It looks good. Is
> > there anything that I need to be concerned about, such as
> > limited filesystem support or the i_version is not updated 
> > by file_close for mmaped files?
> 
> erk, I'm not an i_version person.  It seems that it's only used on
> directories (to patch up readdir coherency problems) so I guess I
> misled you there.

No, no.  Initially, that's what I thought. I finally found
file_update_time() calls inode_inc_iversion(), which updates 
the i_version.  So, it does work.  The question is whether
or not it works all the time. :-)

> There's file_struct.f_version, which is no good.
> 
> i_generation is no good either.
> 
> We've documented these things so wonderfully!
> 
> i_writecount looks good?

