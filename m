Return-Path: <linux-kernel-owner+w=401wt.eu-S1751969AbZKOK77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbZKOK77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 05:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbZKOK76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 05:59:58 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:50961 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbZKOK75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 05:59:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=qsbxZ8tRxPuepsd1s9vcEVuntGrVvqSPAMMCQ145WeQDNhw0ohHht4QZmTYERcCrzD
         SpwfIgGfDrnbGNf1/XX9Gvovw6Uz3HKd8UunWp9FRcLj966uJxxW2VAqU98V2CX6Znez
         pFJoYyEV5AZexKVnvXt6cBfJxxrmf0ix/DNCk=
Date: Sun, 15 Nov 2009 13:59:57 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: joe@perches.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl.c: Change a .proc_handler = proc_dointvec to
Message-ID: <20091115105957.GA1935@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -		.proc_handler	= proc_dointvec
> +		.proc_handler	= &proc_dointvec,

NAK.

commit 6d9f239a1edb31d6133230f478fd1dc2da338ec5
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Mon Nov 3 18:21:05 2008 -0800

    net: '&' redux
    
    I want to compile out proc_* and sysctl_* handlers totally and
    stub them to NULL depending on config options, however usage of &
    will prevent this, since taking adress of NULL pointer will break
    compilation.
    
    So, drop & in front of every ->proc_handler and every ->strategy
    handler, it was never needed in fact.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
