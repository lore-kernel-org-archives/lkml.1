Return-Path: <linux-kernel-owner+w=401wt.eu-S1763832AbYBLS3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763832AbYBLS3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760594AbYBLS3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:29:11 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:47483 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759316AbYBLS3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:29:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WeOcIU8IfZPdJkTAuGCwIpK9LDKjhGsTkuq0ykvhhQ41AkyrWsVfntqEJ2CrAlS4cCikUTxlwFFY4pnM+r3ayfknsdmkqT4glIwpNfjH9xcod9iNrOF3478ZguMGkTzKd3PX143NxPSzpGoYjXFQcC579DiKs42nDlvtGKAMRt4=  ;
X-YMail-OSG: FLE3r9AVM1mtbPmVOmkXEb8xo9E5Cte1u56dqhxMpQQEsxOACa5I3ePstCiZh.B9RwZp.EXPrMF.A8qWq8ETYZm0P0xrWullgeMypWWjKxAD14S3Tg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: WARN_ON(): proc_dir_entry 'rtc' already registered
Date: Tue, 12 Feb 2008 10:29:07 -0800
User-Agent: KMail/1.9.6
Cc: kernel list <linux-kernel@vger.kernel.org>
References: <20080212132626.GA1534@elf.ucw.cz>
In-Reply-To: <20080212132626.GA1534@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802121029.08007.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2008, Pavel Machek wrote:
> I'm getting this during bootup:
> 
> PM: Adding info for No Bus:event6
> PM: Adding info for No Bus:uinput
> PM: Adding info for No Bus:rtc0
> proc_dir_entry 'rtc' already registered
> Pid: 1, comm: swapper Not tainted 2.6.25-rc1 #125
>  ... deletia
>  =======================
> rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
> rtc0: alarms up to one month, y3k
> PM: Adding info for platform:coretemp.0
> PM: Adding info for No Bus:hwmon1
> 
> ... .config attached.

Which shows:

 CONFIG_GEN_RTC=y
 CONFIG_GEN_RTC_X=y

Disable that, then those warnings will vanish.  (I'm told that
having proc_register() return a fault code is off the table,
much like impeachment.)

How to fix ... how about:  instead of just warning folk
off such legacy RTC drivers [1] we just wrap them with
an "if RTC_LIB != n" so this mistake won't be possible.

- Dave

[1] http://marc.info/?l=linux-kernel&m=120267619306747&w=2
