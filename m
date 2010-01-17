Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312Ab0AQSHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab0AQSHP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 13:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287Ab0AQSHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 13:07:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab0AQSHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 13:07:12 -0500
Date: Sun, 17 Jan 2010 20:04:06 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Michael Stone <michael@laptop.org>
Cc: Anthony Liguori <anthony@codemonkey.ws>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: disablenetwork (v5): Simplify the disablenetwork sendmsg hook.
Message-ID: <20100117180405.GA32339@redhat.com>
References: <20100117161053.GG3420@redhat.com> <20100117170431.GA2949@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100117170431.GA2949@heat>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 17, 2010 at 12:04:32PM -0500, Michael Stone wrote:
> Michael Tsirkin wrote:
>> On Fri, Jan 15, 2010 at 03:12:46AM -0500, Michael Stone wrote:
>>> The idea is that calls like
>>>
>>>    sendto(fd, buffer, len, 0, NULL, 0);
>>>    send(fd, buffer, len, 0)
>>>    write(fd, buffer, len)
>>>
>>> are all to be permitted but that calls like
>>>
>>>    sendto(fd, buffer, len, 0, (struct sockadr *) &addr, sizeof(addr));
>>>
>>> are to be rejected when the current task's network is disabled on the grounds
>>> that the former calls must use previously connected sockets but that the latter
>>> socket need not have been previously connected.
>>>
>>> Signed-off-by: Michael Stone <michael@laptop.org>
>>
>> Michael, if I understand correctly, with this patch one could use
>> disablenetwork to pass an af_packet socket bound to a device to a
>> task, and make sure that the task does not use it to inject packets into
>> another device?
>
> Michael,
>
> Thanks for writing. If I understand you correctly, you're asking:
>
>   May a network-disabled process use recvmsg() with SCM_RIGHTS control messages
>   to receive a file descriptor pointing to previously connected or bound
>   AF_PACKET socket and, having received such an fd, may the network-disabled
>   process use the socket normally?
>
> If I've understood correctly, then the answer is "yes, to the extent that you
> can't do stupid things with sendmsg(), fnctl(), ioctl(), and friends."
>
> I intend to look more carefully at the ability to use those calls to do stupid
> things in coming weeks.
>
> Does this help?
>
> Regards,
>
> Michael
>
> P.S. - Incidentally, what is the nature of your interest?

We discussed using af_packet sockets for networking in qemu.  qemu is a
large project so it might not be a great idea to run it as root all the
time: a better idea is to e.g. get fd from a priveledged server.
However, we'd like to limit qemu even more, so that it can only use the
fd for send/receive.

> (And was your question intentionally or accidentally off-list?)

Oops. Adding it back.

-- 
MST
