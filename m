Return-Path: <linux-kernel-owner+w=401wt.eu-S932859AbYD1HwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859AbYD1HwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 03:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763172AbYD1HwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 03:52:13 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:16068 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763158AbYD1HwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 03:52:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=V/hGCTZWOLf75IxQE4WET3ehoES2aA0Ve6rU4oOgzWNN6uq3UUa6o3wfpIfdyFEHNIfcUpxTn2NZHTel8MGAHXUfZvKfoG+jdxq3OB3MsfxHL9+IYTYXujdgCTNhm5awT9fPf/I4m0+P1tgTGXg7moiulUkcfbT/AQ67lEgkQRI=
Message-ID: <ce0170d90804280052y130c3fa2pbf3f97147f03b159@mail.gmail.com>
Date: Mon, 28 Apr 2008 04:52:11 -0300
From: "Sergio Luis" <sergio@uece.br>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] build fix for smp
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, ak@suse.de
In-Reply-To: <20080319195217.GA20762@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12059466674071-git-send-email-gcosta@redhat.com>
	 <20080319195217.GA20762@elte.hu>
X-Google-Sender-Auth: 3c885c7ae9292dd4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 4:52 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Glauber de Oliveira Costa <gcosta@redhat.com> wrote:
>
>  > +#if defined(CONFIG_X86_64) || defined(CONFIG_X86_BIOS_REBOOT)
>  >       if (reboot_force)
>  >               return;
>  > +#endif
>
>  please solve it slightly differently: introduce a uniformly usable
>  reboot_force flag, that will always default to the constant of 1 if
>  !X86_64 && !X86_BIOS_REBOOT. That makes the code cleaner - and not the
>  least i can also merge the fix earlier in the series, without having to
>  redo the big smp.c movement patch :-)
>
>         Ingo
>

Hello,
what's the final fix for this issue? 2.6.25-git11 is still broken, just gave me

arch/x86/kernel/built-in.o: In function `native_smp_send_stop':
smp.c:(.text+0xc751): undefined reference to `reboot_force'
make: *** [.tmp_vmlinux1] Error 1

for a randconfig. Same reported at http://lkml.org/lkml/2008/4/27/39

thanks,
-sergio
