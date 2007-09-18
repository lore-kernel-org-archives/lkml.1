Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbXIRE2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbXIRE2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 00:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbXIRE2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 00:28:08 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33109 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbXIRE2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 00:28:05 -0400
Date: Tue, 18 Sep 2007 09:58:22 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, pete@bluelane.com,
       Jason Wessel <jason.wessel@windriver.com>,
       Matt Mackall <mpm@selenic.com>, Amit Kale <amitkale@linsyssoft.com>,
       Dave Anderson <anderson@redhat.com>, kdb@oss.sgi.com, jlan@sgi.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: My position on general ``RAS'' tool support infrastructure
Message-ID: <20070918042822.GA4842@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <46E8B06D.9080006@bluelane.com> <m1abrq7lbt.fsf@ebiederm.dsl.xmission.com> <20070917183853.42f29393.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917183853.42f29393.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 06:38:53PM -0700, Randy Dunlap wrote:
> On Thu, 13 Sep 2007 07:21:10 -0600 Eric W. Biederman wrote:
> 
> > Pete/Piet Delaney <pete@bluelane.com> writes:
> > 
> > > Jason, Eric:
> > >
> > > Did you read Keith Owens suggestion on RAS tools from:
> 
> 
> Yes.  and I re-read it.
> 
> There are several things in Keith's email that make sense:
> 
> a.  all RAS tools should use a common interface
> b.  it's not the kernel's job to decide which RAS tool runs first
> 
> 
> Eric makes some good points too.  I'm mostly similar to Eric:
> paranoid about trusting software/hardware after a panic (or oops).
> 
> So if someone wants to use multiple RAS tools on a panic event,
> enabling an admin to set priorities is OK with me, but I'll only
> trust the first one that is used, and even that one may have
> problems.  IOW, I don't see a big need to support multiple RAS
> tools at one time.  (speaking for myself)
> 

I would be nice to have a kernel debugger co-exist with crash dumping.

I like Eric's idea of debugger putting a break point on panic(). This
would mean that rest of the post panic() actions have to be performed
by second kernel which can perform those actions much more reliably.

But this also brings in the additional requirement of passing all the
required context to second kernel. For example, in the past somebody wanted
to send a message to a remote node that sytem crashed so that standby can
take over.  If the same job has to be done in second kernel, it requires all
the relavant information like remote host IP, port etc passed to the second
kernel which I think makes the job little harder. May be one can pre-configure
these parameters in user space and let the job be done either from initrd
or user space scripts in second kernel.

Thanks
Vivek
