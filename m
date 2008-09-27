Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbYI0HPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbYI0HPr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 03:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbYI0HPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 03:15:38 -0400
Received: from ozlabs.org ([203.10.76.45]:48137 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbYI0HPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 03:15:37 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: schwidefsky@de.ibm.com
Subject: Re: [patch 1/6] kmsg: tagged kernel messages.
Date: Sat, 27 Sep 2008 17:15:32 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       lf_kernel_messages@lists.linux-foundation.org, Greg KH <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, Joe Perches <joe@perches.com>,
       Tim Hockin <thockin@hockin.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Holzheu <holzheu@de.ibm.com>, Gerrit Huizenga <gh@us.ibm.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Jan Kara <jack@suse.cz>,
       Pavel Machek <pavel@ucw.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Jochen =?utf-8?q?Vo=C3=9F?= <jochen.voss@googlemail.com>,
       Kunai Takashi <kunai@linux-foundation.jp>,
       Tim Bird <tim.bird@am.sony.com>, Jan Blunck <jblunck@suse.de>,
       Rick Troth <rmt@casita.net>, Utz Bacher <utz.bacher@de.ibm.com>
References: <20080925162827.818261893@de.ibm.com> <200809261448.05391.rusty@rustcorp.com.au> <1222417774.22679.2.camel@localhost>
In-Reply-To: <1222417774.22679.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809271715.33968.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 September 2008 18:29:34 Martin Schwidefsky wrote:
> On Fri, 2008-09-26 at 14:48 +1000, Rusty Russell wrote:
> > On Friday 26 September 2008 02:28:28 Martin Schwidefsky wrote:
> > > +#define kmsg_emerg(fmt, ...) \
> > > +	kmsg_printk_hash(KERN_EMERG, fmt, ##__VA_ARGS__)
> > > +#define kmsg_alert(fmt, ...) \
> > > +	kmsg_printk_hash(KERN_ALERT, fmt, ##__VA_ARGS__)
> > > +#define kmsg_crit(fmt, ...) \
> > > +	kmsg_printk_hash(KERN_CRIT, fmt, ##__VA_ARGS__)
> > > +#define kmsg_err(fmt, ...) \
> > > +	kmsg_printk_hash(KERN_ERR, fmt, ##__VA_ARGS__)
> > > +#define kmsg_warn(fmt, ...) \
> > > +	kmsg_printk_hash(KERN_WARNING, fmt, ##__VA_ARGS__)
> > > +#define kmsg_notice(fmt, ...) \
> > > +	kmsg_printk_hash(KERN_NOTICE, fmt, ##__VA_ARGS__)
> > > +#define kmsg_info(fmt, ...) \
> > > +	kmsg_printk_hash(KERN_INFO, fmt, ##__VA_ARGS__)
> >
> > Now I'm going to be an asshole and ask you to define when each of these
> > levels should be used.  Do we need all of them?
>
> These are just the regular printk levels. If your old printk used a
> particular level, have the kmsg_xxx printk use the same level. The
> question about message severity and message documenation are
> independent, aren't they?

Yes, but since it's a new message API, I thought you might have an idea.  It's 
hard for authors (eg. me) to know which level to use.  As a result, levels 
currently seem to be chosen randomly.

If you felt inspired to rationalize them, it would let us clean that up as 
things moved to kmsg :)

Cheers,
Rusty.
