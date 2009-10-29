Return-Path: <linux-kernel-owner+w=401wt.eu-S1751566AbZJ2I1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbZJ2I1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbZJ2I1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:27:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:60380 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbZJ2I1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:27:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=C/YPrWdsbVC/xE91YxTKqz0/m3k8uM8meJNO/LuBkFjrxuSOM9h+clTmxJCJoTu6It
         Dc6hJjZGKIM9sfLH2B/54yJO4w1sXKT6HkxIgHqznaykWPHE+lXevLYVfBBPMm3IMsjs
         Jg7FYr8gT4mMRFw8vTSUNnqjUV54iNUWcREuo=
Date: Thu, 29 Oct 2009 10:26:52 +0200
From: Shmulik Ladkani <jungoshmulik@gmail.com>
To: myuboot@fastmail.fm
Cc: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>,
       "Florian Fainelli" <florian@openwrt.org>, linux-kernel@vger.kernel.org,
       "linux-mips" <linux-mips@linux-mips.org>, shmulik@jungo.com
Subject: Re: serial port 8250 messed up after coverting from little endian
 to big endian on kernel  2.6.31
Message-ID: <20091029102652.76d42b8c@pixies.home.jungo.com>
In-Reply-To: <1256758575.4093.1342456105@webmail.messagingengine.com>
References: <1255735395.30097.1340523469@webmail.messagingengine.com>
	<4AD906D8.3020404@caviumnetworks.com>
	<1255996564.10560.1340920621@webmail.messagingengine.com>
	<200910200817.24018.florian@openwrt.org>
	<1256676013.24305.1342273367@webmail.messagingengine.com>
	<20091028103551.0b4052d8@pixies.home.jungo.com>
	<4AE82520.4090607@ru.mvista.com>
	<1256758575.4093.1342456105@webmail.messagingengine.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Oct 2009 14:36:15 -0500 myuboot@fastmail.fm wrote:
> I just tried UPIO_MEM32 without adding a offset of 3. But the result is
> bad - after the kernel initializes the serial console, the console print
> out messes up. The early printk is fine because the u-boot initialises
> the serial port fine. 
> 
> Did I miss anything? Thanks again for your help.

I guess you did fine with UPIO_MEM32.

Keeping the UPIO_MEM32 approach, I suggest also to fiddle Y/N with
CONFIG_SWAP_IO_SPACE (might be that you have it set to Y while you don't
really need it, or vice versa).
This is since 'readl' uses 'ioswabl' for (potential) byte-swapping of the read
value. Take a look at asm/io.h and mangle-port.h.

Most important, read your hardware documentation to determine correct access
to the memory mapped serial registers.

-- 
Shmulik Ladkani		Jungo Ltd.
