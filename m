Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbZKCDJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbZKCDJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 22:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757217AbZKCDJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 22:09:47 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:38471 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757175AbZKCDJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 22:09:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=v5YBIvP9yr1Zhh5knZXh7WKeBnPaEjzsGCI3Q57BdqKsnN9EHs23JRgMaWfVnu0uk+
         JsiRoNXWBUY/janKH4HDmgbyGytJBxCYmnyt514d30ROChMsYHjGE3Zw2ICaWgpCERu6
         zfTmv8E3gAZTr2HaHMEaIkGbP4FdtzLmvJdMA=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0911022156420.21361@localhost.localdomain>
References: <43e72e890910271640n7fafc8edpc14143fcfca7df60@mail.gmail.com> 
	<20091027165345.3237d3df@infradead.org> <alpine.LFD.2.00.0911022156420.21361@localhost.localdomain>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 2 Nov 2009 19:09:30 -0800
Message-ID: <43e72e890911021909ke760ee1sd68caa92f66d1727@mail.gmail.com>
Subject: Re: scheduling while atomic acpi_idle_enter_bm
To: Len Brown <lenb@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 2, 2009 at 7:02 PM, Len Brown <lenb@kernel.org> wrote:
>> > I get this when modprobing some module I am working on. I figured it
>> > was the module's fault but the EIP points to something else so I am
>> > not sure. I get the following repeating about 4 times on 2.6.32-rc5:
>>
>>
>> you can get this if your own code leaves interrupts disabled in a
>> kernel thread and then lets the cpu go idle...
>
> Unclear.
>
> acpi_enter_idle_bm() assumes that it is entered with irqs enabled,
> and so it we unconditionally disables IRQs.
>
> Then we unconditionally re-enable them.
>
> The problem seems to be that right after we enable them,
> we find that they are actually disabled, perhaps as
> a side-effect of SMM.
>
> Is your machine a Dell, per chance?

Nope.

> Please test the patches in this bug report:
> http://bugzilla.kernel.org/show_bug.cgi?id=14101

In my case it was as Arjan pointed out and I've fixed it in my driver.
Sorry for not reporting back and thanks for your review.

  Luis
