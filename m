Return-Path: <linux-kernel-owner+w=401wt.eu-S1759857AbZASWLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759857AbZASWLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 17:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbZASWLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 17:11:32 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:33337 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbZASWLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 17:11:32 -0500
Date: Mon, 19 Jan 2009 16:11:30 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ian Kent <raven@themaw.net>, Andrew Morton <akpm@linux-foundation.org>,
       hpa@zytor.com, Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] autofs: fix the wrong usage of the deprecated
	task_pgrp_nr()
Message-ID: <20090119221130.GB25598@us.ibm.com>
References: <1232372016.3136.155.camel@zeus.themaw.net> <20090119143046.GA8284@redhat.com> <20090119174836.GA11295@us.ibm.com> <20090119180534.GA22913@redhat.com> <20090119182447.GA15140@us.ibm.com> <20090119191729.GB24852@redhat.com> <20090119193553.GA18170@us.ibm.com> <20090119200420.GA26977@redhat.com> <20090119204839.GA21009@us.ibm.com> <20090119213146.GA31593@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090119213146.GA31593@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> On 01/19, Serge E. Hallyn wrote:
> >
> > Quoting Oleg Nesterov (oleg@redhat.com):
> > > 
> > > This is the next patch. This one does
> > > 
> > > 	--- CUR/fs/autofs/inode.c~1_AUTOFS	2009-01-12 23:07:46.000000000 +0100
> > > 	+++ CUR/fs/autofs/inode.c	2009-01-18 06:18:49.000000000 +0100
> > > 	@@ -78,7 +78,7 @@ static int parse_options(char *options, 
> > > 	 
> > > 		*uid = current_uid();
> > > 		*gid = current_gid();
> > > 	-	*pgrp = task_pgrp_nr(current);
> > > 	+	*pgrp = task_pgrp_vnr(current);
> > 
> > Ok, that was the one I had looked at earlier (though now I can't find
> > it).  But that just seems wrong to me.  We should certainly not be
> > caching a pid_vnr in the kernel.  That is imo incomparably worse than
> > storing a pid_nr.
> 
> We do not cache it. We use this pgrp as an argument for find_pid()
> right after return from parse_options(). And find_pid() uses
> current->nsproxy->pid_ns. That is why this is bugfix.

So it does.  And so it is.

thanks,
-serge
