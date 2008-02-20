Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbYBTAQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbYBTAQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760831AbYBTAOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:14:36 -0500
Received: from www.tglx.de ([62.245.132.106]:42891 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758843AbYBTAOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:14:31 -0500
Date: Wed, 20 Feb 2008 01:14:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marcel Holtmann <marcel@holtmann.org>
cc: Quel Qun <kelk1@comcast.net>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Kernel oops with bluetooth usb dongle
In-Reply-To: <895FB10F-5E5C-4409-AC3E-5F83BBF9ED72@holtmann.org>
Message-ID: <alpine.LFD.1.00.0802200108040.7583@apollo.tec.linutronix.de>
References: <021820080001.29293.47B8CAD10009FD170000726D2207000953CE05040A05@comcast.net> <alpine.LFD.1.00.0802181245370.7583@apollo.tec.linutronix.de> <895FB10F-5E5C-4409-AC3E-5F83BBF9ED72@holtmann.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008, Marcel Holtmann wrote:
> > > hci_cmd_task: hci0 command tx timeout
> > > BUG: unable to handle kernel paging request at 6b6b6b6b
> > 
> > We got some more info ---------------------------^^^^^^^^
> > #define POISON_FREE      0x6b    /* for use-after-free poisoning */
> > 
> > So the timer is in an allocated data structure, which is
> > freed without having removed the timer first.
> > 
> > > Sorry for the meager yield.
> > 
> > Hey, we know already more :)
> > 
> > Marcel, any idea on this one ?
> 
> I don't really have any idea. Nothing has been changed in this area for a
> couple of years. The command TX timeout is the timeout that indicates a
> missing answer to a command sent down to the Bluetooth chip.
> 
> However this involves some atomic and tasklet stuff. Did we have some changes
> that I missed and might now render this usage as broken.

Not that I'm aware off, but this might as well be some old use after
free bug which got exposed by some unrelated change. The good news is
that it is reproducible. I'll hack up some nasty debug patch which
lets us - hopefully - decode where the timer was armed.

Thanks,

	tglx
