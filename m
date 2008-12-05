Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbYLEVRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbYLEVRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 16:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbYLEVRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 16:17:05 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:21451 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbYLEVRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 16:17:03 -0500
Message-ID: <ac3eb2510812051317q79ca88e9ya876ffb94162eeca@mail.gmail.com>
Date: Fri, 5 Dec 2008 22:17:01 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Evgeniy Polyakov" <zbr@ioremap.net>
Subject: Re: Runaway loop with the current git.
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <20081205211223.GA8075@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081205180350.GA25236@ioremap.net>
	 <20081205181610.518ecd13@lxorguk.ukuu.org.uk>
	 <ac3eb2510812051032g6b5ea866q30f097d765854196@mail.gmail.com>
	 <20081205192755.GA27712@ioremap.net>
	 <20081205193432.290a6f1a@lxorguk.ukuu.org.uk>
	 <20081205211223.GA8075@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2008 at 22:12, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> On Fri, Dec 05, 2008 at 07:34:32PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
>> > I can not run bisect, since reboot requires vnc and I'm far from fast
>> > channel. Build of the fresh tree with existing config takes almost
>> > one hour, but it should not be a major problem.
>> >
>> > I can do bisection after the weekend, but can test some changes before
>> > machine froze with unsuccessful patch.
>>
>> I really have no idea what you are seeing so short of a bisect I've
>> nothing to suggest.
>
> But if things would be in userspace, then it should be fired long ago
> with .27 kernel, no?
>
> And what's with tty drivers? If kernel freezes there even if suddenly
> faulty userspace started to load them, where this can happen? Apparently
> it is not sleeping userspace since console does not respond to input.

5-1 dev_t request looks like something in initramfs accesses
/dev/console, but the driver for it is not properly
initialized/registered that time, and the kernel module loader tries
to load a module? The forked process might also try to access
/dev/console again, and hence the loop?

Kay
