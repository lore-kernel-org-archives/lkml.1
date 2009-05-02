Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbZEBDCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbZEBDCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 23:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbZEBDCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 23:02:40 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:55928 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbZEBDCj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 23:02:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gARDCEmfeYIWnC/o2Kxj150sYC6sy+sSXejZoeQrCO9asSfzyMzN/dSXkyRWyWQWvY
         OfVCsPDWcpCPS6fe8O9uLgkVPyDCj0cJehYfmqv7n2koR5WITmZTAtK8TUMdvRah1LMw
         GWUVZk5MlYjWbQT8N6Tmrl2YKwmNHNvDcGFCU=
MIME-Version: 1.0
In-Reply-To: <20090502015927.GJ8822@parisc-linux.org>
References: <524f69650905011318m34e0027dt57877d225b3fe2da@mail.gmail.com>
	 <20090501210109.GA3079@infradead.org>
	 <20090502013729.GI6996@linux.vnet.ibm.com>
	 <20090502015927.GJ8822@parisc-linux.org>
Date: Fri, 1 May 2009 22:02:38 -0500
Message-ID: <524f69650905012002u190f357ax5fad7f3d8d660bcf@mail.gmail.com>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
From: Steve French <smfrench@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, Andrew Tridgell <tridge@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 1, 2009 at 8:59 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Fri, May 01, 2009 at 06:37:29PM -0700, Paul E. McKenney wrote:
>> However, as far as I know, none of us are lawyers, and LKML is definitely
>> a technical rather than a legal forum, so we really do need to stick to
>> technical topics.  I understand that this might be a bit frustrating
>> to you.  On the other hand, I for one much prefer being in a forum
>> restricted to technical topics than to be in those places designed to
>> handle legal topics!
>
> So what's the purely technical argument for including this patch?
The strength of Tridge's approach over alternatives may be that it is clearer
to only create one name (always) and that it is relatively small.
Its weakness in my opinion is that as a sideeffect it prevents saving mixed
case file names.

There are various ways to disable (only) creating long file names, ie
to remove the ability
to create files longer than 8.3 from this module.   Tridge's approach (which
basically avoids saving the alternate name, the mixed case name) works.
I realize that there are other ways to do this with trivial #ifdefs in
namei_vfat.c (see
vfat_build_slots and vfat_create_shortname), and when I tried other approaches
they worked too, although you may prefer Tridge's approach.



-- 
Thanks,

Steve
