Return-Path: <linux-kernel-owner+w=401wt.eu-S1752003AbZL2T4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbZL2T4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 14:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbZL2T4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 14:56:12 -0500
Received: from toccata.ens-lyon.org ([140.77.166.68]:45104 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbZL2T4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 14:56:11 -0500
Date: Tue, 29 Dec 2009 20:56:08 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what's the purpose of MAXHOSTNAMELEN?
Message-ID: <20091229195608.GG4815@const>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Jeff Garzik <jeff@garzik.org>,
	"Robert P. J. Day" <rpjday@crashcourse.ca>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0912291416230.4967@localhost> <4B3A5B15.5060807@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B3A5B15.5060807@garzik.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik, le Tue 29 Dec 2009 14:40:05 -0500, a écrit :
> On 12/29/2009 02:19 PM, Robert P. J. Day wrote:
> >arch/s390/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max 
> >length of hostname */
> >
> >   so lots of people define it but no one uses it.  it *is* exported to
> >user space in /usr/include/asm/param.h, but i still have no idea what
> >it's for in user space.  obsolete?
> 
> According to RFC 1034, "Each node has a label, which is zero to 63 
> octets in length"

That's for Internet networks.  Other kinds of networks could implement
more.  It could make sense to restrict ourself to Internet standards,
but we don't :)

> What is it used for in userspace, and why is it export from the kernel? 

Gethostname, typically, but also all kinds of functions that provide a
hostname.  It's also quite often completely badly used, for instance for
getnameinfo()...

You have Debian's list on
http://unstable.buildd.net/buildd/hurd-i386_Failed.html

Samuel
