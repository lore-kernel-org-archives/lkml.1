Return-Path: <linux-kernel-owner+w=401wt.eu-S1757338AbYILRM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbYILRM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 13:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbYILRMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 13:12:17 -0400
Received: from c60.cesmail.net ([216.154.195.49]:34923 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbYILRMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 13:12:16 -0400
Subject: Re: I need help with a sparse warning
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Roland Dreier <rdreier@cisco.com>, LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48C9DC5C.3040109@lwfinger.net>
References: <48C9D040.8010107@lwfinger.net> <ada4p4mm6iy.fsf@cisco.com>
	 <48C9DC5C.3040109@lwfinger.net>
Content-Type: text/plain
Date: Fri, 12 Sep 2008 13:12:12 -0400
Message-Id: <1221239532.13346.5.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-11 at 22:05 -0500, Larry Finger wrote:
> > I would guess you want something like:
> > 
> > 	priv->rx_mtu = le16_to_cpu(((__force __le16 *) bootrec->data)[20]);
> > 
> > (__force is what shuts up sparse, and as far as I can see, the size_t
> > cast is useless, since the result will be promoted anyway)
> 
> Yes, that one works. As you suspected, this section is parsing data 
> from the firmware.

I believe __force should be the last resort.  If you want to read a
16-bit little endian value at the given offset, I suggest that you use
le16_to_cpup(), which operates on pointers and does the cast for you.

A better but more elaborate solution would be to define a structure that
would have __le16 rx_mtu at the offset 40.  Then you can cast bootrec to
that structure and apply le16_to_cpu() to that field.

-- 
Regards,
Pavel Roskin
