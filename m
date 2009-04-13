Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbZDMSzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbZDMSzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 14:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbZDMSzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 14:55:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122AbZDMSzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 14:55:31 -0400
Date: Mon, 13 Apr 2009 11:49:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@elte.hu, Valdis.Kletnieks@vt.edu, travis@sgi.com,
       linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       rusty@rustcorp.com.au, davej@redhat.com, lenb@kernel.org
Subject: Re: mmotm 2009-04-10-02-21 uploaded - forkbombed by work_for_cpu
Message-Id: <20090413114932.44b47910.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0904131040350.4583@localhost.localdomain>
References: <200904100922.n3A9MOIV013828@imap1.linux-foundation.org>
	<4609.1239456126@turing-police.cc.vt.edu>
	<alpine.LFD.2.00.0904130847500.4583@localhost.localdomain>
	<20090413171853.GA4601@elte.hu>
	<20090413102749.4ca3a217.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0904131040350.4583@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009 10:45:45 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 13 Apr 2009, Andrew Morton wrote:
> >
> >  static void drv_write(struct drv_cmd *cmd)
> >  {
> > -	unsigned int i;
> > +	unsigned int cpu;
> >  
> > -	for_each_cpu(i, cmd->mask) {
> > -		work_on_cpu(i, do_drv_write, cmd);
> > -	}
> > +	for_each_cpu(cpu, cmd->mask)
> > +		smp_call_function_single(cpu, do_drv_write, cmd, 1);
> 
> Ok, that's just -wrong-.
> 
> Doesn't anybody else see anything odd in doing
> 
> 	for_each_cpu(cpu, cmd->mask)
> 		smp_call_function_single(cpu, ..);
> 
> and react to it?
> 
> IOW, why not just do
> 
> 	smp_call_function_many(cmd->mask, do_drv_write, cmd, 1);
> 
> here?
> 

Didn't know it existed :(
