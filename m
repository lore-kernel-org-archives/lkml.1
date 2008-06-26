Return-Path: <linux-kernel-owner+w=401wt.eu-S1758287AbYFZP3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287AbYFZP3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbYFZP2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:28:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53277 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbYFZP2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:28:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 46/60] microblaze_v4: termbits.h termios.h
Date: Thu, 26 Jun 2008 17:28:47 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <1214483429-32360-46-git-send-email-monstr@seznam.cz> <1214483429-32360-47-git-send-email-monstr@seznam.cz>
In-Reply-To: <1214483429-32360-47-git-send-email-monstr@seznam.cz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Disposition: inline
Message-Id: <200806261728.48860.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18RLFTKL8YAps8nsUJIIPybQhQe9s/nesO9Pzl
 nB/gWCZpZoE1RgAwh6TBG1n/VtOo/v3JVDLBJeGj+UTqPykFJ0
 jbs+lMWKq9R+cMIAQF74Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m5QFTDfq004643

On Thursday 26 June 2008, monstr@seznam.cz wrote:> @@ -0,0 +1,84 @@> +> +#include <linux/string.h>> +#include <asm/termbits.h>> +#include <asm/ioctls.h>> +> +struct winsize {> +       unsigned short ws_row;> +       unsigned short ws_col;> +       unsigned short ws_xpixel;> +       unsigned short ws_ypixel;> +};> +> +#define NCC 8> +struct termio {> +       unsigned short c_iflag; /* input mode flags */> +       unsigned short c_oflag; /* output mode flags */> +       unsigned short c_cflag; /* control mode flags */> +       unsigned short c_lflag; /* local mode flags */> +       unsigned char c_line; /* line discipline */> +       unsigned char c_cc[NCC]; /* control characters */> +};> +> +#ifdef __KERNEL__> +/*     intr=^C         quit=^|         erase=del       kill=^U> +       eof=^D          vtime=\0        vmin=\1         sxtc=\0> +       start=^Q        stop=^S         susp=^Z         eol=\0> +       reprint=^R      discard=^U      werase=^W       lnext=^V> +       eol2=\0> +*/> +#define INIT_C_CC "\003\034\177\025\004\0\1\0\021\023\032\0\022\017\027\026\0"> +#endif> +> +/* Modem lines */> +> +#define TIOCM_LE       0x001> +#define TIOCM_DTR      0x002> +#define TIOCM_RTS      0x004> +#define TIOCM_ST       0x008> +#define TIOCM_SR       0x010> +#define TIOCM_CTS      0x020> +#define TIOCM_CAR      0x040> +#define TIOCM_RNG      0x080> +#define TIOCM_DSR      0x100> +#define TIOCM_CD       TIOCM_CAR> +#define TIOCM_RI       TIOCM_RNG> +#define TIOCM_OUT1     0x2000> +#define TIOCM_OUT2     0x4000> +#define TIOCM_LOOP     0x8000
It would be nice if more of the above could be in asm-generic/termios.h,as far as I can tell they are identical for all (four) users of thatgeneric file.Of course if you do that, you'll have to remove the code from the existingusers.
> +/* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */> +> +/* Line disciplines */> +> +#define N_TTY          0> +#define N_SLIP         1> +#define N_MOUSE                2> +#define N_PPP          3> +#define N_STRIP                4> +#define N_AX25         5> +#define N_X25          6 /* X.25 async */> +#define N_6PACK                7> +#define N_MASC         8 /* Reserved for Mobitex module <kaz@cafe.net> */> +#define N_R3964                9 /* Reserved for Simatic R3964 module */> +#define N_PROFIBUS_FDL 10 /* Reserved for Profibus <Dave@mvhi.com> */> +#define N_IRDA         11 /* Linux IR - http://irda.sourceforge.net/ */> +#define N_SMSBLOCK     12 /* SMS block mode - for talking to GSM data cards> +                               about SMS messages */> +#define N_HDLC         13 /* synchronous HDLC */> +#define N_SYNC_PPP     14> +#define N_HCI          15 /* Bluetooth HCI UART */> +
These are already defined in linux/tty.h, so they should not be here.
	Arnd <><
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
