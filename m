Return-Path: <linux-kernel-owner+w=401wt.eu-S1030497AbXBGI7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030497AbXBGI7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 03:59:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030500AbXBGI7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 03:59:05 -0500
Received: from mail2.domainserver.de ([213.83.41.143]:2007 "EHLO
	smtp.domainserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030497AbXBGI7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 03:59:04 -0500
Envelope-to: linux-kernel@vger.kernel.org
Delivery-date: Wed, 07 Feb 2007 09:59:03 +0100
From: Daniel Kabs <dkabs@mobotix.com>
Organization: MOBOTIX AG
To: davids@webmaster.com
Subject: Re: Problem with unix sockets: SOCK_DGRAM ignores MSG_TRUNC
Date: Wed, 7 Feb 2007 09:58:51 +0100
User-Agent: KMail/1.7.2
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
References: <MDEHLPKNGKAHNMBLJOLKCEKJBGAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKCEKJBGAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702070958.51520.dkabs@mobotix.com>
X-AUTH: - 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 February 2007 21:11, David Schwartz wrote:
> > Why not improve consistency and make unix_dgram_recvmsg() return the
> > full packet length? So it would behave as UDP does. What do you think
> > about adding the following code to linux/net/unix/af_unix.c:
>
> It would be nice if the world worked that way, but you can't break
> POSIX compliance. Perhaps another receive flag?

I now understand that setting the MSG_TRUNC flag is only applicable for 
PF_PACKET. I do not argue about that any more. :-)

What I question is the return value when receiving from a local socket 
using recv(). Sorry, I don't know what the POSIX standard has to say 
about receiving from local sockets in contrast to UDP sockets as my only 
reference are the man pages.

According to "man 2 recv", on success the return value is the "the  number  
of bytes received". Since patch-2.6.8, UDP is always returning the full 
packet length. I'd like to see local sockets (PF_UNIX) to do the same. 

Does POSIX stipulate a different behaviour for local sockets?

Cheers
Daniel
