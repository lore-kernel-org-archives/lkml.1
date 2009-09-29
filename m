Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbZI2Jvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbZI2Jvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 05:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbZI2Jvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 05:51:54 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:61417 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbZI2Jvx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 05:51:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=K7qkQ1/ip98vqw86Tv+m9UxikNdaR5+k/BJ1mGeiwvFmY6Od2ur2hE1rIFrUjmmzRk
         9mHIIK8Z/aNafFMySB//6cOn9Zogl3ArAeElME+Q2MCZtcwRYADNpJNoKvffSsj1ZK6j
         UVF9QjrhA0vz28KJvfxwcYmcC2t83G/Kwd27s=
MIME-Version: 1.0
In-Reply-To: <4AC1E15502000078000516B5@vpn.id2.novell.com>
References: <4AC1E15502000078000516B5@vpn.id2.novell.com>
Date: Tue, 29 Sep 2009 11:51:56 +0200
Message-ID: <25e057c00909290251h55c0dc25o4ab1f2e84c920dca@mail.gmail.com>
Subject: Re: linux-next: tree build failure
From: roel kluin <roel.kluin@gmail.com>
To: Jan Beulich <jbeulich@novell.com>
Cc: sfr@canb.auug.org.au, hollisb@us.ibm.com, akpm@linux-foundation.org,
       linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 11:28 AM, Jan Beulich <jbeulich@novell.com> wrote:
>>>> Hollis Blanchard  09/29/09 2:00 AM >>>
>>First, I think there is a real bug here, and the code should read like
>>this (to match the comment):
>>    /* type has to be known at build time for optimization */
>>-    BUILD_BUG_ON(__builtin_constant_p(type));
>>+    BUILD_BUG_ON(!__builtin_constant_p(type));
>>
>>However, I get the same build error *both* ways, i.e.
>>__builtin_constant_p(type) evaluates to both 0 and 1? Either that, or
>>the new BUILD_BUG_ON() macro isn't working...
>
> No, at this point of the compilation process it's neither zero nor one,
> it's simply considered non-constant by the compiler at that stage
> (this builtin is used for optimization, not during parsing, and the
> error gets generated when the body of the function gets parsed,
> not when code gets generated from it).
>
> Jan

then maybe

if(__builtin_constant_p(type))
        BUILD_BUG_ON(1);

would work?

Roel
