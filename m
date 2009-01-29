Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbZA2OVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbZA2OVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZA2OVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:21:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42013 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbZA2OVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:21:38 -0500
Date: Thu, 29 Jan 2009 09:20:49 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Simon Horman <horms@verge.net.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: mmotm 2009-01-28-02-17 uploaded (i386 build errors: cpusets &
	kexec)
Message-ID: <20090129142049.GA20988@redhat.com>
References: <200901281019.n0SAJ9C6013727@imap1.linux-foundation.org> <49808E3F.1090805@oracle.com> <20090128163040.88b05b3d.akpm@linux-foundation.org> <20090129022846.GA1319@verge.net.au> <20090129120935.GB9221@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129120935.GB9221@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 07:09:35AM -0500, Neil Horman wrote:
> On Thu, Jan 29, 2009 at 11:28:50AM +0900, Simon Horman wrote:
> > On Wed, Jan 28, 2009 at 04:30:40PM -0800, Andrew Morton wrote:
> > > On Wed, 28 Jan 2009 08:56:31 -0800
> > > Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > > 
> > > > akpm@linux-foundation.org wrote:
> > > > > The mm-of-the-moment snapshot 2009-01-28-02-17 has been uploaded to
> > > > > 
> > > > >    http://userweb.kernel.org/~akpm/mmotm/
> > > > > 
> > > > > and will soon be available at
> > > > > 
> > > > >    git://git.zen-sources.org/zen/mmotm.git
> > > > 
> > > > 
> > > > 10 randconfigs on i386, 1 good build.
> > > > 
> > > > The other 9 ended with either of these build errors:
> > > > 
> > 
> > [snip]
> > 
> > > So does that.
> > > 
> > > --- a/kernel/printk.c~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix
> > > +++ a/kernel/printk.c
> > > @@ -137,11 +137,13 @@ static char *log_buf = __log_buf;
> > >  static int log_buf_len = __LOG_BUF_LEN;
> > >  static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
> > >  
> > > +#ifdef CONFIG_KEXEC
> > >  void log_buf_kexec_setup(void)
> > >  {
> > >  	VMCOREINFO_SYMBOL(log_buf);
> > >  	VMCOREINFO_SYMBOL(log_end);
> > >  }
> > > +#endif
> > >  
> > >  static int __init log_buf_len_setup(char *str)
> > >  {
> > > _
> > 
> > Weird, I thought I checked that just now. In any case this email
> > was already in my inbox. In any case, I can now produce the problem,
> > and this patch resolves it.
> > 
> 
> Sorry, i didn't think to check on conditions when CONFIG_KEXEC wasn't set.  I
> assumed we had a stub for all the VMCOREINFO defines.  Why don't we fix it in
> that manner?  I mean we have serveral arch specific additions to vmcoreinfo, all
> of which apparently must be ifdefd for this to work.  Why not just fix it in
> conditional definition?
> 

This kind of makes sense. We probably should be taken care in kexec.h with
empty definition of VMCOREINFO_SYMBOL so that we can get rid of #ifdef
KEXEC in printk.c

Neil, do you want to throw in a patch for that.

Thanks
Vivek
