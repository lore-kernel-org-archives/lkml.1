Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886Ab0ADTPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab0ADTPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 14:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728Ab0ADTPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 14:15:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56316 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab0ADTPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 14:15:52 -0500
Message-ID: <4B423E24.90106@zytor.com>
Date: Mon, 04 Jan 2010 11:14:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Yinghai Lu <yinghai@kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDEV list <netdev@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: Subject: [PATCH 1/2] x86: get back 15 vectors
References: <4B347AEE.6030705@kernel.org> <20091228094707.GH24690@elte.hu>	<4B398ECD.1080506@kernel.org>	<4807377b1001031906s6b1ee576jc021da2642bb4147@mail.gmail.com>	<4B415E73.1050801@kernel.org> <4B419113.1090204@kernel.org>	<m1aawtlu6y.fsf@fess.ebiederm.org> <4B42362F.7040302@kernel.org> <m1vdfhhesx.fsf@fess.ebiederm.org>
In-Reply-To: <m1vdfhhesx.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2010 11:04 AM, Eric W. Biederman wrote:
>>
>> any reason that we can not use 0x40?
> 
> Not that I now of.  Reading the comment it looks like it was only
> skipped so that the initial assignment of vectors would be.
> 
> 0x31, 0x41, 0x51, 0x61, 0x71, 0x81, 0x91, 0xa1, 0xb1, 0xc1, 0xd1, 0xe1
> Instead of.
> 0x30, 0x40, 0x50, 0x60, 0x70, 0x90, 0xa0, 0xb0, 0xc0, 0xc0, 0xe0
> 
> Which doesn't seem to be the worst notion, but at the point we are looking
> for every vector we can get it does seem to be problematic.
> 

This can presumably be worked around by tweaking the initial assignment
algorithm slightly, without losing a whole vector to that.

Also, if we abuse vector 0x1f as the IRQ reassignment vector, we free up
a full 16 vectors per CPU -- this seems worthwhile especially since it
is a decision that can be trivially undone in the future: this is all
kernel internal, we're not creating any kind of API.

	-hpa
