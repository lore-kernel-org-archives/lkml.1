Return-Path: <linux-kernel-owner+w=401wt.eu-S1759640AbZFITgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640AbZFITgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 15:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756228AbZFITgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 15:36:06 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:53536 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003AbZFITgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 15:36:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=H0BI/NJf7e7j6CGRa2Z7jquQEGrqNXfpenWyYVjmH3GxVNd1ghcswR1OmCyjGDQeDX
         F2X9Xrtx56ML4y5xDTCxvipTjEvuczTVW0rz/bXJ68RRRfvUVRs6CIjVIFOOHRonuosJ
         QHBFoTwKlxcIUHZe5eg1L3s6xUOBk58Ct9TCk=
Message-ID: <4A2EB9A4.4040403@gmail.com>
Date: Tue, 09 Jun 2009 21:36:04 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.1 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, eibach@gdsys.de
Subject: Re: [PATCH 1/1] Char: moxa, prevent opening unavailable ports
References: <1244557981-9443-1-git-send-email-jirislaby@gmail.com> <20090609122735.9a915cbf.akpm@linux-foundation.org>
In-Reply-To: <20090609122735.9a915cbf.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2009 09:27 PM, Andrew Morton wrote:
> btw, what's this code in moxa_open() doing?
> 
> 	if (port == MAX_PORTS) {
> 		return capable(CAP_SYS_ADMIN) ? 0 : -EPERM;
> 	}
> 
> why does it return 0 if CAP_SYS_ADMIN?				

There is some global stats ioctl crap on that port number available only
to users with permissions. Look at moxa_ioctl, there is:

        if (tty->index == MAX_PORTS) {
                if (cmd != MOXA_GETDATACOUNT && cmd != MOXA_GET_IOQUEUE &&
                                cmd != MOXA_GETMSTATUS)
                        return -EINVAL;

Of course, there is also alloc_tty_driver(MAX_PORTS + 1).
