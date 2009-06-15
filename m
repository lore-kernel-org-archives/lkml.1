Return-Path: <linux-kernel-owner+w=401wt.eu-S1764143AbZFOSe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764143AbZFOSe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbZFOSeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:34:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57114 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741AbZFOSeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:34:15 -0400
Message-ID: <4A3693F8.6000209@zytor.com>
Date: Mon, 15 Jun 2009 11:33:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Petr Tesarik <ptesarik@suse.cz>
CC: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH v2 0/8] clean up vdso-layout.lds.S
References: <1244814040-5810-1-git-send-email-ptesarik@suse.cz>	 <20090612180626.GB18203@uranus.ravnborg.org>	 <1245079002.17481.118.camel@nathan.suse.cz>	 <1245079649.17481.121.camel@nathan.suse.cz>  <4A367C09.80008@zytor.com> <1245087957.17481.124.camel@nathan.suse.cz>
In-Reply-To: <1245087957.17481.124.camel@nathan.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Tesarik wrote:
>>>
>> *(COMMON) is BSS, not data...
> 
> Very true, but for the vDSO we decided to put both writeable and
> read-only data into one section (called .data for that matter), probably
> to reduce the number of sections and hence also the size of the
> resulting binary.
> 

BSS is neither, but I guess for the vDSO there really isn't any such
thing as uninitialized content.

I have to admit feeling funny about that, and I'm wondering if we
shouldn't compile the vDSO with -fno-common.

	-hpa

