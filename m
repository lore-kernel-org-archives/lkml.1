Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbZEJCL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbZEJCL3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 22:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbZEJCLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 22:11:19 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44680 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbZEJCLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 22:11:19 -0400
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>
References: <1241097822.2516.3.camel@poy> <m1vdodnx8e.fsf@fess.ebiederm.org>
	<ac3eb2510905070228w5ecb5aa9ob24af17a91d2f231@mail.gmail.com>
	<m1skjd4x7o.fsf@fess.ebiederm.org>
	<ac3eb2510905091756q451d4e13r4a0397e36ff101bb@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 09 May 2009 19:11:14 -0700
In-Reply-To: <ac3eb2510905091756q451d4e13r4a0397e36ff101bb@mail.gmail.com> (Kay Sievers's message of "Sun\, 10 May 2009 02\:56\:44 +0200")
Message-ID: <m1bpq11zct.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: kay.sievers@vrfy.org, jblunck@suse.de, greg@kroah.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kay Sievers <kay.sievers@vrfy.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4478]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> writes:

>> My primary concern is that you are inventing a new mechanism when
>> the existing mechanism has known issues that could explain the slowdowns.
>
> You mean that mounting a new tmpfs at /dev has the issue of being
> empty?

I was thinking more along the lines of a single global lock for all of
sysfs,.

> And it takes time to fill it, where you can't reliably do other
> things at the same time that might need device nodes? Yeah, I guess
> that's an issue with the existing mechanism, and I'm interested in
> your proposal to solve it.

As for that question why not.

initramfs has always come prepopulated with device nodes.

It isn't a challenge to mount a new tmpfs somewhere else populate it
with the basics and them move it onto tmp.

I would be very surprised if you needed much more than /dev/console,
/dev/zero and /dev/null for reliable operation of most programs.

The rest just looks like ensuring you can deal with root (or what
ever device you care about) showing up after things start running.
With usb devices apparently not having a guaranteed maximum wait
and things like dhcp required for network connectivity I don't see
where adding code to wait for you device to show up would be
unnecessary logic.

That said it might make sense to be able to kick off udevd or similar
before /sbin/init was exec'd.  I don't know how much that would gain.

Numbers like 2 seconds sound absolutely huge in cpu time.  And I don't
have a clue why udev would take anywhere near that long even doing
everything synchronously.  Have you instrumented things up to
see what takes that much time?

Eric
