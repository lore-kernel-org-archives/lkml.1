Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbXJIF0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbXJIF0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 01:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbXJIF0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 01:26:47 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:28124 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751399AbXJIF0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 01:26:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mdCtqHvWgmokLzyUNenql9GTsyWtpvRQAAKhNPpyuHlweZLIYC9WUB8pxePpQ322dNB6MkmKO9DNcwHO5ER0oYEZO2pIZR0SXt/fyiUbMlFtNpt0C1jJZ/0iACmjD9NECnpmzl5Xy4GbFAjoZ1MYnM5X5iVgUrQfX6jwrR1A7+A=  ;
X-YMail-OSG: VDMz8h8VM1nRCqjvO1UMTTFtEfXgrrai3K87kh.KpcoCa3ng6qnm_3bdqnI8O1zs4uFr1EcUlg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [13/18] x86_64: Allow fallback for the stack
Date: Mon, 8 Oct 2007 22:55:05 +1000
User-Agent: KMail/1.9.5
Cc: Rik van Riel <riel@redhat.com>, Andi Kleen <ak@suse.de>,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, travis@sgi.com
References: <20071004035935.042951211@sgi.com> <200710071735.41386.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0710081032030.26382@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0710081032030.26382@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710082255.05598.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2007 03:36, Christoph Lameter wrote:
> On Sun, 7 Oct 2007, Nick Piggin wrote:
> > > The problem can become non-rare on special low memory machines doing
> > > wild swapping things though.
> >
> > But only your huge systems will be using huge stacks?
>
> I have no idea who else would be using such a feature. Relaxing the tight
> memory restrictions on stack use may allow placing larger structures on
> the stack in general.

The tight memory restrictions on stack usage do not come about because
of the difficulty in increasing the stack size :) It is because we want to
keep stack sizes small!

Increasing the stack size 4K uses another 4MB of memory for every 1000
threads you have, right?

It would take a lot of good reason to move away from the general direction
we've been taking over the past years that 4/8K stacks are a good idea for
regular 32 and 64 bit builds in general.


> I have some concerns about the medium NUMA systems (a few dozen of nodes)
> also running out of stack since more data is placed on the stack through
> the policy layer and since we may end up with a couple of stacked
> filesystems. Most of the current NUMA systems on x86_64 are basically
> two nodes on one motherboard. The use of NUMA controls is likely
> limited there and the complexity of the filesystems is also not high.

The solution has until now always been to fix the problems so they don't
use so much stack. Maybe a bigger stack is OK for you for 1024+ CPU
systems, but I don't think you'd be able to make that assumption for most
normal systems.
