Return-Path: <linux-kernel-owner+w=401wt.eu-S1758832AbZFZUVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbZFZUVB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 16:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbZFZUUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 16:20:54 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43042 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbZFZUUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 16:20:53 -0400
Date: Fri, 26 Jun 2009 16:20:45 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       earl_chew@agilent.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern: wait for core collectors
Message-ID: <20090626202045.GG7337@hmsreliant.think-freely.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org> <20090626180355.GE7337@hmsreliant.think-freely.org> <20090626164819.GA12063@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626164819.GA12063@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 06:48:19PM +0200, Oleg Nesterov wrote:
> On 06/26, Neil Horman wrote:
> >
> > - 		if (call_usermodehelper_pipe(corename+1, helper_argv, NULL,
> > -				&file)) {
> > + 		if (call_usermodehelper_pipe(helper_argv[0], helper_argv, NULL,
> > +				&file, &pid) < 0) {
> 
> ...
> 
> 
> > +	if (ispipe && core_pipe_limit)
> > +		sys_wait4(pid, NULL, 0, NULL);
> 
> How this can work? sys_wait4() can only wait for our childs, but the parent
> of the dumping thread is khelper.
> 
> 
> If we change kmod.c, then I think we need UMH_WAIT_CUSTOM_COMPLETION.
> 
> 
> But perhaps do_coredump() can just sleep on file->...->i_pipe->wait waiting
> for pipe_inode_info->readers == 0 ?
> 
Thats a good idea, I like that better.  I'll fix that up and repost monday
morning.
Neil

> Oleg.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
