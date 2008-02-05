Return-Path: <linux-kernel-owner+w=401wt.eu-S1762654AbYBEXMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762654AbYBEXMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757861AbYBEXMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:12:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:33765 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756298AbYBEXMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:12:32 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH for review] ACPI: Create /sys/firmware/acpi/interrupts/ counters
Date: Tue, 5 Feb 2008 18:12:09 -0500
User-Agent: KMail/1.9.5
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200802050230.10873.lenb@kernel.org> <20080205221805.GC6950@suse.de>
In-Reply-To: <20080205221805.GC6950@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802051812.09228.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2008 17:18, Greg KH wrote:
> On Tue, Feb 05, 2008 at 02:30:10AM -0500, Len Brown wrote:
> > # cat /sys/firmware/acpi/interrupts/summary
> > pm_timer     0
> > glbl_lock    0
> > power_btn    0
> > sleep_btn    0
> > rtc          0
> > gpe00    0
...
> > gpe1F    0
> > gpe_hi    0
> > gpe_total   63
> > acpi_irq    63
> 
> Eeek!  Why?  What's wrong with individual files here?

My expectation is that this is a shell interface for debugging,
not an API for programs.  ala /proc/interrupts.

if we have 40 individual files, each with a number in it,
it is less convenient to cat the file and paste the results
into an email or bug report and have the receiver easily
see what what count goes with what file -- or is there
a version of cat that prints the file name before
the contents of each file?

I've seen 
more * | cat
but one has to wonder why an interface would be built
to make something so simple not be simple.

> What's to ensure 
> that you aren't going to overflow your buffer?

Good question.  What's to ensure we don't overflow it
when I print any other random string?
Who allocates it and how big is it?

> There's a reason we 
> don't have the seq file interface for sysfs, to prevent this very kind
> of thing...

If sysfs can't handle it, I suppose I could instead
print the needed information to the console....

> > +	/*
> > +	 * General Purpose Events
> > +	 */
> > +	for (i = 0; i < number_of_gpes; i++) {
> > +		count += sprintf(buf + count, "gpe%02X %4d\n",
> > +			i, acpi_gpe_counters[i]);
> > +	}
> 
> Nope, no error checking, fun chance of blowing the memory buffer :(

you're right, there is rumour of a future machine
with more than 32 GPEs...

> Please change the interface to not do this.
> 
> Oh, and for every new sysfs file, you need a Documentation/ABI/
> addition, please also add that.

ok.

thanks,
-Len
