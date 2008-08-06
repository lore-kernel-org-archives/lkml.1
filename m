Return-Path: <linux-kernel-owner+w=401wt.eu-S1422885AbYHFVCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422885AbYHFVCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbYHFVC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:02:29 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:46768 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755706AbYHFVC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:02:28 -0400
Date: Wed, 6 Aug 2008 17:02:02 -0400
From: Theodore Tso <tytso@mit.edu>
To: Eric Paris <eparis@redhat.com>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       malware-list@lists.printk.net, linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
	for on access scanning
Message-ID: <20080806210202.GA9413@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Paris <eparis@redhat.com>, Greg KH <greg@kroah.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, malware-list@lists.printk.net,
	linux-kernel@vger.kernel.org
References: <1217883616.27684.19.camel@localhost.localdomain> <20080804223249.GA10517@kroah.com> <1217896374.27684.53.camel@localhost.localdomain> <20080805005132.GA3661@kroah.com> <20080805122328.69a37c1d@lxorguk.ukuu.org.uk> <20080805170307.GB9639@kroah.com> <1217962602.27684.144.camel@localhost.localdomain> <20080805203007.GB27489@kroah.com> <1218048597.27684.276.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218048597.27684.276.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 02:49:57PM -0400, Eric Paris wrote:
> 
> This simple thread shows what I believe to be clear and compelling
> evidence of the need for an in kernel solution.  Lets just consider that
> we are a high input, high output, NFS file server with other OS's
> mounting this NFS share RW.
> 
> Our goal is to stop, or at least reduce the throughput (I clearly
> document and accept the open to read race, and until we get a working
> revoke I don't see that changing) of malware across the NFS server.
> This data will not be attacking the NFS server.  We wish to slow and
> hopefully halt the spread of this data with minimal impact to the NFS
> server.

In this scenario, are you positing that you are worried about Windows
malware, or Linux malware?  What OS are the clients running?  I will
note that Windows has such a sucky NFS implementation that nearly all
Widows clients will be running CIFS/SMB, not NFS --- so the right
solution there is to integrate the virus checking with Samba ---
especially since the one AV vendor has already admitted the actual
virus signature checking has to be done in userspace.

For Linux clients, one question that immediately rises is the
end-to-end argument.  Wouldn't be far better to run whatever security
solution on the client?  After all, a Virus checking on an NFS server
isn't going to help the user if they accidentally track in the virus
on a USB stick.  (Especially if it is an infected Macro virus in an
office document.)  

							- Ted
