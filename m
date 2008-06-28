Return-Path: <linux-kernel-owner+w=401wt.eu-S1753744AbYF1Lr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbYF1Lr5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 07:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbYF1Lrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 07:47:48 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:45496 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbYF1Lrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 07:47:48 -0400
To: Agner Fog <agner@agner.org>
Cc: Arjan van de Ven <arjan@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ABI change for device drivers using future AVX instruction set
From: Andi Kleen <andi@firstfloor.org>
References: <48626514.2040905@agner.org>
	<20080625092224.736c2541@infradead.org> <4862ECAB.1040402@zytor.com>
	<4864CFA5.9050901@agner.org> <20080627072231.7337ba18@infradead.org>
	<4865F0DA.2050906@agner.org>
Date: Sat, 28 Jun 2008 13:47:43 +0200
In-Reply-To: <4865F0DA.2050906@agner.org> (Agner Fog's message of "Sat, 28 Jun 2008 10:05:46 +0200")
Message-ID: <87myl5pyqo.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Jun 2008 11:40:23.0788 (UTC) FILETIME=[C0892AC0:01C8D913]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Agner Fog <agner@agner.org> writes:

I explained it earlier, but you didn't seem to have understood it.
Here's it again in a simpler form:

If a x86 device driver doesn't use the standard kernel interfaces
for saving/restoring extended state (kernel_fpu_begin/end) it will die. 
That is because Linux uses lazy FPU saving by default and when the lazy FPU exception
hits kernel code it will crash because that's not allowed. 

And the standard interfaces are going to handle all extended state supported
by the kernel. Full XSAVE support should be there for 2.6.27.

Pretty much the whole problem you describe in your original email doesn't
apply to Linux because of that.

-Andi

