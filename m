Return-Path: <linux-kernel-owner+w=401wt.eu-S1757007AbZLFBqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007AbZLFBqf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 20:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbZLFBqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 20:46:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50270 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349AbZLFBqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 20:46:30 -0500
Message-ID: <4B1B0D40.3040209@gmail.com>
Date: Sun, 06 Dec 2009 02:47:44 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: lenb@kernel.org, astarikovskiy@suse.de, mchehab@infradead.org,
       linville@tuxdriver.com, miklos@szeredi.hu, davem@davemloft.net,
       rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
       avi@redhat.com, mtosatti@redhat.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 11/31] Constify struct file_operations for 2.6.32 v1
References: <4B198670.2000406@gmail.com> <4B198C43.50205@gmail.com> <4B19A333.5080103@gmail.com> <20091205000942.GA8224@suse.de> <4B19CA6F.4090700@gmail.com> <20091205041507.GA24885@suse.de>
In-Reply-To: <20091205041507.GA24885@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Dec 05, 2009 at 03:50:23AM +0100, Emese Revfy wrote:
>> Greg KH wrote:
>>> On Sat, Dec 05, 2009 at 01:02:59AM +0100, Emese Revfy wrote:
>>>> -static struct file_operations ptmx_fops;
>>>> +static const struct file_operations ptmx_fops = {
>>>> +	.llseek		= no_llseek,
>>>> +	.read		= tty_read,
>>>> +	.write		= tty_write,
>>>> +	.poll		= tty_poll,
>>>> +	.unlocked_ioctl	= tty_ioctl,
>>>> +	.compat_ioctl	= tty_compat_ioctl,
>>>> +	.open		= ptmx_open,
>>>> +	.release	= tty_release,
>>>> +	.fasync		= tty_fasync,
>>>> +};
>>> You just made these functions all global, for no real good reason.  Why
>>> did you do this?
>> I think this is the only way to make ptmx_fops const, provided we want to. 
> 
> Why do we want to?

Because I saw that checkpatch.pl itself tries to ensure the same I went
through the whole tree looking for non-const file_operations structures
and tried to make them const as best as I could. If you think making
ptmx_fops const is not worth the effort I will remove it from the patch.
--
Emese
