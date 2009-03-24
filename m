Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbZCXWzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbZCXWzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZCXWzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:55:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:39804 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbZCXWzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:55:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dmpFdZ2IZNkSWRgcd2RtAB3HF+sTJxT9XQkt+Fh4QamRDrTzHvo1hkhNmVXzGBJHLs
         w2zMZELrEkO0Otw1m98EW6SVIUaIkV6clG52e+O+CxzMrI4n3qVxFlxXyCTq+zLXD1Je
         CNTGwyBi7cahYOstlj7kurzERqIJ5DRRN1tHA=
Date: Tue, 24 Mar 2009 23:54:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tim Bird <tim.bird@am.sony.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Anyone working on ftrace function graph support on ARM?
Message-ID: <20090324225458.GF5975@nowhere>
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere> <20090324214846.GB29509@elte.hu> <20090324215738.GD5975@nowhere> <20090324221439.GE29509@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324221439.GE29509@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 11:14:39PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Tue, Mar 24, 2009 at 10:48:46PM +0100, Ingo Molnar wrote:
> > > 
> > > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > 
> > > > Well it's a very naive listing, there are sometimes some problems. 
> > > > For example on x86-64, I had to save even some non-scratch 
> > > > registers before calling the return hook, I still don't know why.
> > > 
> > > btw., which are those registers?
> > > 
> > > 	Ingo
> > 
> > 
> > I would expect to only save rax,rdi,rsi,rdx,rcx,r8,r9 which are 
> > used for parameters.
> 
> > And I had some crashes until I append r10 and r11 which actually 
> > are scratch if I'm not wrong, but since they are scratch and are 
> > not used for arguments, I thought they didn't need to be saved.
> > 
> > Well, I think there were some code flow cases I was missing.
> 
> Correct, r10 and r11 are clobbered registers too - and you need to 
> save them too in mcount methods.
> 
> The reason is that mcount has a special calling convention - it's 
> not just about not destroying arguments - GCC can keep data in r10 
> or r11 scratch registers across function calls as well - for example 
> for relatively static functions that are in its local optimization 
> scope.
> 
> If GCC can prove that the local scope function itself does not 
> clobber r10/r11, it does not have to clobber them across the 
> function call. But the mcount() callback still gets inserted.
> 
> So the rule is: mcount must not destroy _any_ register state. 
> (beyond flags)
> 
> 	ngo


Aah, ok, understood!
Thanks.

