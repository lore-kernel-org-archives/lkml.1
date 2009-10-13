Return-Path: <linux-kernel-owner+w=401wt.eu-S1760294AbZJMPeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760294AbZJMPeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760285AbZJMPeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:34:14 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:38520
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448AbZJMPeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:34:13 -0400
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
Date: Tue, 13 Oct 2009 10:33:00 -0500
Message-Id: <1255447980.3898.3.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 07:39 -0700, Linus Torvalds wrote:
> It's not a f*cking performance tweak, and you're ludicrous to claim it is. 
> It's pointless, and it's making the code _slower_ rather than faster.
> 
> Lookie here, Alan - the common sequence is crap like this:
> 
> 	tty_buffer_request_room(tty, buf->size);
> 	tty_insert_flip_string(tty, buf->base, buf->size);

The performance tweak of tty_prepare_xxx is that you fill
the tty_buffer directly instead of writing data first to a staging
buffer and then calling tty_insert_flip_string, which just copies
from the staging buffer to the tty_buffer. So it saves a copy operation.
 
--
Paul Fulghum
Microgate Systems, Ltd

