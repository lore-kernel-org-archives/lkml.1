Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab0CJAHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 19:07:06 -0500
Received: from mail.perches.com ([173.55.12.10]:1573 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab0CJAHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 19:07:01 -0500
Subject: Re: Tuxradar patching article and [PATCH]
 scripts/cvt_kernel_style.pl
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, devel <devel@driverdev.osuosl.org>,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <20100309234152.GA30270@suse.de>
References: <1268177526.1545.62.camel@Joe-Laptop.home>
	 <20100309234152.GA30270@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Mar 2010 16:06:59 -0800
Message-ID: <1268179619.1545.95.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 15:41 -0800, Greg KH wrote:
> On Tue, Mar 09, 2010 at 03:32:06PM -0800, Joe Perches wrote:
> > There was an article published recently:
> > http://www.tuxradar.com/content/newbies-guide-hacking-linux-kernel
> > that seems to have prompted several new contributors (welcome)
> > to create style reformatting patches.
> > 
> > The article recommends running checkpatch and fixing the various
> > non-conforming style elements the output produces.
> > 
> > A better solution might be to enhance checkpatch to rewrite the
> > patch or a file with -f, but that's more than I'd like to do.
> 
> I _really_ dislike automatic source conversions by a tool and do not
> recommend doing that at all.

Don't be silly.

You take automatic conversions from tools like coccinelle all
the time.

What I found poorly written about the article was
unfortunately you apparently recommend things like:

        if (error != -ENODEV) {
                foo();
                bar();
        } else {
        	report_error();
        	goto exit;
        }
        
instead of:

        if (error == -ENODEV) {
        	report_error();
        	goto exit;
        }
        foo();
        bar();

and the brace removal example was unfortunate because
it used printk without KERN_<level> without explanation.

I think there wasn't enough emphasis on compiling the new
patched file with something like a .o or .lst comparison
to the unmodified source to make sure it was OK to send
to the list.

> It's better that you look at the code yourself, and make the change that
> looks correct, which is not always the same thing that an automated tool
> would do.

I disagree.

It's better to make changes that _actually are_ correct.
People also neglect to see and convert a lot of things.

Tools can make coverage a bit better which is why a tool
like checkpatch exists in the first place.

> Becides, we have the Lindent script, which does almost exactly what you
> are trying to do here, why reinvent the wheel?

Lindent does a relatively poor job at conversions,
and it's all or nothing.  A tool that could be used
to selectively perform various conversions would be
better and could produce patches that are human
verifiable.

For instance, look at what happened with the old
reiserfs changes.

Lindent badly mucked up comments, did a poor job at
columnarization of variable declarations, didn't
understand c99 very well, was wretched at 80 columns,
etc.

I think the Lindent script should be deprecated and
checkpatch enhanced myself.  And until then, I think
a script like cvt_kernel_style.pl has some use.

cheers, Joe

