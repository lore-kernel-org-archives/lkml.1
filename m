Return-Path: <linux-kernel-owner+w=401wt.eu-S1760920AbYBND72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920AbYBND72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 22:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbYBND7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 22:59:17 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:47752 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbYBND7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 22:59:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SlCiZ1UQ64sP1ZYVdmrHrybSA8kc93s1r8fPFK+8HcLiDb7nBgaA6FEEZ95lkphBsDoFGYkrK59PwNWAdsXHAq2BMcs0Npvtj4kyQPIKtsUFVk9OV1dcawro8uHoifY3K4pHP3CQMwcEdTj6e7QTKDTXbpve2Mb8OxEhnPRbv8c=
Subject: Re: [PATCH] adfs: trivial sparse fix
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <rmk@arm.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080213193945.91b42a8d.akpm@linux-foundation.org>
References: <1202954868.18204.47.camel@brick>
	 <20080213193945.91b42a8d.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 19:52:12 -0800
Message-Id: <1202961135.16621.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-13 at 19:39 -0800, Andrew Morton wrote:
> On Wed, 13 Feb 2008 18:07:48 -0800 Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > fs/adfs/dir_f.c:126:4: warning: do-while statement is not a compound statement
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> >  fs/adfs/dir_f.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/adfs/dir_f.c b/fs/adfs/dir_f.c
> > index b9b2b27..ea7df21 100644
> > --- a/fs/adfs/dir_f.c
> > +++ b/fs/adfs/dir_f.c
> > @@ -122,9 +122,9 @@ adfs_dir_checkbyte(const struct adfs_dir *dir)
> >  		ptr.ptr8 = bufoff(bh, i);
> >  		end.ptr8 = ptr.ptr8 + last - i;
> >  
> > -		do
> > +		do {
> >  			dircheck = *ptr.ptr8++ ^ ror13(dircheck);
> > -		while (ptr.ptr8 < end.ptr8);
> > +		} while (ptr.ptr8 < end.ptr8);
> >  	}
> >  
> 
> eh?  It's sparse which needs fixing here, surely?

Well, I only 'fixed' it this way to match the surrounding code.  The
warning is a little odd.

Harvey

