Return-Path: <linux-kernel-owner+w=401wt.eu-S1763012AbYHFVeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763012AbYHFVeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbYHFV2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:28:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086AbYHFV2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:28:43 -0400
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
	for on access scanning
From: Eric Paris <eparis@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       malware-list@lists.printk.net, linux-kernel@vger.kernel.org
In-Reply-To: <20080806210202.GA9413@mit.edu>
References: <1217883616.27684.19.camel@localhost.localdomain>
	 <20080804223249.GA10517@kroah.com>
	 <1217896374.27684.53.camel@localhost.localdomain>
	 <20080805005132.GA3661@kroah.com>
	 <20080805122328.69a37c1d@lxorguk.ukuu.org.uk>
	 <20080805170307.GB9639@kroah.com>
	 <1217962602.27684.144.camel@localhost.localdomain>
	 <20080805203007.GB27489@kroah.com>
	 <1218048597.27684.276.camel@localhost.localdomain>
	 <20080806210202.GA9413@mit.edu>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 17:28:01 -0400
Message-Id: <1218058081.5837.49.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 17:02 -0400, Theodore Tso wrote:
> On Wed, Aug 06, 2008 at 02:49:57PM -0400, Eric Paris wrote:
> > 
> > This simple thread shows what I believe to be clear and compelling
> > evidence of the need for an in kernel solution.  Lets just consider that
> > we are a high input, high output, NFS file server with other OS's
> > mounting this NFS share RW.
> > 
> > Our goal is to stop, or at least reduce the throughput (I clearly
> > document and accept the open to read race, and until we get a working
> > revoke I don't see that changing) of malware across the NFS server.
> > This data will not be attacking the NFS server.  We wish to slow and
> > hopefully halt the spread of this data with minimal impact to the NFS
> > server.
> 
> In this scenario, are you positing that you are worried about Windows
> malware, or Linux malware?  What OS are the clients running?  I will
> note that Windows has such a sucky NFS implementation that nearly all
> Widows clients will be running CIFS/SMB, not NFS

I believe I specifically did not make any such claims at all about the
client OS and merely claimed the intended target was not the linux NFS
server.  I didn't make those claims because they are irrelevant and so
that people could not jump on those details and try to offload the
solution to the wrong place.  Maybe the client is not Windows but
another large desktop OS who actually has a reasonable NFS client?  How
do you turn this into a straw man argument then?  Remember, I'm not
claiming that my solution for the entirety of the threads that AV
vendors claim to want to protect again, I simply claim that a
GLIBC/LD_PRELOAD solution is easily shown to be infeasible for even the
most elementary of threats.

> --- so the right
> solution there is to integrate the virus checking with Samba ---
> especially since the one AV vendor has already admitted the actual
> virus signature checking has to be done in userspace.

<snide> I believe they all are going to claim it has to be in some
userspace proprietary application for them to keep making money </snide>

> For Linux clients, one question that immediately rises is the
> end-to-end argument.  Wouldn't be far better to run whatever security
> solution on the client?  After all, a Virus checking on an NFS server
> isn't going to help the user if they accidentally track in the virus
> on a USB stick.  (Especially if it is an infected Macro virus in an
> office document.)

Your argument is irrelevant for the threat given and you seem to have
contorted the actual point of the statements to fit something else.  But
I'm sure you a fan of multiple layers of security that you don't
actually believe that "just check on the clients" is the right thing to
do.  Linux client side checking is most likely going to be something
that vendors claim to want to do but has no bearing on if out of kernel
scanning is feasible for NFS servers.  Nor if you want to look at the
"end-to-end argument" as you claim can excluding server side scanning be
a reasonable choice.

How many clients machines at your location are controlled by some IT
organization?  How many servers?  I think it's quite obvious that unless
the answer to the first question is "all" then we would want scanning on
both the client and the server.  I think there are many organizations in
which many, or even most, machines with access to an NFS server can be
controlled so as to enforce scanning, but its not reasonable, at least
in my mind, to throw out server side NFS scanning unless you can control
ALL of the clients.

-Eric

-Eric

