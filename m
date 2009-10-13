Return-Path: <linux-kernel-owner+w=401wt.eu-S1760181AbZJMPJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181AbZJMPJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760169AbZJMPJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:09:45 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:52659
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760151AbZJMPJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:09:44 -0400
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
From: Paul Fulghum <paulkf@microgate.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Nix <nix@esperi.org.uk>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Boyan <btanastasov@yahoo.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= "L. W. Meunier" <fredlwm@gmail.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
In-Reply-To: <alpine.LFD.2.01.0910130721530.3438@localhost.localdomain>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
	 <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera>
	 <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com>
	 <87ljjgfcbu.fsf@spindle.srvr.nix>
	 <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain>
	 <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
	 <20091013113232.384b2432@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.01.0910130721530.3438@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 13 Oct 2009 10:08:51 -0500
Message-Id: <1255446531.3423.8.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 07:39 -0700, Linus Torvalds wrote:

> You also can race with:
> 
>  - whoever is _reading_ the buffer, and due to memory ordering may see the 
>    update to the buffer length _before_ it actually sees the data itself. 
>    That spinlock does all the memory ordering too.

The only reader is flush_to_ldisc() which operates on the
'commit' and 'read' fields of the buffer.

tty_prepare_xxx and tty_insert_xxx operate on the 'used'
field of the buffer

'commit' is updated with 'used' only under spinlock when
tty_flip_buffer_push() is called after the producer is
finished filling a buffer or in tty_buffer_request_room()
when allocating a new buffer.

--
Paul Fulghum
Microgate Systems, Ltd

