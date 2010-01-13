Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032Ab0AMQio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab0AMQio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755722Ab0AMQio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:38:44 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:40718 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab0AMQin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:38:43 -0500
Message-ID: <4B4DF6B1.406@s5r6.in-berlin.de>
Date: Wed, 13 Jan 2010 17:37:05 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       =?ISO-8859-1?Q?Ren=E9_?= =?ISO-8859-1?Q?Bolldorf?= 
	<xsecute@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Question]  For what stand's __initdata, __devinit etc. ?
References: <4B4CAA49.4090707@googlemail.com> <20100112234228.GA21777@khazad-dum.debian.net> <4B4DB0E3.9020707@imap.cc>
In-Reply-To: <4B4DB0E3.9020707@imap.cc>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> Am 2010-01-13 00:42 schrieb Henrique de Moraes Holschuh:
>> On Tue, 12 Jan 2010, René Bolldorf wrote:
>>> Hi,
>>> Do we really need this?
>>> It will be nice if someone can me explain this.
>> 
>> http://kernelnewbies.org/FAQ/InitExitMacros
> 
> That's far from complete. It does not, for example, mention __devinit.

This wiki contains also somewhat misleadingly worded text:  "But why
must you use these macros ?"  This should read:  "But why would you want
to use these macros?"

Answer:  They are a micro-optimization which allows the kernel to free
memory that was occupied by this code at some point, because that code
won't be used after that point anymore.  (In case of exit macros:  These
are hints to discard some code from a build in case of certain kernel
configurations.)  These macros only affect code which is statically
linked into the kernel.

Some macros, like for example __devinit, have so obscure uses and
marginal benefits that a normal developer should not bother about them.
__devinit in particular does not have any effect at all --- except if
CONFIG_HOTPLUG is not defined.  This may happen in configurations for
embedded systems.  But the majority of device drivers that you can find
in the kernel tree are irrelevant (i.e. configured off) on such systems
anyway.

Some more information on these macros can be found in Corbet, Rubini,
Kroah-Hartman: Linux Device Drivers, 3rd edition a.k.a. LDD3, which is
also gratis available on the Web.
-- 
Stefan Richter
-=====-==-=- ---= -==-=
http://arcgraph.de/sr/
