Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbYAFA2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbYAFA2k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 19:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbYAFA2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 19:28:32 -0500
Received: from slackadelic.com ([65.196.224.53]:53345 "EHLO
	mail.slackadelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbYAFA2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 19:28:31 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: =?iso-8859-1?q?R=E9mi_H=E9rilier?= <rherilier@yahoo.fr>
Subject: Re: wistron_btns-add-support-for-x86_64-systems.patch in -mm
Date: Sun, 6 Jan 2008 00:28:26 +0000
User-Agent: KMail/1.9.7
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, dtor@mail.ru, linux-input@vger.kernel.org
References: <20071223144756.GA4827@basil.nowhere.org> <477FC3C6.8070607@yahoo.fr>
In-Reply-To: <477FC3C6.8070607@yahoo.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801060028.27102.carlos@strangeworlds.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 January 2008 17:52:06 Rémi Hérilier wrote:
> What about finding what does this BIOS function and writing
> an equivalent in C? There would be no BIOS call anymore and
> this module could be used in the x86-64 port.
>
> But, is it a sane solution?

The problem is that the BIOS call would be unique to each supported machine as 
in which memory addresses, EC registers etc get touched and with what values. 
You would end up needing to reimplement this on a case-by-case basis. This 
was an idea that was considered by acerhk, but they considered it far too 
much work and completely impractical.

For at least all modern Acer laptops, this direct BIOS calling is completely 
deprecated, in favour of ACPI-WMI (which in turn, on those systems, usually 
either triggers SMI traps or touches EC registers, and is 32/ 64 bit 
agnostic), so the question for those laptops is becoming more and more 
irrelevant (and modern Acer laptops of the last four years, at least, don't 
have problems with missing keycodes that require us to poll).

For Fujitsu-Siemens laptops, I did come across someone who was looking into 
poking at ACPI to generate keypresses for the keys that don't generate 
standard keycodes[1], as a 32/ 64 bit agnostic solution (since most Fujitsu 
Siemens laptops don't support the required BIOS call from long mode, and also 
still don't produce standard keycodes on certain button presses).

-Carlos

[1] http://code.google.com/p/fscamiloa16xx/
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
