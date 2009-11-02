Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbZKBXyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbZKBXyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 18:54:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757301AbZKBXyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 18:54:05 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54238 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755803AbZKBXyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 18:54:04 -0500
Message-Id: <1257206049.25795.1343240289@webmail.messagingengine.com>
X-Sasl-Enc: X/hn4I7LZwVTOOyezzJ0exHVb2NtTGq6VqE9625qpp7R 1257206049
From: myuboot@fastmail.fm
To: "Shmulik Ladkani" <jungoshmulik@gmail.com>
Cc: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>,
       "Florian Fainelli" <florian@openwrt.org>, linux-kernel@vger.kernel.org,
       "linux-mips" <linux-mips@linux-mips.org>, shmulik@jungo.com
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <20091029102652.76d42b8c@pixies.home.jungo.com>
References: <1255735395.30097.1340523469@webmail.messagingengine.com><4AD906D8.3020404@caviumnetworks.com><1255996564.10560.1340920621@webmail.messagingengine.com><200910200817.24018.florian@openwrt.org><1256676013.24305.1342273367@webmail.messagingengine.com><20091028103551.0b4052d8@pixies.home.jungo.com><4AE82520.4090607@ru.mvista.com><1256758575.4093.1342456105@webmail.messagingengine.com>
 <20091029102652.76d42b8c@pixies.home.jungo.com>
Subject: Re: serial port 8250 messed up after coverting from little endian to
 big endian on kernel  2.6.31
Date: Mon, 02 Nov 2009 17:54:09 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_SWAP_IO_SPACE was set to Y, but I don't even see it using
xconfig or menuconfig. So I set it manually to n into .config file and
then did a compile - I am using buildroot. But somehow the value always
comes back to y after I type in command "make". The kernel image still
messes up the console after the console is handovered from early printk
to really ttyS01.

Thanks. 

On Thu, 29 Oct 2009 10:26 +0200, "Shmulik Ladkani"
<jungoshmulik@gmail.com> wrote:
> On Wed, 28 Oct 2009 14:36:15 -0500 myuboot@fastmail.fm wrote:
> > I just tried UPIO_MEM32 without adding a offset of 3. But the result is
> > bad - after the kernel initializes the serial console, the console print
> > out messes up. The early printk is fine because the u-boot initialises
> > the serial port fine. 
> > 
> > Did I miss anything? Thanks again for your help.
> 
> I guess you did fine with UPIO_MEM32.
> 
> Keeping the UPIO_MEM32 approach, I suggest also to fiddle Y/N with
> CONFIG_SWAP_IO_SPACE (might be that you have it set to Y while you don't
> really need it, or vice versa).
> This is since 'readl' uses 'ioswabl' for (potential) byte-swapping of the
> read
> value. Take a look at asm/io.h and mangle-port.h.
> 
> Most important, read your hardware documentation to determine correct
> access
> to the memory mapped serial registers.
> 
> -- 
> Shmulik Ladkani         Jungo Ltd.
