Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbXFTO0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbXFTO0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 10:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbXFTO0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 10:26:03 -0400
Received: from smtp002.mail.ukl.yahoo.com ([217.12.11.33]:47161 "HELO
	smtp002.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752231AbXFTO0A convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 10:26:00 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jun 2007 10:25:59 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=17o5U7Zr5L2sqBhu7F6gblQ7jy8XcgjK6jpuNsMEXLt7zsoFAaQEpdVLdLRBv6V8aP7LB4m5QEd3EmIwJS1eyGxUMMImIP4LnJUDNG9NmJwQ1U/bluxSNX1ENML0ePoxCgEuf2JDhjqWEnRZINbsBtk90e3RPz3PaDdV2eAIHsc=  ;
X-YMail-OSG: 886Bz6oVM1lSgcEzwJj9oAeXT8Btmp9r8.i4crHDqSIAGpvz1tqKLOtiNgkJvZtd6siKAXg62zdPicl2N4.f45yCV2OnnvN8ga7AXaYn0sWk8qG1
From: Blaisorblade <blaisorblade@yahoo.it>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH 2/2] UML - Add stack usage monitoring
Date: Wed, 20 Jun 2007 16:06:58 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Dike <jdike@addtoit.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <20070619184245.GA10567@c2.user-mode-linux.org> <20070619195003.GA11718@c2.user-mode-linux.org> <20070619131441.01b5ae4b.akpm@linux-foundation.org>
In-Reply-To: <20070619131441.01b5ae4b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706201606.58331.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On martedì 19 giugno 2007, Andrew Morton wrote:
> On Tue, 19 Jun 2007 15:50:03 -0400
>
> Jeff Dike <jdike@addtoit.com> wrote:
> > On Tue, Jun 19, 2007 at 11:54:22AM -0700, Andrew Morton wrote:
> > > On Tue, 19 Jun 2007 14:42:45 -0400
> > >
> > > Jeff Dike <jdike@addtoit.com> wrote:
> > > > Add a machanism to see how much of a kernel stack is used.  This
> > > > allocates zeroed stacks and sees where the lowest non-zero byte is on
> > > > process exit.  It keeps track of the lowest value and logs values as
> > > > they get lower.
> > >
> > > remind us again why the generic code is unsuitable?
> >
> > It does something different - it will tell you the greatest stack
> > usage of any currently running process.  What I want to be able to do
> > is run a workload and come back a few days later and see how close
> > anything came to running out of stack.
>
> <looks>
>
> wth?  I'm _sure_ we used to have code in there which would, within
> do_exit(), work out the maximum amount of kernel stack which a task had
> used and if that was max-since-boot, drop a printk.
>
> Maybe I dreamed it, but I don't think so.
>
> I wonder where it went?

Oh, it's exactly what CONFIG_DEBUG_STACK_USAGE does for i386... (not sure if 
you were still wondering...).

> Oh well.  Your new code should really be generic, utilising the
> stack-page-zeroing which CONFIG_DEBUG_STACK_USAGE enables.  There's nothing
> UML-specific about it.

> low_water_lock and lowest_to_date should be static to check_stack_usage(),
> btw..

-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
