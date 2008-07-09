Return-Path: <linux-kernel-owner+w=401wt.eu-S1752322AbYGIV0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbYGIV0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbYGIV0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:26:35 -0400
Received: from gw.goop.org ([64.81.55.164]:51453 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126AbYGIV0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:26:34 -0400
Message-ID: <48752CF0.20908@goop.org>
Date: Wed, 09 Jul 2008 14:26:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org>	<20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org> <4875231F.1020506@zytor.com> <487524A0.6020304@goop.org> <487529AE.3060505@zytor.com>
In-Reply-To: <487529AE.3060505@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Either way, I really suspect that the right thing to do is to use 
> negative offsets, with the possible exception of a handful of things 
> (40 bytes or less, perhaps like current) which can get small positive 
> offsets and end up in the "super hot" cacheline.
>
> The sucky part is that I don't believe GNU ld has native support for a 
> "hanging down" section (one which has a fixed endpoint rather than a 
> starting point), so it requires extra magic around the link (or 
> finding some way to do it with linker script functions.) 

If you're going to do another linker pass, you could have a script to 
extract all the percpu symbols and generate a set of derived zero-based 
ones and then link against that.

Or generate a vmlinux with relocations and "relocate" all the percpu 
symbols down to 0.

    J
