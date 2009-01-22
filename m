Return-Path: <linux-kernel-owner+w=401wt.eu-S1752895AbZAVOZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbZAVOZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 09:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZAVOZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 09:25:45 -0500
Received: from kuber.nabble.com ([216.139.236.158]:51288 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbZAVOZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 09:25:45 -0500
Message-ID: <21605162.post@talk.nabble.com>
Date: Thu, 22 Jan 2009 06:25:44 -0800 (PST)
From: gsmd <gsmdib@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: plz help fixing lirc_igorplugusb kernel module
In-Reply-To: <87c.4976ffbf.5f61c@altium.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: gsmdib@gmail.com
References: <567e52cd0901201139s1bd4e585o4a3af400c213d237@mail.gmail.com> <87c.4976ffbf.5f61c@altium.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dick Streefland wrote:
> 
> This error is caused by an IR code longer than 36 pulse/space periods.
> Perhaps the Windows driver simply ignores this condition? Did you try
> to remove the code that handles this case and where this message is
> issued?
> 
It probably does, yet the code is received (so I can assign any command to
that key).
Here's the section from lirc_igorplugusb.c
(ftp.gnu.org/tmp/linux-libre-fsf2_2.6.28/linux-2.6.28/ubuntu/lirc/lirc_igorplugusb/lirc_igorplugusb.c)
that displays the message:
--
		if (ir->buf_in[2] != 0) {
			printk(DRIVER_NAME "[%d]: Device buffer overrun.\n",
				ir->devnum);
			/* start at earliest byte */
			i = DEVICE_HEADERLEN + ir->buf_in[2];
			/* where are we now? space, gap or pulse? */
		}
--
With my limited C knowledge I don't see what would prevent displaying the
key code (when I run irw) after the message. Haven't tried removing it
though.
Also checked with 3 different remote controls, the result is all the same.
-- 
View this message in context: http://www.nabble.com/plz-help-fixing-lirc_igorplugusb-kernel-module-tp21570131p21605162.html
Sent from the linux-kernel mailing list archive at Nabble.com.

