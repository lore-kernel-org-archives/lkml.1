Return-Path: <linux-kernel-owner+w=401wt.eu-S1757232AbYFZBOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbYFZBOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 21:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbYFZBOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 21:14:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41182 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYFZBOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 21:14:32 -0400
Message-ID: <4862ECAB.1040402@zytor.com>
Date: Wed, 25 Jun 2008 18:11:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Agner Fog <agner@agner.org>, linux-kernel@vger.kernel.org
Subject: Re: ABI change for device drivers using future AVX instruction set
References: <48626514.2040905@agner.org> <20080625092224.736c2541@infradead.org>
In-Reply-To: <20080625092224.736c2541@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> 
> Let me repeat this loud and clear:
> 
> It is not allowed to use floating point, SSE of AVX in device drivers.
> 
> (there are few places that very carefully do this anyway, the raid5
> code being the most obvious one, but we should not add more)
> 

Sadly, AVX repeats the mistakes of SSE1, and doesn't implement proper 
wide support for integer operations.  It has the basic bitwide stuff, 
which makes it usable for RAID-5, but it doesn't extend MMX (which SSE2 
eventually got around to), so it's not usable for RAID-6.  I'd hoped to 
find a VPERM-style instruction, like SSE5 has :(

	-hpa
