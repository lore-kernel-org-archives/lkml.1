Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbZELRpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbZELRpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 13:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbZELRpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 13:45:00 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:12490 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbZELRo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 13:44:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TkEL07Loyv8KQC9VHlqSEAnFWr4c9ijNrQeS64Pf7YMjBapml22ji0AN355vXnNwxX
         vThEf6vm2hArfuK4MwnEQwjDfX8bxSZwGlrqVB9wxNAlL3ovsbdKw8UZ8mkE0ZpscA5N
         0Aj9qKZ1RPkIOjkGKuaNae9D0EdLEPrrBGSbQ=
MIME-Version: 1.0
In-Reply-To: <20090512150408.GH19296@one.firstfloor.org>
References: <200904301408.09370.tobias.doerffel@gmail.com>
	 <877i0xib7d.fsf@basil.nowhere.org>
	 <a36005b50905120720p14e0ea0av79f99551262a920a@mail.gmail.com>
	 <20090512150408.GH19296@one.firstfloor.org>
Date: Tue, 12 May 2009 10:45:00 -0700
Message-ID: <a36005b50905121045s62c16760p3aba003647a572c7@mail.gmail.com>
Subject: Re: Specific support for Intel Atom architecture
From: Ulrich Drepper <drepper@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Tobias Doerffel <tobias.doerffel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 8:04 AM, Andi Kleen <andi@firstfloor.org> wrote:
> The problem is that you can't express the situations where
> movbe is better than bswap (you need both and the old and the new
> value) in inline assembler in a way that gcc decides automatically.

True.  But I was mostly thinking about loads from memory.  A quick
search for ntoh*/hton* shows code like

        u_int16_t queue_num = ntohs(nfmsg->res_id);

If there would be a ntohs_load() macro movbe could be used.
