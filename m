Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbZA2C3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbZA2C3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 21:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbZA2C26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 21:28:58 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:38492 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbZA2C25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 21:28:57 -0500
Date: Thu, 29 Jan 2009 11:28:50 +0900
From: Simon Horman <horms@verge.net.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Miao Xie <miaox@cn.fujitsu.com>, Neil Horman <nhorman@tuxdriver.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: mmotm 2009-01-28-02-17 uploaded (i386 build errors: cpusets &
	kexec)
Message-ID: <20090129022846.GA1319@verge.net.au>
References: <200901281019.n0SAJ9C6013727@imap1.linux-foundation.org> <49808E3F.1090805@oracle.com> <20090128163040.88b05b3d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128163040.88b05b3d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 04:30:40PM -0800, Andrew Morton wrote:
> On Wed, 28 Jan 2009 08:56:31 -0800
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > akpm@linux-foundation.org wrote:
> > > The mm-of-the-moment snapshot 2009-01-28-02-17 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > > 
> > > and will soon be available at
> > > 
> > >    git://git.zen-sources.org/zen/mmotm.git
> > 
> > 
> > 10 randconfigs on i386, 1 good build.
> > 
> > The other 9 ended with either of these build errors:
> > 

[snip]

> So does that.
> 
> --- a/kernel/printk.c~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix
> +++ a/kernel/printk.c
> @@ -137,11 +137,13 @@ static char *log_buf = __log_buf;
>  static int log_buf_len = __LOG_BUF_LEN;
>  static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
>  
> +#ifdef CONFIG_KEXEC
>  void log_buf_kexec_setup(void)
>  {
>  	VMCOREINFO_SYMBOL(log_buf);
>  	VMCOREINFO_SYMBOL(log_end);
>  }
> +#endif
>  
>  static int __init log_buf_len_setup(char *str)
>  {
> _

Weird, I thought I checked that just now. In any case this email
was already in my inbox. In any case, I can now produce the problem,
and this patch resolves it.

-- 
Simon Horman
  VA Linux Systems Japan K.K., Sydney, Australia Satellite Office
  H: www.vergenet.net/~horms/             W: www.valinux.co.jp/en

