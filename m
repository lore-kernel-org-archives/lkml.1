Return-Path: <linux-kernel-owner+w=401wt.eu-S1761241AbXJRUh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761241AbXJRUh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 16:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbXJRUht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 16:37:49 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:33711 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbXJRUhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 16:37:48 -0400
Message-ID: <4717C419.8060602@davidnewall.com>
Date: Fri, 19 Oct 2007 06:07:45 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: jaroslav.sykora@gmail.com
CC: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Shadow directories
References: <200710181721.09201.jara@sin.cvut.cz> <Pine.LNX.4.64.0710181802300.2936@fbirervta.pbzchgretzou.qr> <200710181907.58643.jara@sin.cvut.cz> <4717BBBB.6040205@davidnewall.com>
In-Reply-To: <4717BBBB.6040205@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jaroslav Sykora wrote:
> If anybody can think of any other solution of the "redirector problem", possibly
> even non-kernel based one, let me know and I'd be glad :-)

If I understand your problem, you wish to treat an archive file as if it 
was a directory.  Thus, in the ideal situation, you could do the following:

	cat hello.zip/hello.c
	gcc hello.zip/hello.c -o hello
	etc..


Rather than complicate matters with a second tree, use FUSE with an 
explicit directory.  For example, ~/expand could be your shadow, thus to 
compile hello.c from ~/hello.zip:

	gcc ~/expand/hello.zip^/hello.c -o hello


I think no kernel change would be required.

I'm not keen on the caret.  One of the early claims made in 
http://lwn.net/Articles/100148/ is:
> Another branch, led by Al Viro, worries about the locking 
> considerations of this whole scheme. Linux, like most Unix systems, 
> has never allowed hard links to directories for a number of reasons;

The claim is wrong.  UNIX systems have traditionally allowed the 
superuser to create hard links to directories.  See link(2) for 2.10BSD 
<http://www.freebsd.org/cgi/man.cgi?query=link&sektion=2&manpath=2.10+BSD>.  
Having got that wrong throws doubt on the argument; perhaps a path can 
simultaneously be a file and a directory.
