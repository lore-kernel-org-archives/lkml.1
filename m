Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbYDLTH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbYDLTH0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 15:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbYDLTHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 15:07:14 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51910 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbYDLTHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 15:07:13 -0400
Subject: Re: [PATCH 0/4] Helper patches for PTY namespaces
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: sukadev@us.ibm.com
Cc: Andrew Morton <akpm@osdl.org>, serue@us.ibm.com, matthltc@us.ibm.com,
       hpa@zytor.com, Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080412172933.GA19295@us.ibm.com>
References: <20080412172933.GA19295@us.ibm.com>
Content-Type: text/plain
Date: Sat, 12 Apr 2008 12:06:55 -0700
Message-Id: <1208027215.28187.17.camel@x61.ebiederm.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on mgr1.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-04-12 at 10:29 -0700, sukadev@us.ibm.com wrote:
> Some simple helper patches to enable implementation of multiple PTY
> (or device) namespaces.
> 
> 	[PATCH 1/4]: Propagate error code from devpts_pty_new
> 	[PATCH 2/4]: Factor out PTY index allocation
> 	[PATCH 3/4]: Move devpts globals into init_pts_ns
> 	[PATCH 3/4]: Enable multiple mounts of /dev/pts
> 
> This patchset is based on earlier versions developed by Serge Hallyn
> and Matt Helsley.

Suka Stop.

The first two patches appear to just be cleanups and as such should be
able to stand on their own.  Mentioning that you found these
opportunities while working on your pts namespace is fine.  Justifying
the cleanups this way is not.

When you mentioned you intended to just resend the cleanups this is not
at all what I thought you were about.  So please just get the first two
patches in a form that stands by themselves.

The pts namespace as designed is not acceptable.

The problem you are trying to solve with the pts namespace is real.

So what we need is a device namespace and possibly and incremental path
to get there.  A device namespace would abstract the device number to
device mapping for all devices.  A safe incremental path would disable
all device number to device mappings for process in that namespace.  So
all functionality would be gone, then it would enable certain mappings
and certain pieces of the functionality if the code in the kernel is not
clean enough that we can do it all in one go.

We need to see that path.  Only then can we take patches that add
namespace specific goo.  The pattern I am proposing has worked quite
well for the network namespace.  Meanwhile the uid namespace which
follows the pattern you seem to be following now seems does not look to
be completed any time soon.

So send your clean up patches and then let's architect this thing so we
are really talking about a namespace.  Then we can update devpts to
capture the device namespace on mount and do it's work in a namespace
specific manner.

Eric


