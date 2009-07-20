Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbZGTUTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbZGTUTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZGTUTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:19:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33724 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZGTUTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:19:38 -0400
Message-ID: <4A64D0F2.7050009@zytor.com>
Date: Mon, 20 Jul 2009 13:17:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Doug Thompson <norsk5@yahoo.com>,
       Borislav Petkov <borislav.petkov@amd.com>, mingo@elte.hu,
       tglx@linutronix.de, aris@redhat.com, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH 07/14] mce3: pass mce info to EDAC for decoding
References: <20090720180446.GB16072@basil.fritz.box> <935428.51568.qm@web50110.mail.re2.yahoo.com> <20090720192229.GC16072@basil.fritz.box>
In-Reply-To: <20090720192229.GC16072@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> The goal is to have a default handler within the kernel and a more specific handler in a module after it has loaded. Using the weak symbol as a mechanism to do that. I haven't used that, so I don't know if it works.
> 
> weak symbols don't work over kernel modules.
> 

For modules, you typically have to have a callback to update an internal
function pointer.  If you think about it, it's pretty obvious -- a weak
symbol changes the behavior at link time, but it's still a static call.
 If you want modules to change the behavior, you're talking about a
*dynamic* change -- the call will point to different things at different
points in time -- so you need another mechanism, i.e. function pointers.

	-hpa

