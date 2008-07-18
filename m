Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbYGRJQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbYGRJQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbYGRJQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:16:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:43916 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbYGRJQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:16:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=mm3nB7GmwG2mvuSME3eLfGdXy5PZF/WKt19GzEQToGPxWoe1m3ukOmvYaCjM/9nedx
         pmAd1NxIu9JJ2W356igNlL7PRCzqcuriPOhTGXFwWlcBJ17Cd8MluGW3XCRgTmKw8q2s
         WnyqD7hGIq+OoLAXWggfRNHoGg5O5kxM7IKHs=
Message-ID: <84144f020807180216mfd5e803o8f3f1a94b2db1a74@mail.gmail.com>
Date: Fri, 18 Jul 2008 12:16:26 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison overwritten
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, cl@linux-foundation.org,
       davem@davemloft.net, johnpol@2ka.mipt.ru
In-Reply-To: <20080718091146.GQ6875@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080717214222.GA29449@elte.hu>
	 <Pine.LNX.4.64.0807181149460.3852@sbz-30.cs.Helsinki.FI>
	 <20080718091146.GQ6875@elte.hu>
X-Google-Sender-Auth: d7cb49523a65b0d6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 12:11 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
>
>> >   Object 0xf658ae70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>>
>> It's bit unfortunate that we don't see full dump of the corruption
>> here because SLUB limits the output to 128 bytes. Ingo, you might want
>> to try this patch so that we can see all of it:
>
> ok, applied this as a debug special to tip/out-of-tree - future
> incidents should have the full object dump.
>
> would makes sense for upstream too i think, or increase the limit to 4K
> or so. (which is still fair to be dumped into a syslog)

SLUB already limits object sizes to less than PAGE_SIZE so the patch
should be fine. Christoph, are you okay with this going upstream?
