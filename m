Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab0BORry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 12:47:54 -0500
Received: from mail-bw0-f213.google.com ([209.85.218.213]:65003 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab0BORrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 12:47:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kfM3+gv4USR1esbWR5nzgzgzQgzKl9WsVeBg0geX9YbZd8Z5xJ74Cif4+waZuJeTli
         hMZK2JBWTFxHAZJD2U9tz3f9IKTeqZWffaxWnOQIK+/ogvVWTc8tUl1B9MdqMvj8zxHV
         5D5i61OZEyA8h9/SfawrtpOtygF6p7DcHbslQ=
Subject: Re: [patch/rfc] Make poll/select report error (POLLNVAL and EBADF)
 for unsupported files
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stephane.thiell@cea.fr
In-Reply-To: <1266255759.8262.26.camel@edumazet-laptop>
References: <alpine.DEB.2.00.1002141403240.18795@makko.or.mcafeemobile.com>
	 <1266255759.8262.26.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Feb 2010 18:47:47 +0100
Message-ID: <1266256067.8262.27.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 15 février 2010 à 18:42 +0100, Eric Dumazet a écrit :

> Hmm, according to POSIX :
> 
> 	The poll() function shall support regular files, terminal and
> pseudo-terminal devices, FIFOs, pipes, sockets ...
> 
> 	Regular files shall always poll TRUE for reading and writing.
> 
> 
> So unless I missed something, this patch could break some conformant
> applications.
> 
> In particular, if an application is polling() on stdin (usually a tty),
> and other 'files', what's happening if we do :
> 
> cat replay_file | application

Doh..

I meant : application < replay_file

> 
> Either it wont read stdin, or application exits without reading its
> input.
> 


