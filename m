Return-Path: <linux-kernel-owner+w=401wt.eu-S1755639AbYKZNEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbYKZNEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbYKZNDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 08:03:18 -0500
Received: from mout-bounce.kundenserver.de ([212.227.17.2]:52881 "EHLO
	mout-bounce.kundenserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755017AbYKZNDQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 08:03:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Gleb Natapov <gleb@redhat.com>
Subject: Re: Host<->guest channel interface advice needed
Date: Wed, 26 Nov 2008 14:02:57 +0100
User-Agent: KMail/1.9.9
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20081126123919.GC3521@redhat.com>
In-Reply-To: <20081126123919.GC3521@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811261402.58033.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19WD5dyinswCac4jOyDdpVARzMx7EEoSozbahG
 8tdMtA3m5qlgGzVqMjEuP9n4O5mNhgsHvGpyqcypTHSryjVuLv
 tLHvnvCTDhYfTkpUWZXow==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 November 2008, Gleb Natapov wrote:
> The interfaces that are being considered are netlink socket (only datagram
> semantics, linux specific), new socket family or character device with
> different minor number for each channel. Which one better suits for
> the purpose?  Is there other kind of interface to consider? New socket
> family looks like a good choice, but it would be nice to hear other
> opinions before starting to work on it.

I think a socket and a pty both look reasonable here, but one important
aspect IMHO is that you only need a new kernel driver for the guest, if
you just use the regular pty support or Unix domain sockets in the host.

Obviously, there needs to be some control over permissions, as a guest
most not be able to just open any socket or pty of the host, so a
reasonable approach might be that the guest can only create a socket
or pty that can be opened by the host, but not vice versa. Alternatively,
you create the socket/pty in host userspace and then allow passing that
down into the guest, which creates a virtio device from it.

	Arnd <><
