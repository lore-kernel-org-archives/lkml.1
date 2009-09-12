Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbZILUvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbZILUvL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 16:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbZILUvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 16:51:10 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40034 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbZILUvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 16:51:09 -0400
To: Stefani Seibold <stefani@seibold.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
References: <1251563892.13287.11.camel@wall-e>
	<20090829231650.GA29419@infradead.org>
	<1251659144.20987.18.camel@wall-e>
	<20090912152814.GG5858@ZenIV.linux.org.uk>
	<1252771068.29135.25.camel@wall-e>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 12 Sep 2009 13:51:02 -0700
In-Reply-To: <1252771068.29135.25.camel@wall-e> (Stefani Seibold's message of "Sat\, 12 Sep 2009 17\:57\:48 +0200")
Message-ID: <m1r5ubdgzt.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stefani Seibold <stefani@seibold.net>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] Fix proc_file_write missing ppos update
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefani Seibold <stefani@seibold.net> writes:

> Am Samstag, den 12.09.2009, 16:28 +0100 schrieb Al Viro:
>> On Sun, Aug 30, 2009 at 09:05:44PM +0200, Stefani Seibold wrote:
>> > Switching all users of read_proc_t/write_proc_t to file operation is a
>> > huge job. About 180 files must be fixed.
>> > 
>> > But the main reason not to do this is because the breakage of "out of
>> > tree" drivers.
>> 
>> > I like the current simplified proc interface. It saves a lot of code
>> > duplication because the basic operations will be handled inside the
>> > kernel and not in the driver.
>> 
>> _What_ code duplication?  Would that be
>>         struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
>> and calculation of pde->data currently done by proc_file_write()?
>> Pardon me, but that's hard to take seriously.  As for the ->read() side,
>> most of those suckers end up switched to use of seq_read() and there's
>> not a lot of boilerplate code in the resulting variants...
>
> Hi Al, you are 2 weeks to late, the discussion has already ended. But
> lets start it again.... 
>
> There is some code duplication, proc_file_write has 17 lines of code.
> And together with my path it will be 19 lines of code. How much lines of
> duplicated code are necessary for take them seriously? 
>
> I know that the current mainstream development targets enterprise and
> maybe sometime desktop systems. But the truth is that linux will be
> mostly used in embedded system with very limited memory constrains.
>
> BTW: I personally think the whole seq_.... interface is IMHO to
> complicate to use, procfs is much simpler. But this is only my personal
> opinion! 

The point of all of this is that you are trying to enhance an
interface that is essentially deprecated.  We don't want to use it
anymore because at least on the read side there are recurring problems
with buffer overflows and reads not handling seeks properly, etc.  So
everything is slowing switching being fixed and taken off of the
current proc_file_read/proc_file_write handlers.

Eric
