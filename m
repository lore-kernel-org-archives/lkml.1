Return-Path: <linux-kernel-owner+w=401wt.eu-S1422801AbXD3XBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422801AbXD3XBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 19:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422821AbXD3XBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 19:01:16 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37252 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422801AbXD3XBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 19:01:14 -0400
Date: Tue, 1 May 2007 00:04:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: dann frazier <dannf@hp.com>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       support@moxa.com.tw, dilinger@debian.org
Subject: Re: old buffer overflow in moxa driver
Message-ID: <20070501000455.2173b1e2@the-village.bc.nu>
In-Reply-To: <20070430224829.GI31283@krebs.dannf>
References: <20070430224829.GI31283@krebs.dannf>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>   I noticed that the moxa input checking security bug described by
> CVE-2005-0504 appears to remain unfixed upstream.
>  
> The issue is described here:
>   http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2005-0504
> 
> Debian has been shipping the following patch from Andres Salomon. I
> tried contacting the listed maintainer a few months ago but received
> no response.


       case MOXA_LOAD_BIOS:
        case MOXA_FIND_BOARD:
        case MOXA_LOAD_C320B:
        case MOXA_LOAD_CODE:
                if (!capable(CAP_SYS_RAWIO))
                        return -EPERM;
                break;

At the point you abuse these calls you can already just load arbitary
data from userspace anyway.

