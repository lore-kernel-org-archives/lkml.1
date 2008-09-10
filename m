Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbYIJQJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbYIJQJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 12:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbYIJQJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 12:09:51 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:52745 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbYIJQJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 12:09:50 -0400
Subject: Re: [RFC v4][PATCH 9/9] File descriprtors (restore)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, jeremy@goop.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <48C727B6.9000700@cs.columbia.edu>
References: <1220946154-15174-1-git-send-email-orenl@cs.columbia.edu>
	 <1220946154-15174-10-git-send-email-orenl@cs.columbia.edu>
	 <1220977581.23386.216.camel@nimitz>  <48C727B6.9000700@cs.columbia.edu>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 09:09:29 -0700
Message-Id: <1221062969.6781.5.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-09 at 21:49 -0400, Oren Laadan wrote:
> 
> Dave Hansen wrote:
> > On Tue, 2008-09-09 at 03:42 -0400, Oren Laadan wrote:
> >> +static int cr_close_all_fds(struct files_struct *files)
> >> +{
> >> +       int *fdtable;
> >> +       int n;
> >> +
> >> +       do {
> >> +               n = cr_scan_fds(files, &fdtable);
> >> +               if (n < 0)
> >> +                       return n;
> >> +               while (n--)
> >> +                       sys_close(fdtable[n]);
> >> +               kfree(fdtable);
> >> +       } while (n != -1);
> >> +
> >> +       return 0;
> >> +}
> > 
> > This needs to use an ERR_PTR().  It will save using the double-pointer.
> 
> I suppose you refer to the call to cr_scan_fds(): either 'fdtable'
> or 'n' will have to pass-by-reference. Is it that you prefer it to be
> 	fdtable = cr_scan_fds(files, &n);
> ?

I was misreading the use of 'n'.  Can you really not use close_files()
for this operation?  You'd need to add some locking around it, but I
think it does what you need here.

-- Dave

