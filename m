Return-Path: <linux-kernel-owner+w=401wt.eu-S1760345AbZJMPm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760345AbZJMPm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760296AbZJMPmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:42:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760290AbZJMPmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:42:54 -0400
Date: Tue, 13 Oct 2009 08:41:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Paul Fulghum <paulkf@microgate.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Nix <nix@esperi.org.uk>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Boyan <btanastasov@yahoo.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?= 
	<fredlwm@gmail.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
In-Reply-To: <1255447980.3898.3.camel@x2.microgate.com>
Message-ID: <alpine.LFD.2.01.0910130837370.26777@localhost.localdomain>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>  <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera>  <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com>  <87ljjgfcbu.fsf@spindle.srvr.nix>  <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain> 
 <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>  <20091013113232.384b2432@lxorguk.ukuu.org.uk>  <alpine.LFD.2.01.0910130721530.3438@localhost.localdomain> <1255447980.3898.3.camel@x2.microgate.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Oct 2009, Paul Fulghum wrote:

> On Tue, 2009-10-13 at 07:39 -0700, Linus Torvalds wrote:
> > It's not a f*cking performance tweak, and you're ludicrous to claim it is. 
> > It's pointless, and it's making the code _slower_ rather than faster.
> > 
> > Lookie here, Alan - the common sequence is crap like this:
> > 
> > 	tty_buffer_request_room(tty, buf->size);
> > 	tty_insert_flip_string(tty, buf->base, buf->size);
> 
> The performance tweak of tty_prepare_xxx is that you fill
> the tty_buffer directly instead of writing data first to a staging
> buffer and then calling tty_insert_flip_string, which just copies
> from the staging buffer to the tty_buffer. So it saves a copy operation.

Read the above again. Read what that common sequence is. Please just READ 
the f*cking code, and read my emails, instead of talking about something 
totally different that I'm not talking about at all.

The _most_common_ use of "tty_buffer_request_room()" is literally just the 
above insane sequence I quoted, not the case you talk about at all. Don't 
believe me? Use grep.

What _you_ are talking about is something else, namely the 
tty_prepare_flip stuff. But dammit, that has nothing what-so-ever to do 
with "tty_buffer_request_room()".

What I was pointing out is that there are a lot of 
"tty_buffer_request_room()" calls, and as far as I can see, all of them 
(or at least a large percentage) are just pure and utter crap.

		Linus
