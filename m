Return-Path: <linux-kernel-owner+w=401wt.eu-S1757714AbXEPJav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714AbXEPJav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 05:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432AbXEPJal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 05:30:41 -0400
Received: from twin.jikos.cz ([213.151.79.26]:34294 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbXEPJak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 05:30:40 -0400
Date: Wed, 16 May 2007 11:29:45 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Marcel Holtmann <marcel@holtmann.org>, Greg KH <gregkh@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, maxk@qualcomm.com,
       bluez-devel@lists.sourceforge.net, Cedric Le Goater <clg@fr.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: 2.6.21-rc7: BUG: sleeping function called from invalid context
 at net/core/sock.c:1523
In-Reply-To: <a781481a0705110629n7c7130c1x3a89fa958b271f20@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705161124030.25986@twin.jikos.cz>
References: <462D1B09.9050005@goop.org>  <Pine.LNX.4.64.0704232257090.20657@twin.jikos.cz>
  <Pine.LNX.4.64.0704261625410.20657@twin.jikos.cz>
 <a781481a0705110629n7c7130c1x3a89fa958b271f20@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007, Satyam Sharma wrote:

> (later)
> I Googled a bit to see if this problem was faced elsewhere in the kernel
> too. Saw the following commit by Ingo Molnar
> (9883a13c72dbf8c518814b6091019643cdb34429):
> -	lock_sock(sock->sk);
> +	local_bh_disable();
> +	bh_lock_sock_nested(sock->sk);
> 	rc = selinux_netlbl_socket_setsid(sock, sksec->sid);
> -	release_sock(sock->sk);
> +	bh_unlock_sock(sock->sk);
> +	local_bh_enable();
> Is it _really_ *this* simple?

Hi Satyam,

actually this *seems* to be proper solution also for our case, thanks for 
pointing this out. I will think about it once again, do some more tests 
with this locking scheme, and will let you know.

Thanks,

-- 
Jiri Kosina
