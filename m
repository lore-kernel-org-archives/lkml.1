Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbXIYBqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbXIYBqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 21:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbXIYBqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 21:46:44 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:47217
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754821AbXIYBqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 21:46:43 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Joe Perches <joe@perches.com>
Subject: Re: [RFC] New kernel-message logging API
Date: Mon, 24 Sep 2007 20:46:40 -0500
User-Agent: KMail/1.9.6
Cc: holzheu@linux.vnet.ibm.com, Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Dick Streefland <dick.streefland@altium.nl>
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com> <200709241851.59611.rob@landley.net> <1190679032.636.7.camel@localhost>
In-Reply-To: <1190679032.636.7.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709242046.40244.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 September 2007 7:10:32 pm Joe Perches wrote:
> On Mon, 2007-09-24 at 18:51 -0500, Rob Landley wrote:
> > > An added pass between gcc preprocessor and compiler could compact
> > > or compress the format string without modifying the conversion
> > > specifications so __attribute__ ((format (printf)) would still work.
> >
> > This does not address my problem.  Spitting out a proprietary hash code
> > instead of a human readable message is not a solution for my use case.
>
> What is your problem Rob?

The single largest space savings in the existing -tiny patches comes from 
removing printk() calls and strings.  I would like to be able to selectively 
do this based on severity level, which is information most existing printk() 
calls already have.  I proposed a minimal change to how printk() works, 
allowing the compiler to remove unused code that wouldn't be below the 
displayed level of printk() anyway in the deployed product so wouldn't 
actually lose any output.

The kernel image is usually already compressed in flash and decompressed to 
dram during boot.  (Not always, sometimes it's run directly out of flash, but 
there's often a speed penalty for doing this, you have to set it up 
specially, and dram is cheaper than flash anyway.)  This means recompressing 
it doesn't help save flash.

If you want to save dram, have printk and associated strings be a function in 
a module that's demand loaded and unloaded again after each call.  Then you 
can foist compression off on userspace, and we're already used to modules 
having to match a given kernel version exactly.  Why come up with new 
infrastructure?

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
