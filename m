Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbYG2Gli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbYG2Gli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 02:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbYG2Gl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 02:41:29 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:45595 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbYG2Gl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 02:41:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lnSxe/BCVUldQsmp/NVV8Zc4TdQyDRjTs3N3GvlkxIy5nK/qUoxZJ4TnROMKJSBpUK
         cEdGxHt2HyufqxvBidaXRfUDsYMvuGlj+uh4mdxi4jThmD9AQoTvKV51gUOka197ZHkM
         4o5HSGo6mazYqmnIdsfPz2HcrRNwjGvK1rBCQ=
Message-ID: <86802c440807282341g65c90f10gbdcf72beecdd0852@mail.gmail.com>
Date: Mon, 28 Jul 2008 23:41:27 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 0/5] x86 cleanup: convert round_up() to roundup()
Cc: "Joerg Roedel" <joerg.roedel@amd.com>, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080726133932.GB4401@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216997339-31427-1-git-send-email-joerg.roedel@amd.com>
	 <20080726133932.GB4401@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 6:39 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
>
>> The x86 architecture declares its own round_up macro. But there is a
>> generic one in <linux/kernel.h> which can also be used. This patchset
>> replaces the x86 round_up() macro with the generic roundup() one where
>> possible. The patches have been compile-tested for 32 and 64 bit and
>> boot-tested for 64 bit. If we can fix the other places too we can get
>> rid of the x86 specific round_up() in the future.
>
> applied to tip/x86/cleanups - thanks Joerg!
>
these patches looks like some backward, aka wrong direction.

#define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))

#define round_up(x, y) (((x) + (y) - 1) & ~((y) - 1))
#define round_down(x, y) ((x) & ~((y) - 1))

round_up looks more efficient.

YH
