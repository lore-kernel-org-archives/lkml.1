Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbYFBWal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbYFBWal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 18:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYFBWad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 18:30:33 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43564 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbYFBWac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 18:30:32 -0400
Subject: Re: kvm causing memory corruption?  now 2.6.26-rc4
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       "Anthony N. Liguori [imap]" <aliguori@us.ibm.com>
In-Reply-To: <47EBB63E.2060306@qumranet.com>
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>
	 <47EA1C63.8010202@qumranet.com>
	 <1206550329.7883.5.camel@nimitz.home.sr71.net>
	 <47EA80AC.4070204@qumranet.com>
	 <1206551794.7883.7.camel@nimitz.home.sr71.net>
	 <47EB6AAC.3040607@qumranet.com>  <47EB7281.6070300@qumranet.com>
	 <1206629709.7883.30.camel@nimitz.home.sr71.net>
	 <47EBB63E.2060306@qumranet.com>
Content-Type: text/plain
Date: Mon, 02 Jun 2008 15:30:10 -0700
Message-Id: <1212445810.8211.9.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-27 at 16:59 +0200, Avi Kivity wrote:
> Dave Hansen wrote:
> > On Thu, 2008-03-27 at 12:10 +0200, Avi Kivity wrote:
> >> btw, is this with >= 4GB RAM on the host?
> >
> > Well, are you asking whether I have PAE on or not? :)  
> 
> No, I'm asking whether there is a possibility of address truncation :)
> 
> PAE by itself doesn't affect kvm much, as it always runs the guest in 
> pae mode.
> 
> Can you try running with mem=2000M or something?

I have a few more data points on this.  Sorry for the massive delay from
the last report -- I'm being a crappy bug reporter.  But, this is on my
one and only laptop which makes it a serious pain to diagnose.  I also
didn't have a hardware serial console on it before, which I do now.
This is all on 2.6.26-rc4-01549-g1beee8d.

Adding the mem= does not help at all.  But, it is all a bit more
diagnosable now than a month or two ago.  I turned on all of the kernel
debugging that I could get my grubby little hands on.  It now oopses
quite consistently when kvm runs instead of after.  Here's a collection
of oopses that I captured after setting up a serial line:

	http://sr71.net/~dave/kvm-oops1.txt

After collecting all those, I turned on CONFIG_DEBUG_HIGHMEM and the
oopses miraculously stopped.  But, the guest hung (for at least 5
minutes or so) during windows bootup, pegging my host CPU.  Most of the
CPU was going to klogd, so I checked dmesg.

I was seeing messages like this

[  428.918108] kvm_handle_exit: unexpected, valid vectoring info and exit reason is 0x9

And quite a few of them, like 100,000/sec.  That's why klogd was pegging
the CPU.  Any idea on a next debugging step?

-- Dave

