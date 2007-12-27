Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbXL0SNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbXL0SNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 13:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbXL0SNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 13:13:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbXL0SNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 13:13:36 -0500
Date: Thu, 27 Dec 2007 13:12:18 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3 -mm] kexec jump -v8
Message-ID: <20071227181218.GA15084@redhat.com>
References: <1198222399.1965.15.camel@caritas-dev.intel.com> <20071227015716.GA6718@redhat.com> <1198722793.7320.15.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198722793.7320.15.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2007 at 10:33:13AM +0800, Huang, Ying wrote:
> On Wed, 2007-12-26 at 20:57 -0500, Vivek Goyal wrote:
> [...]
> > > 9. Now, you are in the original kernel again. You can read/write the
> > >    memory image of kexeced kernel via /proc/kimgcore.
> > > 
> > 
> > Why do we need two interfaces, /proc/vmcore and /proc/kimgcore? Can't
> > we have just one say /proc/vmcore. Irrespective of what kernel you are
> > in /proc/vmcore gives you the access to the memory of kernel which was
> > previously booted.
> 
> In theory we can kexec another kernel even in a kexeced kernel, that is,
> in kernel A kexec kernel B, and in kernel B kexec another kernel C. In
> this situation, both /proc/vmcore and /proc/kimgcore has valid contents.
> So I think, it may be better to keep two interfaces.
> 

In those situations I think only one interface is better. For example, 
above will be broken if somebody kexec 4 kernels.

A-->B--->C--->D

I think better option might be if it is stack like situation. A kernel
shows you only the previous kernel's memory contents through /proc/vmcore
interface. So If I am in kernel D, I see only kernel C's memory image.
To see kernel B's memory image, one shall have to go back to kernel C.

Thanks
Vivek
