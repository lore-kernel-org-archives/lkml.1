Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbZBCT2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbZBCT2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 14:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbZBCT2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 14:28:13 -0500
Received: from fifo99.com ([67.223.236.141]:54270 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbZBCT2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 14:28:12 -0500
Subject: Re: [crash] af9005_usb_module_init(): BUG: unable to handle kernel
	paging request at ff100000
From: Daniel Walker <dwalker@fifo99.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
       Janne Grunau <janne-dvb@grunau.be>, Luca Olivetti <luca@ventoso.org>
In-Reply-To: <20090203172836.GA6964@elte.hu>
References: <20090203172836.GA6964@elte.hu>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 10:22:41 -0800
Message-Id: <1233685361.5903.131.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 18:28 +0100, Ingo Molnar wrote:
> FYI, -tip qa keeps triggering this bootup crash occasionally, ever since 
> June 2008 when a DVB merge brought in this new driver:

It looks like it could be a config problem.. The crash happens around
these two symbol "af9005_rc_keys", and "af9005_rc_keys_size" , and they
are both defined inside af9005-remote.c different from where the init
functions is lcoated .. af9005-remote.c needs a special config
CONFIG_DVB_USB_AF9005_REMOTE to get compiled which you have disabled.. 

I think there's no compile warning cause symbol_get() creates weak
symbols when CONFIG_MODULES is off..

Daniel

