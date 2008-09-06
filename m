Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369AbYIFTQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbYIFTQj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 15:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYIFTQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 15:16:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:52251 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbYIFTQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 15:16:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CVD9C4NIL06co+aqPW6G2uLmJo9BBVun5OR9yn72OMOidwFziAU03Q/QaGrU2vf151
         yifsl4PY5XhWLCO3REc0HS13BG9/E7hBHMZgjNju+IoKt3TYj+orwEZVTNHB09ktmJ0Q
         0feHVByjpj5u8g5CC385PG8Q/JSk4CK2JkR4c=
Message-ID: <86802c440809061216n5bbad56amabf9934f8bf08d57@mail.gmail.com>
Date: Sat, 6 Sep 2008 12:16:28 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [patch 3/3] x86: io-apic - code style cleaning for setup_IO_APIC_irqs
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, "Ingo Molnar" <mingo@elte.hu>,
       hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20080906190446.GA23729@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080904183748.950151853@gmail.com>
	 <48c02b6a.0637560a.15e9.ffffa39d@mx.google.com>
	 <20080905080447.GC12409@elte.hu> <20080905180126.GA19334@lenovo>
	 <20080905181111.GG27395@elte.hu> <20080905183347.GB19334@lenovo>
	 <20080905183835.GA19215@elte.hu> <20080906101533.GA7273@lenovo>
	 <Pine.LNX.4.55.0809061938250.13851@cliff.in.clinika.pl>
	 <20080906190446.GA23729@lenovo>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 6, 2008 at 12:04 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> [Maciej W. Rozycki - Sat, Sep 06, 2008 at 07:45:08PM +0100]
> | On Sat, 6 Sep 2008, Cyrill Gorcunov wrote:
> |
> | > Ingo, how about the following approach? We don't introduce new
> | > functions but rather srink the code by new printout form.
> |
> |  Honestly, this one should probably use sprintf() or suchlike to avoid the
> | mess of printk() calls building a line of output from pieces.  It's quite
> | easy to calculate here what the maximum size of the buffer required could
> | be and automatic arrays can have variable size, so no need for the hassle
> | of heap management.  Calls to printk() without a trailing newline should
> | be avoided where possible as it messes up logging priority if a message
> | pops up from an interrupt inbetween.
> |
> |   Maciej
> |
>
> The easiest way would be just print this info on separate
> lines like
>
>        IO-APIC (apicid-pin) 1-1 not connected
>
> and just drop all this troubles :)
>
> I'm not sure how much memory we need for every io-apic
> pins - iirc there only 32 redirection entry so it could
> be about 32 bytes from stack would be enough. Will take
> a look. Thanks Maciej! Ingo?

no. some system could have 3 or 4 ioapic controller, and every one
have 24...(like three mcp55/io55)
4*24

or old system have 1 8111 and 7 8132. will have 32 + 7*2*7

YH
