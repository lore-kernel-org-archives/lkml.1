Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbYJGJf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbYJGJf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 05:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750960AbYJGJfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 05:35:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57130 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYJGJfJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 05:35:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH] serial: Add Cavium OCTEON UART definitions.
Date: Tue, 7 Oct 2008 11:34:50 +0200
User-Agent: KMail/1.9.9
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org,
       "Paoletti, Tomaso" <Tomaso.Paoletti@caviumnetworks.com>
References: <48EAAF97.8050307@caviumnetworks.com>
In-Reply-To: <48EAAF97.8050307@caviumnetworks.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810071134.51012.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18ivyuZfDOfUNJNtIs9h171pghPyvqFlgL4HmI
 M2cswulNAxLHHoY2bN1vFFCS8qFuMOeXDIFdA/xvvywVA2+43q
 VeSUJK8l2Pjca+62rnZKQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 October 2008, David Daney wrote:
> 
> -       up->port.type = PORT_16550A;
> +#ifdef CONFIG_CPU_CAVIUM_OCTEON
> +       /* UPF_FIXED_PORT indicates an internal UART.  */
> +       if (up->port.flags & UPF_FIXED_PORT)
> +               up->port.type = PORT_OCTEON;
> +       else
> +#endif
> +               up->port.type = PORT_16550A;
> +

This looks somewhat wrong, IMHO a device driver should not assume that
a CONFIG_CPU_* symbol is exclusive. You could have (maybe not now, but
in the future) a kernel that supports running on an Octeon as well
as some other Mips64 processor, and have UPF_FIXED_PORT uart on some
other machine, which will make the kernel think it is a PORT_OCTEON.

	Arnd <><
