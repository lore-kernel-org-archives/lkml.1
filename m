Return-Path: <linux-kernel-owner+w=401wt.eu-S1030238AbXCVJFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030238AbXCVJFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 05:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030266AbXCVJFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 05:05:01 -0400
Received: from mail.suse.de ([195.135.220.2]:44076 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030238AbXCVJFA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 05:05:00 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] 2.6.21-rc4: NULL pointer dereference oops when unplugging sierra device
Date: Thu, 22 Mar 2007 10:04:46 +0100
User-Agent: KMail/1.9.1
Cc: Greg KH <gregkh@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Kevin Lloyd <linux@sierrawireless.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kevin Lloyd <klloyd@sierrawireless.com>
References: <4601A3B9.3030701@goop.org> <20070321215309.GA18940@suse.de>
In-Reply-To: <20070321215309.GA18940@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703221004.46806.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 21. März 2007 22:53 schrieb Greg KH:
> > EIP is at sierra_shutdown+0x3a/0x113 [sierra]
> > eax: 00000000   ebx: 00000000   ecx: 00000000   edx: f8e52c9d
> > esi: 00000000   edi: e889fa1c   ebp: e84c0e2c   esp: e84c0e0c
> > ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> > Process pppd (pid: 3847, ti=e84c0000 task=e8553550 task.ti=e84c0000)
> > Stack: 00000002 e84c0e18 c01cfda8 e84c0e20 c0240431 e889fa1c 00000003 e8a79d00 
> >        e84c0e50 f8e219e4 f8e5212d 00000021 00000000 00000000 00000000 e889fa50 
> >        f8e21956 e84c0e70 c01d099a e84c0e78 f8e52c58 e84c0e6c f6c5576c f6c55760 
> > Call Trace:
> >  [<c0104e98>] show_trace_log_lvl+0x1a/0x2f
> >  [<c0104f4a>] show_stack_log_lvl+0x9d/0xa5
> >  [<c0105114>] show_registers+0x1c2/0x293
> >  [<c0105307>] die+0x122/0x224
> >  [<c030fe69>] do_page_fault+0x505/0x5e1
> >  [<c030e5c4>] error_code+0x7c/0x84
> >  [<f8e219e4>] destroy_serial+0x8e/0x124 [usbserial]
> >  [<c01d099a>] kref_put+0x63/0x71
> >  [<f8e217f0>] usb_serial_put+0x10/0x12 [usbserial]
> >  [<f8e2194e>] serial_close+0xb6/0xbe [usbserial]

This looks like the "shutdown called too late bug".
Does the patch included here help:

http://lkml.org/lkml/2007/3/13/217

	Regards
		Oliver
