Return-Path: <linux-kernel-owner+w=401wt.eu-S1751793AbXDCEFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbXDCEFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 00:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbXDCEFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 00:05:25 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40263 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbXDCEFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 00:05:24 -0400
Date: Tue, 3 Apr 2007 09:35:20 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: thunder7@xs4all.nl
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Helge Hafting <helgehaf@aitel.hist.no>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm3 - no boot, "address not 2M aligned"
Message-ID: <20070403040520.GB5108@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070331071220.GA26910@aitel.hist.no> <20070331005303.354411f0.akpm@linux-foundation.org> <20070401052932.GA9894@amd64.of.nowhere> <m1ircghb6w.fsf@ebiederm.dsl.xmission.com> <20070331232957.e1c93f19.akpm@linux-foundation.org> <20070402074159.GA13704@in.ibm.com> <20070402111745.GA9882@amd64.of.nowhere> <20070402113639.GD13704@in.ibm.com> <20070402144914.GA22725@amd64.of.nowhere> <20070402145926.GA25824@amd64.of.nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402145926.GA25824@amd64.of.nowhere>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 04:59:26PM +0200, thunder7@xs4all.nl wrote:
> From: thunder7@xs4all.nl <thunder7@xs4all.nl>
> Date: Mon, Apr 02, 2007 at 04:49:14PM +0200
> > 
> > I used a working 2.6.21-rc3-mm2 tree, patched it up to 2.6.21-rc5-mm3
> > and applied your patch. I ended up with the .config later in this email,
> > and got this error:
> > 
> >   CC      arch/x86_64/kernel/head64.o
> > arch/x86_64/kernel/head64.c: In function 'x86_64_start_kernel':
> > arch/x86_64/kernel/head64.c:70: error: size of array 'type name' is negative
> > make[1]: *** [arch/x86_64/kernel/head64.o] Error 1
> > make: *** [arch/x86_64/kernel] Error 2
> > 
> > After reverting your patch, the build didn't fail, but of course the
> > kernel won't build.
> > 
> That should, of course, read 'kernel won't boot'.
> 

I agree that error message is not very clear. It is just an indication that
there is a problem on line 70 in head64.c. That's why I have put a
commet there so that anybody can make out that CONFIG_PHYSICAL_START
is not 2MB aligned hence the failure.

Unfortunately, Kconfig infrastrucutre does not allow to place alignment
restrictions on the values. Otherwise that would have been the best
solution.

So we still have detected the problem at compilation time in a little
indirect manner though.

Thanks
Vivek
