Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbYFVKDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbYFVKDO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 06:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbYFVKC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 06:02:59 -0400
Received: from wr-out-0708.google.com ([64.233.184.247]:20574 "EHLO
	wr-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYFVKC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 06:02:57 -0400
MIME-Version: 1.0
Date: Sun, 22 Jun 2008 03:02:52 -0700 (PDT)
In-Reply-To: <aHtAJ-8bW-11@gated-at.bofh.it>
X-IP: 144.32.61.2
References: <aHtAJ-8bW-11@gated-at.bofh.it>
User-Agent: G2/1.0
X-HTTP-UserAgent: Mozilla/5.0 (compatible; Konqueror/3.5; Linux) KHTML/3.5.9 
	(like Gecko) (Kubuntu),gzip(gfe),gzip(gfe)
Message-ID: <d67fe091-02b8-4587-8d25-e521d8eb2d2d@d77g2000hsb.googlegroups.com>
Subject: Re: Sending UDP packets to port 0
From: Alan Jenkins <aj504@cs.york.ac.uk>
To: "Christian P. Schmidt" <schmidt@digadd.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian P. Schmidt wrote:
> Hi all,
>
> I know that the kernel forbids sending UDP packets to port 0. Is there a
> specific reason for this?

_Source_ port 0 is treated specially in the sockets implementation,
though I'm not sure  whether this is an intended feature of the API
(manpages don't mention it).  If you say "bind to port 0", you get an
arbitrary unused port instead, which is potentially useful.

> I'm asking because I regularly need to access a device that asks for
> tftp files using port 0 as source. To use these devices I'm using a
> kernel with removed port 0 checks.
>
> I read RFC 768, and it does not explicitly forbid the use of port 0 as
> far as I can see. It only says that if unused, 0 is to be inserted.

1. No, it only says that about the source port.
2. The only way to tell whether the field is "unused" is to check for
a 0 value.

> RFC 1350 (TFTP) even states explicitly:
> The transfer identifiers (TID's) used by TFTP are passed to the Datagram
> layer to be used as ports; therefore they must be between 0 and 65,535.
>
> In my understanding, and apparently that of the authors of the
> appliance's tftp client implementation, this marks port 0 as valid.

They're a bit mad then.  RFC1700 marks port 0 as "reserved" (other
unused ports are marked "unassigned").

I hope that explains why most sane people would avoid using port 0.  I
can't think of a specific reason for forbidding port 0 as a
destination; it's just generally not expected (and there was no reason
to allow it).  I think you need to be more specific if you hope to
have this check removed in mainline though.

Which TCP/IP stacks is the device tested/supported against?  Are you
saying Windows or some other OS lets you send to port 0?
