Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbYHYJHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbYHYJHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 05:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYHYJH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 05:07:26 -0400
Received: from smtp.seznam.cz ([77.75.72.43]:33849 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601AbYHYJH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 05:07:26 -0400
X-Greylist: delayed 1076 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Aug 2008 05:07:25 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding:X-Smtpd:X-Seznam-User:X-QM-Mark;
	b=C9G9eULOu74sQIbIn0faf157j6mwhHFTPV9ZFLIDUfXCKKc+CeNPUU+CbXrw+infO
	VUb7CQa+B+97Of89QIJMjp05dawe7sOHmNOgIfFQ7rsg8PQJTm3mW3CyFmqws27SGN7
	NxIEGbVPnSRQIus31ayoOWGyBLRxjoFtzJdoVhk=
Message-ID: <48B27215.3080808@seznam.cz>
Date: Mon, 25 Aug 2008 10:49:25 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Linker script
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Smtpd: 1.1.1@13338
X-Seznam-User: monstr@seznam.cz
X-QM-Mark: email-qm5<191561597>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am solving one merging issue and I would appreciate if someone can help me
with one problem I have.

We have in vmlinux.lds.S specify two memory regions because we use main memory
and bram memory which is faster.

MEMORY {
	ERAM	: ORIGIN = CONFIG_XILINX_ERAM_START,
		  LENGTH = CONFIG_XILINX_ERAM_SIZE
#if defined(CONFIG_XILINX_LMB_START) && defined(CONFIG_USE_BRAM)
	LMB	: ORIGIN = CONFIG_XILINX_LMB_START,
		  LENGTH = CONFIG_XILINX_LMB_SIZE
#endif
}

And then we have special section for it which is copied to proper place in
startup sequence.

       .bram : {
		/* Skip past interrupt, exception and debug vectors.  If you
		   change this, also change the 0x40 (word) offset in
		   kernel/setup.c:pingpong_bram()  */
               . = 0x100;
               _bram_load_start = . ;
               *(.bram*)               /* Everything */
               *(.bram.text)
               *(.bram.data)
               _bram_load_end = . ;
       } > LMB AT > ERAM

This concept work well but I would like to remove all reference which pointed to
memory regions and of course regions because I would like to use generic macros
which is in asm-generic/vmlinux.lds.h (especially RODATA).

I found that is possible to add memory location after name of section but this
seems work only without included data.
.name mem_lock {

}

When the data is there objcopy announced that section is too big for creating
linux.bin file. :-(

Is there any way how is possible to do it?

Thanks for any hit,
Best regards,
Michal Simek
