Return-Path: <linux-kernel-owner+w=401wt.eu-S933546AbXBXUCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546AbXBXUCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 15:02:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933552AbXBXUCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 15:02:09 -0500
Received: from smtp-out.google.com ([216.239.45.13]:36075 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933546AbXBXUCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 15:02:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=koD8jFNzYze6j118beoCzGgLep7ZMUV979Bs5TFyqVZtVfV5pXWeTGtVQ+1BK6Ld1
	9Adiz/Gn0RbtoZoXByxaw==
Message-ID: <45E09989.5070604@google.com>
Date: Sat, 24 Feb 2007 12:01:13 -0800
From: Markus Gutschke <markus@google.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Robin Holt <holt@sgi.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>
Subject: Re: [PATCH 0/4] coredump: core dump masking support v3
References: <45DFB1C7.1030205@google.com>  <45D5B2E3.3030607@hitachi.com> <17044.1172311335@redhat.com>
In-Reply-To: <17044.1172311335@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> How does it work when you can't actually get back to userspace to have
> userspace do the coredump?  You still have to handle the userspace equivalents
> of double/triple faults.

My experience shows that there are only very rare occurrences of 
situations where you cannot get back into userspace to do the coredump, 
and the coredumper tries very hard never to cause additional faults.

While I am sure you could construct scenarios where this would happen, 
realistically the only one I have run into were stack overflows, and 
they can be handled by carefully setting up an alternate stack for 
signal handlers -- just make sure the entire stack is already dirtied 
before you run out of memory (or, turn of overcommitting).


Markus
