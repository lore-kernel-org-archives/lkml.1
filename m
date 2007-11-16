Return-Path: <linux-kernel-owner+w=401wt.eu-S1762326AbXKPC66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762326AbXKPC66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756573AbXKPC6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:58:49 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:50823 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641AbXKPC6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:58:49 -0500
Message-ID: <473D0737.1040504@cosmosbay.com>
Date: Fri, 16 Nov 2007 03:57:59 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv2 4/4] first use of sys_indirect system call
References: <200711151822.lAFIMVnJ028596@devserv.devel.redhat.com>
In-Reply-To: <200711151822.lAFIMVnJ028596@devserv.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Fri, 16 Nov 2007 03:58:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper a écrit :
> This is a first user of sys_indirect.  Several of the socket-related system
> calls which produce a file handle now can be passed an additional parameter
> to set the FD_CLOEXEC flag.

> 
> -	retval = sock_map_fd(sock);
> +	retval = sock_map_fd_flags(sock, current->indirect_params.file_flags.flags);

Yes, we know now why you wanted sys_indirect so much :)

However, there should be a macro or something to ease reader mind...

#define INDPARAM(SUBSYSNAME,PARAMNAME) \
	(current->indirect_params.##SUBSYSNAME.##PARAMNAME)

 > +	retval = sock_map_fd_flags(sock, INDPARAM(file_flags,flags));

