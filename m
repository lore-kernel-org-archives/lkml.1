Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbZKWTmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbZKWTmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 14:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbZKWTme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 14:42:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46992 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbZKWTmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 14:42:33 -0500
Message-ID: <4B0AE3E4.9020909@zytor.com>
Date: Mon, 23 Nov 2009 11:35:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Willy Tarreau <w@1wt.eu>, Matt Thrailkill <matt.thrailkill@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Avi Kivity <avi@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <20091110224222.GA28648@1wt.eu> <4AF9ED78.3000106@zytor.com>	<20091111055220.GA560@1wt.eu> <4AFA569E.9040206@zytor.com>	<20091111063617.GD560@1wt.eu> <4AFA6E50.7030808@zytor.com>	<20091111093258.GE560@1wt.eu>	<a91053ef0911111823v52669d18p7e5812076a63f03e@mail.gmail.com>	<20091112052754.GB15679@1wt.eu> <4AFB9DAE.4080601@zytor.com>	<20091112054004.GA15925@1wt.eu> <m1k4xhf3cx.fsf@fess.ebiederm.org>
In-Reply-To: <m1k4xhf3cx.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2009 11:27 AM, Eric W. Biederman wrote:
> 
> When working on dosemu and emulating EGA 16 color graphics we had to
> unmap the frame buffer so we would cause move instructions to fault.
> Trapping for each mov instruction in the loops that wrote to the frame
> buffer was unusably slow.  Ultimately that was fixed by trapping on
> the first instruction and then running in the emulator until we had
> gone N instructions without hitting an instruction we would trap for.
> The result was usable software emulated EGA graphics.
> 
> I expect the same logic will apply any time there is a trapped and
> emulated instruction in an inner loop.  Emulating the entire loop
> will be more efficient than trapping for each loop iteration.
> 

Yes, this is pretty typical.  In terms of EGA/VGA it depends heavily on
how the application is coded, since it is possible to put EGA/VGA into
modes where the frame buffer depends mostly like memory except at
specific I/O points, and other modes where the frame buffer behaves
nothing like memory at all and every reference needs to be handled
specially.  In real use, the former tends to dominate simply because
it's the sane way to code, but the only way to make the latter perform
sanely at all is to interpret everything.

	-hpa
