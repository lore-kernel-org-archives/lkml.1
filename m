Return-Path: <linux-kernel-owner+w=401wt.eu-S1751479AbZGRRoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbZGRRoj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 13:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbZGRRoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 13:44:38 -0400
Received: from bu3sch.de ([62.75.166.246]:45573 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbZGRRoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 13:44:37 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] nvram: Fix root triggerable integer overflow crash
Date: Sat, 18 Jul 2009 19:44:33 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200907180256.45934.mb@bu3sch.de> <20090718150909.GA1191@khazad-dum.debian.net>
In-Reply-To: <20090718150909.GA1191@khazad-dum.debian.net>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907181944.33338.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 July 2009 17:09:09 Henrique de Moraes Holschuh wrote:
> On Sat, 18 Jul 2009, Michael Buesch wrote:
> > This bug probably is exploitable by overwriting the function return address or something
> > like that. But let's hope there's no distribution out there with user write permissions
> > on the /dev/nvram node. So it's probably only exploitable by root.
> 
> I have seen setups with group-writeable /dev/nvram to support some (old!)
> thinkpad utilities.

Yes it is  crw-rw---- 1 root root  on Debian.
Are there any setuid programs accessing nvram (like the recent tun/pulseaudio exploit?)

> Even if it cannot be exploited for more than a DoS,

You can randomly overwrite the kernel stack with the data you write to the device.
So I do think it is exploitable, because the char device writer controls the kernel stack completely.
However, I do not have an example exploit.

> IMO that's still bad 
> enough to warrant fixing this also on stable kernels if they are vulnerable.
> So, does the fix also apply to 2.6.27+ ?  If it does, please send it to
> stable@kernel.org as well.

Yeah I forgot to add stable to CC.

-- 
Greetings, Michael.
