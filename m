Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbXGAMWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbXGAMWn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 08:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbXGAMWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 08:22:36 -0400
Received: from zakalwe.fi ([80.83.5.154]:45621 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523AbXGAMWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 08:22:36 -0400
Date: Sun, 1 Jul 2007 15:22:25 +0300
From: Heikki Orsila <shdl@zakalwe.fi>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: mtk-manpages@gmx.net, Davide Libenzi <davidel@xmailserver.org>
Subject: Man page correction: epoll (7)
Message-ID: <20070701122225.GB3400@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a bit of email I exchanged with Davide Libenzi on epoll (7) man 
page. There is an error in answer 9:

Davide Libenzi wrote:
> On Mon, 25 Jun 2007, Heikki Orsila wrote:
>> >From epoll man page:
>>
>>        Q9     Do I need to continuously read/write an  fd  until  EAGAIN when
>>               using the EPOLLET flag ( Edge Triggered behaviour ) ?
>>
>>        A9     No you don't.
>>             ...
>>             For example, if you call read(2) by asking to  read
>>             a  certain  amount of data and read(2) returns a lower number of
>>             bytes, you can be sure to have exhausted the read I/O space  for
>>             such  file  descriptor.
>>             ...
>>
>> This doesn't seem very true in the general case. Afaik, terminal
>> devices can be configured to return only one line per read(). For
>> example,
>>
>>       read(terminal_fd, buf, 4096)
>>
>> will return 34 (the length of the line) but obviously the IO space would
>> not be exhausted if _two_ lines arrived into terminal fd during IO wait.
>> And thus, arrival of the second line went unnoticed.
>>
>> Teaching to optimise nonblocking reads will likely cause more bugs.
>>
>> I'm I correct? If yes, that number should be removed from the question
>> list.
> 
> Yes, you are correct. Although the above is true for the majority of
> stream files, so it better be fixed with the few counter-examples 
> instead of being removed.
> 
> - Davide

and

Davide Libenzi wrote:
> Heikki Orsila wrote:
>> Maybe so that we say that as a general rule one must read until EAGAIN,
>> but mention specific cases where one only needs to wait for "short"
>> reads?
> 
> Yes, that's fine with me.


So, the Q9 should be changed:

Q9	Do I need to continuously read/write an  fd  until  EAGAIN when
	using the EPOLLET flag ( Edge Triggered behaviour ) ?

A9	As a general rule, yes. However, there are exceptions.
	With some types of fds it is enough to wait until
	read returns less bytes than was requested by the read call.

Are there any fd types where such behavior is guaranteed by the Linux 
kernel (for the future)? I.e. one can assume that edge-triggered fds 
will behave properly if

	x = read(fd, data, count) and x < count ?

Regular files? Sockets? What?

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
