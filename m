Return-Path: <linux-kernel-owner+w=401wt.eu-S1758881AbXK0T36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881AbXK0T36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 14:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbXK0T3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 14:29:50 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:36002 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750741AbXK0T3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 14:29:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xl0b4II4I9+wNCkgiTdLOZeYHW6w4q4KpaEY2gU/PWMJslKjo2Ko2Ac5jZqX0BqDbWGydP7GID1v5/nYH7VgnksZh2v/fw9TAFiUs59QMSIBmsAiAdFGw/jFKI4XTDrkLwwhLUVg4GNUZ/fAIQ75neZAZqlg2Ds/4JuBJ6LDO3E=  ;
X-YMail-OSG: Qvj6wWAVM1k3TwUcuSt3VXGiB61WJ67q3ZTj9j.d.pA.CpZ7RS08Ad7O0Pelbko8L.GnRqsImA--
From: David Brownell <david-b@pacbell.net>
To: "eric miao" <eric.y.miao@gmail.com>
Subject: Re: [patch/rfc 1/4] GPIO implementation framework
Date: Tue, 27 Nov 2007 11:29:46 -0800
User-Agent: KMail/1.9.6
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Jean Delvare" <khali@linux-fr.org>,
       "Kevin Hilman" <khilman@mvista.com>, "Paul Mundt" <lethal@linux-sh.org>,
       "Ben Dooks" <ben@trinity.fluff.org>
References: <200710291809.29936.david-b@pacbell.net> <200711261746.55235.david-b@pacbell.net> <f17812d70711270258v1e2b47aam74da33687728a78@mail.gmail.com>
In-Reply-To: <f17812d70711270258v1e2b47aam74da33687728a78@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200711271129.46754.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 November 2007, eric miao wrote:
>         status = chip->direction_input(chip, gpio);
> -       if (status == 0)
> -               clear_bit(gpio, chip->is_out);
> +       if (status)
> +               desc->is_out = 0;

You added that same bug in two places (direction_output too).
Only zero status means success; otherwise it's negative errno.

Clearly this patch wasn't tested at all.
