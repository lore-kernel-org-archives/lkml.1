Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbYHTJo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbYHTJo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 05:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbYHTJoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 05:44:18 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:38785 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889AbYHTJoR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 05:44:17 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: Ingo Molnar <mingo@elte.hu>
Date: Wed, 20 Aug 2008 11:44:02 +0200
User-Agent: KMail/1.9.9
Cc: Samuel Sieb <samuel@sieb.net>, linux-kernel@vger.kernel.org,
       "Rafael C. de Almeida" <almeidaraf@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Magnus Damm <magnus@valinux.co.jp>, takada <takada@mbf.nifty.com>
References: <48841A92.4020301@sieb.net> <489A82D5.6020903@sieb.net> <20080820093238.GA22511@elte.hu>
In-Reply-To: <20080820093238.GA22511@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808201144.02919.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 83.236.181.29
X-SA-Exim-Mail-From: jbe@pengutronix.de
Subject: Re: kernel won't boot on a Cyrix MediaGXm (Geode )
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.extern.pengutronix.de)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch, 20. August 2008, Ingo Molnar wrote:
> * Samuel Sieb <samuel@sieb.net> wrote:
> > Ingo Molnar wrote:
> >> any patch we should pick up to make your box boot?
> >
> > I've looked through various datasheets and found that the GXm and GXLV
> > Geode processors don't have an incrementor.  I attached two patches. One
> > only calls the incrementor setup for GX1 or better.  The other one
> > removes the incrementor setup entirely.  As the incrementor value
> > differs according to clock speed and we would hope that the BIOS
> > configures it correctly, it is probably the better one to choose.  But I
> > will leave that choice up to you.  Either one works for me. :-)
>
> i went for the commit below and queued it up in tip/x86/urgent - thanks
> Samuel.
>
> what happens if the incrementor is not set up correctly by the BIOS

The system can freeze. The clock the incrementor modifies is used for the 
external SDRAM (something like a delay line or jitter reduction). Thats why 
its setting depends on the core clock speed.

Juergen
-- 
Dipl.-Ing. Juergen Beisert | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
    Handelsregister: Amtsgericht Hildesheim, HRA 2686
         Vertretung Sued/Muenchen, Germany
   Phone: +49-8766-939 228 |  Fax: +49-5121-206917-9
