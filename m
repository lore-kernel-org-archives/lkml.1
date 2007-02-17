Return-Path: <linux-kernel-owner+w=401wt.eu-S1751266AbXBQW54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266AbXBQW54 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 17:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbXBQW54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 17:57:56 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:55665 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbXBQW5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 17:57:55 -0500
Date: Sat, 17 Feb 2007 23:57:46 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: netpoll again ? (was: Re: 2.6.20-git14 rtl8139 possible circular locking dependency detected)
Message-ID: <20070217225746.GB16954@electric-eye.fr.zoreil.com>
References: <45D7569F.9030502@googlemail.com> <20070217221252.GA16954@electric-eye.fr.zoreil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217221252.GA16954@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu <romieu@fr.zoreil.com> :
> Michal Piotrowski <michal.k.k.piotrowski@gmail.com> :
> [...]
> 
> Did you enable RTL8139_DEBUG ?
> 
> If so you can try the patch below.

It's buggy there too but you are not experiencing this one.

1 - netpoll() calls the poll() handler of the device through netpoll_poll()
2 - The poll handler of the device tries to acquire dev->_xmit_lock
    through dev_mc_add during the Rx protocol processing
3 - netpoll() holds dev->_xmit_lock to avoid recursion in netpoll_poll()

#2 and #3 have opposite requirements.

-- 
Ueimor
