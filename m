Return-Path: <linux-kernel-owner+w=401wt.eu-S2992909AbXDTLV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992909AbXDTLV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 07:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbXDTLV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 07:21:26 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:46027 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbXDTLVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 07:21:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qeo48gvN/8sipjQcQb2XQr8uWbMDqbFWNBeFm17RT95GDEpEvgDuIS8NJeLxu8MIE/44shvOf90VZCkSQHUgGaPUDt1XzV8YRtjbifOpoa9d8NqlEQaGPFwDLlKypPwyusKy+zD9uV6xOvKdO6gkisR3I6Ht6qANdC7XR2cAabQ=
Message-ID: <ff1613620704200421w1e1aeea5r5acc3a7c0c548b96@mail.gmail.com>
Date: Fri, 20 Apr 2007 16:51:24 +0530
From: "Madhusudhan c" <cr.madhusudhan@gmail.com>
To: "Pierre Ossman" <drzeus@drzeus.cx>
Subject: Re: MMCv4 support (8-bit support missing)
Cc: linux-kernel@vger.kernel.org, philipl@overt.org
In-Reply-To: <462797EE.2050808@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ff1613620704162359w62df9e0ao6c43215a767bd706@mail.gmail.com>
	 <4625DAFC.4000208@drzeus.cx>
	 <ff1613620704180453t69585e21h5c31a4fe908d0aac@mail.gmail.com>
	 <46262953.3040801@drzeus.cx>
	 <ff1613620704190704n2cf37c9dv43536bb8fc0d4c79@mail.gmail.com>
	 <462797EE.2050808@drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Perre,

> Until 8-bit SD shows up, at which point things go to hell again.
>
> You need to present a valid case for why we need this bus testing stuff. The
> spec never requires it, and neither does any cards. So this is just crud that we
> know causes problems and doesn't give us anything back.
Okay. Let me try to explain a scenario where it is required.

Suppose a host controller is capable of suporting 8-bit and it tells
the core that it can support 8-bit. Now the card that is plugged in
might or might not support 8-bit based on the type of the card. There
is no field in the ext_csd which will tell you what bus width the card
can support.

So you need first try to setup 8-bit and send a patteren on the data
lines and read it back. If you get back the expected data then you are
good to go in 8-bit. Else, shift to 4-bit and try again with the data
patteren to see if four bit works. This is how the patch is
implemented. Also the spec says that you need to perform bus test
procedure before sending the switch command to set the bus width.

By doing this you can figure out whether the card supports 8-bit or
not. And this is the only way to support 8-bit cards, which are widely
available in the market today.

Also if the host controler says it can only support 4-bit then no need
of bus testing procedure.Ignoring the bus test procedure does not
affect you to functionally support 4-bit but there is no way you can
support 8-bit cards without it correctly.

Regards,
Madhu

On 4/19/07, Pierre Ossman <drzeus@drzeus.cx> wrote:
> Madhusudhan c wrote:
> >
> > The bus test procedure from this patch can be adopted to the MMCv4
> > support in the MMC core with small changes to do bus testing procedure
> > only if the host sets the capability to support 8-bit. That way we
> > dont break the legacy code. What do you think?
> >
>
> Until 8-bit SD shows up, at which point things go to hell again.
>
> You need to present a valid case for why we need this bus testing stuff. The
> spec never requires it, and neither does any cards. So this is just crud that we
> know causes problems and doesn't give us anything back.
>
> Rgds
> Pierre
>
>
>
>
