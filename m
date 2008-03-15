Return-Path: <linux-kernel-owner+w=401wt.eu-S1752711AbYCON5C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbYCON5C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 09:57:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbYCON4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 09:56:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56622 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751628AbYCON4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 09:56:52 -0400
Date: Sat, 15 Mar 2008 13:34:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nebojsa Miljanovic <neb@alcatel-lucent.com>
Cc: linux-kernel@vger.kernel.org,
       "Kittlitz, Edward (Ned)" <nkittlitz@alcatel-lucent.com>,
       asweeney@alcatel-lucent.com,
       "Polhemus, William (Bart)" <bpolhemus@alcatel-lucent.com>
Subject: Re: SO_REUSEADDR not allowing server and client to use same port
Message-ID: <20080315133426.1f48c99c@the-village.bc.nu>
In-Reply-To: <47D97DF7.8000702@alcatel-lucent.com>
References: <47C6FA2A.5030302@alcatel-lucent.com>
	<20080228201926.558c4e7c@core>
	<47D97DF7.8000702@alcatel-lucent.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 14:18:15 -0500
Nebojsa Miljanovic <neb@alcatel-lucent.com> wrote:

> Alan,
> I would appreciate it if you could elaborate on the security issue. Can you
> describe the simultaneous connect scenario?
> 
> We have a system we are migrating to Linux from Lynx. We have always had the
> ability to re-use ports. We are wondering if this security issue is something we
> should take seriously. Or, maybe it is not likely to be seen with our system
> running well defined set of applications (i.e. not a PC where anybody could run
> anything).

See RFC 793. It is permissible for a connection to be created between two
end points both making a connection (crossing SYN frames are both
acked). Thus if you allow such reuse it is possible (although usually
very very hard) to mount a timing based attack.

It's not a very practical attack in most scenarios so we block it out of
correctness and concerns for completely robust and proper behaviour
rather than because it is seen in the wild.

Alan
