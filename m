Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbXKZKxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbXKZKxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 05:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbXKZKxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 05:53:20 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:63257 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbXKZKxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 05:53:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S0wgPdmfMTB1gzwlg77fY/5bab77/mK9FzYGCuOjHH8S87vwqU8bE11SE8sUqQuWLoLlVfRbqa2JA54sknB9B+dJ+1m+P/L5YPpSV+0VLDvkcBDsQsISBy3z+u9hGA5hZcTwEfmXuN0cnKllITQWhL+ntryUan1EHw36RFOp12U=
Message-ID: <b25c3fa70711260253we514310g2652d40440dc514e@mail.gmail.com>
Date: Mon, 26 Nov 2007 19:53:19 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: [PATCH 4/4] atm/ambassador: kmalloc + memset conversion to kzalloc
Cc: netdev@vger.kernel.org, chas@cmf.nrl.navy.mil,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.0.9999.0711260523420.12603@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <007f01c8300b$1b89ac40$9c94fea9@jason>
	 <alpine.LFD.0.9999.0711260409110.551@localhost.localdomain>
	 <b25c3fa70711260223w5a15bb1bk4652b3ab8f05c40c@mail.gmail.com>
	 <alpine.LFD.0.9999.0711260523420.12603@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/11/26, Robert P. J. Day <rpjday@crashcourse.ca>:
> i realized that.  but all you can say is that only amb_init() calls
> setup_dev() *currently*.  when you're not looking, someone else might
> (for whatever reason) call setup_dev() from elsewhere, and *that* call
> might not zero that memory area.
>
> IMHO, the only safe transforms of kmalloc+memset -> kzalloc are those
> in which the flow of control is unmistakable and invariant.  splitting
> that across a function call seems like a dangerous thing to do.
> (except, of course, in the case, where the kzalloc() is added inside
> the function -- then all callers are entitled to simplify *their*
> code.  but that's different.)
>
> in any event, i just thought i'd point it out.  if you're absolutely
> sure there will never be another call to setup_dev() from somewhere
> else, then, yes, it's safe.
>

I understood your opinions. and partially agree with you.
But isn't it a unfounded fear?

Thanks
Joonwoo
