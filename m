Return-Path: <linux-kernel-owner+w=401wt.eu-S932912AbXGZPTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912AbXGZPTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758435AbXGZPTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:19:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59271 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519AbXGZPTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:19:12 -0400
Message-ID: <46A8BB6C.6050903@zytor.com>
Date: Thu, 26 Jul 2007 08:19:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Xudong Guan <xudong.guan@gmail.com>
CC: Borislav Petkov <bbpetkov@yahoo.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1: no setup signature found...
References: <20070724112618.GA4431@gollum.tnic> <20070726150854.GA7034@xguan-laptop>
In-Reply-To: <20070726150854.GA7034@xguan-laptop>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xudong Guan wrote:
> On 13:26(+0200) Tue 24 Jul, Borislav Petkov wrote:
>>    2.6.23-rc1 won't boot on my Asus M6N laptop and the last thing it shows after loading
>> grub is "No setup signature found...," which, imho, comes from
>> arch/i386/boot/header.S. I tried printing out the value of setup_sig like so
> 
> I hitted the same error message with v2.6.23-rc1-171-ge4903fb.
> No problem with v2.6.21-3770-g01e73be.
> Seems there has been some cleanup of the i386/boot code.
> Anyone can give a quick clue, or should I do a bisect?

The bisect will almost guaranteed show a change at the change to the new
setup code.  The message means that the setup code wasn't loaded
correctly into memory; the big question is *why*.

What distro/version of grub are you running?  I'm wondering if there are
some old version of grub out there which did the "load four sectors"
way-anciently-obsolete crap; the other possibility that comes to mind is
setting up the stack in an invalid manner.

	-hpa
