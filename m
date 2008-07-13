Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbYGMUY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbYGMUY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 16:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbYGMUYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 16:24:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45216 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbYGMUYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 16:24:20 -0400
Message-ID: <487A62B3.8010207@zytor.com>
Date: Sun, 13 Jul 2008 13:16:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andy Lutomirski <luto@myrealbox.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@lo.gmane.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
References: <200807010148.02135.rjw@sisk.pl> <200807122253.32382.rjw@sisk.pl> <48793A0E.3050803@myrealbox.com> <200807130133.12324.rjw@sisk.pl> <20080713091524.GA29907@elte.hu> <20080713120253.GA27582@srcf.ucam.org> <487A2431.2050103@myrealbox.com> <487A4CB7.1080001@firstfloor.org>
In-Reply-To: <487A4CB7.1080001@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> Hmm, but the change was not supposed to break the s3 bios. Something
> fishy is going on. It sounds like the s3 bios relies on some earlier
> segment register setup.
> 
> If true this means the segment register reset would need to be moved
> later after S3 bios ran. Saving/restoring is unfortunately not possible
> because we cannot save/restore the hidden state loaded from the GDT earlier.
> 

That really doesn't make sense, though.  The VESA BIOS has to be entered 
in clean real mode; it's designed to be entered from reset, after all. 
There is definitely something fishy going on, but I don't think this 
particular aspect is it.

What's *really* odd is that this was required with the old code but 
doesn't work at all with the new code.  The former is understandable, 
the latter is not.

	-hpa
