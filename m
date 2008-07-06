Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbYGFDOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbYGFDOz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 23:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbYGFDOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 23:14:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44178 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbYGFDOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 23:14:48 -0400
Message-ID: <487036D7.4050400@zytor.com>
Date: Sat, 05 Jul 2008 20:07:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Sean Young <sean@mess.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: Regression: boot failure on AMD Elan TS-5500
References: <20080616121138.GA51097@atlantis.8hz.com>	<200806162327.34912.rusty@rustcorp.com.au> <48566C88.6000702@goop.org>	<20080616161944.GA53539@atlantis.8hz.com>	<20080630214347.GA57988@atlantis.8hz.com> <4869558A.9020907@goop.org>	<20080630220939.GA58260@atlantis.8hz.com> <m17ibz4tu4.fsf@frodo.ebiederm.org>
In-Reply-To: <m17ibz4tu4.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Sean Young <sean@mess.org> writes:
> 
>> On Mon, Jun 30, 2008 at 02:52:10PM -0700, Jeremy Fitzhardinge wrote:
>>> It's a bit odd that the boot loader neglected to set up ds properly, but 
>>> changing the testb line to
>>>
>>> 	testb $(1<<6), %cs:BP_loadflags(%esi)
>>>
>>> should work.  (Or perhaps a %ss: override would be better?)
>> Yup, it does (%cs: prefix).
> 
> Guys I have a fuzzy memory of reads and definitely writes through %cs not working,
> on some processor models.  i386?
> 

You can never write through %cs in protected mode.

You can read through %cs: in protected mode unless %cs contains an 
execute-only descriptor.

	-hpa
