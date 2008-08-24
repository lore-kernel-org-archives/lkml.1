Return-Path: <linux-kernel-owner+w=401wt.eu-S1756427AbYHXSn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbYHXSn4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 14:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYHXSnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 14:43:47 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:42935 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbYHXSnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 14:43:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hqG11djtpryzwdfEcwWBJ6EK4CxWF18GLWfavX6o/6koOYaFTPdeWSp5x9VprhzYMG
         nQ2EUiVwWt5/8NfaZ7KiFeVNEFBqkaH5nghbkZCuBBP/GQdUzVvIWZApSFXWQXppIqQA
         5DHyVDTrkGITuuqYyemrvobuwJpro5Y9CCblM=
Message-ID: <19f34abd0808241143t6f5239d7o679135e9e974fe63@mail.gmail.com>
Date: Sun, 24 Aug 2008 20:43:45 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Daniel J Blueman" <daniel.blueman@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0808241050180.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
	 <alpine.LFD.1.10.0808241050180.3363@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 8:03 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Sat, 23 Aug 2008, Rafael J. Wysocki wrote:
>>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=11410
>> Subject               : SLUB list_lock vs obj_hash.lock...
>> Submitter     : Daniel J Blueman <daniel.blueman@gmail.com>
>> Date          : 2008-08-22 21:48 (2 days old)
>> References    : http://marc.info/?l=linux-kernel&m=121944176609042&w=4
>
> This one now has a suggested patch for Daniel to try from Vegard, but no
> reply yet:
>
>        http://marc.info/?l=linux-kernel&m=121946972307110&w=4
>

Hi!

> Vegard, I think your patch is a bit odd, though. The result of your patch
> is
>
>  - first loop:
>
>        hlist_for_each_entry_safe(obj, node, tmp, &db->list, node) {
>                hlist_del(&obj->node);
>                hlist_add_head(&obj->node, &freelist);
>        }
>
>   and quite frankly, I don't see what the difference between that and a
>   something like a simple
>
>        struct hlist_node *first = bd->list.first;
>        if (first) {
>                bd->list.first = NULL;
>                first->pprev = &first;
>        }
>
>   really is?
>
> I dunno. We don't have list splicing ops for the hlist things.

Hm.

I haven't really used the hlists before, so my first instinct was to
do what is obvious. That's also why I put the XXX comment. Other than
that, I guess open-coding list ops is also not very good programming
practice? :-)

But... feel free to submit your own patch. Oh, what am I saying.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
