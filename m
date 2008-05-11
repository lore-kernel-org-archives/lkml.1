Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbYEKS3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbYEKS3o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 14:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757534AbYEKS3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 14:29:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55474 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588AbYEKS3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 14:29:33 -0400
Message-ID: <48273A32.5020104@zytor.com>
Date: Sun, 11 May 2008 11:25:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Sam Ravnborg <sam@ravnborg.org>, Mikael Pettersson <mikpe@it.uu.se>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc1 on x86: ld: warning: dot moved backwards before	`.text'
References: <18470.787.498329.144701@harpo.it.uu.se> <482604D1.7020804@zytor.com> <20080510211602.GA32339@uranus.ravnborg.org> <20080511154411.GB6942@cvg> <482737A8.4040602@zytor.com> <20080511182440.GC6942@cvg>
In-Reply-To: <20080511182440.GC6942@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> 
> Hi Peter,
> 
> actually I only doubt about exactly position of this headers - I mean
> meguess it better should be _before_ "_end" not after. Since the others
> script uses (acpi/wakeup_rm.S):
> 
> 	wakeup_code_start:
> 	.incbin	"arch/x86/kernel/acpi/realmode/wakeup.bin"
> 	wakeup_code_end:
> 
> and kernel uses these wakeup_code_* marks to save/restore memory I think
> it should be like
> 
> 	. = HEADER_OFFSET;
> 	.header : {
> 		...
> 	}
> 	. = ALIGN(16);
> 	_end = .;
> 	/DISCARD/ ...
> 

Yes, I believe that's correct.

	-hpa
