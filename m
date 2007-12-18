Return-Path: <linux-kernel-owner+w=401wt.eu-S964795AbXLRCyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964795AbXLRCyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 21:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760139AbXLRCyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 21:54:43 -0500
Received: from smtp114.sbc.mail.re2.yahoo.com ([68.142.229.91]:47139 "HELO
	smtp114.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755016AbXLRCym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 21:54:42 -0500
X-YMail-OSG: PtSFZvEVM1k847gbU8wstjnjO_9hhI1vHFx5n8CCY1rm24i2b5ob71_JPHVdtdqsj0Lxp.BfCg--
Date: Mon, 17 Dec 2007 20:53:33 -0600
From: serge@hallyn.com
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
Message-ID: <20071218025329.GA12429@vino.hallyn.com>
References: <20071216080441.435456586@I-love.SAKURA.ne.jp> <20071216080628.061470932@I-love.SAKURA.ne.jp> <200712161944.HEI26071.MOtOFLVHFSQFOJ@I-love.SAKURA.ne.jp> <200712161956.BJE32406.FOOHtQJLMFOSVF@I-love.SAKURA.ne.jp> <20071217194802.GA14156@sergelap.austin.ibm.com> <200712180003.lBI03N7F092396@www262.sakura.ne.jp> <20071218003955.GA27048@sergelap.austin.ibm.com> <20071218015557.GA28652@sergelap.austin.ibm.com> <200712180226.lBI2QL1d020811@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712180226.lBI2QL1d020811@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@i-love.sakura.ne.jp):
> Hello.
> 
> Serge E. Hallyn wrote:
> > But your requirements are to ensure that an application accessing a
> > device at a well-known location get what it expect.
> 
> Yes. That's the purpose of this filesystem.
> 
> 
> > So then the main quesiton is still the one I think Al had asked - what
> > keeps a rogue CAP_SYS_MOUNT process from doing
> > mount --bind /dev/hda1 /dev/null ?
> 
> Excuse me, but I guess you meant "mount --bind /dev/ /root/" or something
> because mount operation requires directories.

Nope, try

	touch /root/hda1
	ls -l /root/hda1
	mount --bind /dev/hda1 /root/hda1
	ls -l /root/hda1

But I see tomoyo prevents that

> MAC can prevent a rogue CAP_SYS_MOUNT process from doing
> "mount --bind /dev/ /root/".
> For example, regarding TOMOYO Linux, you need to give
> "allow_mount /dev/ /root/ --bind 0" permission
> to permit "mount --bind /dev/ /root/" request.

Ok, that answers my question.  Thanks.

(I won't go into "who gets to say allow_mount" :)

> Did you mean "ln -s /dev/hda1 /dev/null" or "ln /dev/hda1 /dev/null"?
> No problem. MAC can prevent such requests too.

Then it sounds like this filesystem is something Tomoyo can use.

thanks,
-serge
