Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbYEJU4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbYEJU4e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 16:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbYEJU4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 16:56:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57262 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbYEJU4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 16:56:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.26-rc1 on x86: ld: warning: dot moved backwards before `.text'
Date: Sat, 10 May 2008 22:56:08 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Mikael Pettersson <mikpe@it.uu.se>, Pavel Machek <pavel@ucw.cz>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
References: <18470.787.498329.144701@harpo.it.uu.se> <482604D1.7020804@zytor.com>
In-Reply-To: <482604D1.7020804@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805102256.09519.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 10 of May 2008, H. Peter Anvin wrote:
> Mikael Pettersson wrote:
> > 
> > The resulting kernel hasn't broken on me yet, however.
> > 
> > A search through the LKML archives showed that this was reported
> > for 2.6.25-rc3-mm1, but I couldn't find any discussion about it
> > after that:
> > 
> > <http://marc.info/?l=linux-kernel&m=120470303728010&w=2>
> > 
> > The .config causing this warning is available in
> > <http://user.it.uu.se/~mikpe/linux/ale/config-2.6.26-rc1>
> > 
> 
> This is because the organization of the file was changed, and the linker 
> script wasn't changed to match:
> 
> SECTIONS
> {
>          . = HEADER_OFFSET;
>          .header : {
>                   *(.header)
>          }
> 
>          . = 0;
>          .text : {
>                   *(.text*)
>          }
> 
> This is crap; the sections should be listed *in order* so the linker can 
> warn properly when something bad happens.
> 
> The code should be correct; reorganizing the linker script correctly 
> should fix the problem.

Hm.  The above is from Pavel and Sam.

Thanks,
Rafael
