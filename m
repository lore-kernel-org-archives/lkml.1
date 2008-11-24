Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbYKXEIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbYKXEIx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 23:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYKXEIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 23:08:44 -0500
Received: from ozlabs.org ([203.10.76.45]:43949 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbYKXEIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 23:08:43 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg KH <gregkh@suse.de>
Subject: Re: linux-next: rr tree build failure
Date: Mon, 24 Nov 2008 14:38:36 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       Pete Zaitcev <zaitcev@redhat.com>
References: <20081121141913.90d05091.sfr@canb.auug.org.au> <200811221301.07058.rusty@rustcorp.com.au> <20081122064132.GA6196@suse.de>
In-Reply-To: <20081122064132.GA6196@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811241438.36973.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 November 2008 17:11:32 Greg KH wrote:
> On Sat, Nov 22, 2008 at 01:01:06PM +1030, Rusty Russell wrote:
> > Fair enough.  Patch below does this as moduleparam.h suggests.
> >
> > It still means that the paremeter appears in
> > /sys/module/kernel/parameters/nousb OR
> > /sys/module/usbcore/parameters/nousb.
>
> What's the "OR" part?  What determines where it goes?

Whether usbcore is a module or not, of course.

> > +/* To disable USB, kernel command line is 'nousb' not 'usbcore.nousb' */
> > +#undef MODULE_PARAM_PREFIX
> > +#define MODULE_PARAM_PREFIX
> > +module_param(nousb, bool, 0444);
>
> That undef seems hacky beyond belief.

*Exactly*.  And while you're not the first person to do this, you're the one 
one to use it for code which can be a module :(

> How would one know to do this?

The same way Pete found __module_param_call, by reading the header:

 /* You can override this manually, but generally this should match the
    module name. */
 #ifdef MODULE
 #define MODULE_PARAM_PREFIX /* empty */
 #else
 #define MODULE_PARAM_PREFIX KBUILD_MODNAME "."
 #endif

Cheers,
Rusty.
