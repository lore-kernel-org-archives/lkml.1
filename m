Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbYEJU1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbYEJU1G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 16:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbYEJU0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 16:26:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56007 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbYEJU0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 16:26:55 -0400
Message-ID: <482604D1.7020804@zytor.com>
Date: Sat, 10 May 2008 13:25:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
Subject: Re: 2.6.26-rc1 on x86: ld: warning: dot moved backwards before `.text'
References: <18470.787.498329.144701@harpo.it.uu.se>
In-Reply-To: <18470.787.498329.144701@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> 
> The resulting kernel hasn't broken on me yet, however.
> 
> A search through the LKML archives showed that this was reported
> for 2.6.25-rc3-mm1, but I couldn't find any discussion about it
> after that:
> 
> <http://marc.info/?l=linux-kernel&m=120470303728010&w=2>
> 
> The .config causing this warning is available in
> <http://user.it.uu.se/~mikpe/linux/ale/config-2.6.26-rc1>
> 

This is because the organization of the file was changed, and the linker 
script wasn't changed to match:

SECTIONS
{
         . = HEADER_OFFSET;
         .header : {
                  *(.header)
         }

         . = 0;
         .text : {
                  *(.text*)
         }

This is crap; the sections should be listed *in order* so the linker can 
warn properly when something bad happens.

The code should be correct; reorganizing the linker script correctly 
should fix the problem.

	-hpa
