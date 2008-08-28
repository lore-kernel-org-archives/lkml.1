Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbYH1Dvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbYH1Dvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 23:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbYH1Dvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 23:51:33 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:34397 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbYH1Dvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 23:51:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=F7jySAjOrGkemk4ZOHsek/L3O8goQY8LSjPnZEfXYRDJ77skoKiIlg7vAnLhxWLs5V
         jkqDhmubUxybMS0Bal/aD9hVIEPfYJRwen1sqtohv3HlnwSHgq6MEJjbJMUFBrLnm7Vt
         CTtROz92anJS4zLqO3plBXTwz0XZlYLDX/c2E=
Subject: Re: + rcu-fix-sparse-shadowed-variable-warning.patch added to -mm
	tree
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com
In-Reply-To: <20080828033123.GA19218@x200.localdomain>
References: <200808280322.m7S3MOUg004835@imap1.linux-foundation.org>
	 <20080828033123.GA19218@x200.localdomain>
Content-Type: text/plain
Date: Wed, 27 Aug 2008 20:51:31 -0700
Message-Id: <1219895491.6069.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-28 at 07:31 +0400, Alexey Dobriyan wrote:
> > --- a/kernel/rcuclassic.c~rcu-fix-sparse-shadowed-variable-warning
> > +++ a/kernel/rcuclassic.c
> > @@ -561,15 +561,15 @@ static void __rcu_process_callbacks(stru
> >  		local_irq_restore(flags);
> >  
> >  		if (rcu_batch_after(rdp->batch, rcp->pending)) {
> > -			unsigned long flags;
> > +			unsigned long flags2;
> >  
> >  			/* and start it/schedule start if it's a new batch */
> > -			spin_lock_irqsave(&rcp->lock, flags);
> > +			spin_lock_irqsave(&rcp->lock, flags2);
> >  			if (rcu_batch_after(rdp->batch, rcp->pending)) {
> >  				rcp->pending = rdp->batch;
> >  				rcu_start_batch(rcp);
> >  			}
> > -			spin_unlock_irqrestore(&rcp->lock, flags);
> > +			spin_unlock_irqrestore(&rcp->lock, flags2);
> >  		}
> >  	}
> 
> Bzzzrt... just remove second variable.
> 

>From my original e-mail:

It would be safe in this case to just remove the second declaration of flags
and reuse it as it is outside the local_irq_save/restore pair.  I did it
this
way in case there are future changes that might mix up the use of flags.

Feel free to just remove the second flags declaration if you'd rather do
it
that way.

Cheers,

Harvey

