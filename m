Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbXFLNNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbXFLNNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 09:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbXFLNNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 09:13:09 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:52819 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540AbXFLNNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 09:13:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m4aN8uDYqGNyGN5+8R4WgF1LKg8U2nn/KrWZZyEnzIgGCBcrxB7AQkGiIjXY//t35idu+WSru/z5Xe0ESNW7WvrufdjNPS6DCprhw7/nI2Q2vgj2+vOk+0P6Th9S7llYhQaoJf8FpUTrCpKyTsFMe7IEdLmeQYLqgK03TIgwEmk=
Message-ID: <d120d5000706120613o7a328e59v3cba37f0ced88e77@mail.gmail.com>
Date: Tue, 12 Jun 2007 09:13:06 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Renato Golin" <rengolin@gmail.com>
Subject: Re: joydev.c and saitek cyborg evo force
Cc: "Jiri Kosina" <jkosina@suse.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <d9b9d95f0706120608g979b89oc79dbc277d19862b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com>
	 <d120d5000705311253n67d4247eh194e6f4457a0b4c@mail.gmail.com>
	 <Pine.LNX.4.64.0705312220250.5177@jikos.suse.cz>
	 <d9b9d95f0706011116j59fff917x9a86aac377f88937@mail.gmail.com>
	 <Pine.LNX.4.64.0706031139570.5177@jikos.suse.cz>
	 <d9b9d95f0706041506l257819a7pbcb8b8efc2eec049@mail.gmail.com>
	 <Pine.LNX.4.64.0706050008160.5177@jikos.suse.cz>
	 <d9b9d95f0706041546h4eef0b4eo2e191968be13d59a@mail.gmail.com>
	 <Pine.LNX.4.64.0706121436070.10204@jikos.suse.cz>
	 <d9b9d95f0706120608g979b89oc79dbc277d19862b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Renato,

On 6/12/07, Renato Golin <rengolin@gmail.com> wrote:
> On 12/06/07, Jiri Kosina <jkosina@suse.cz> wrote:
> > the thing is that the aim of this quirk is to normalize the values that
> > are being reported by bogus devices, so we don't really want to trust the
> > values they provide here, do we?
>
> Hi Jiri,
>
> I don't know about the other joysticks, but Saitek did reported [0,
> 4096] which is the right answer, but between HID and Joydev it was
> converted to [-127, 127]. I thought that the quirk was about that.
>

We need to find out why you see [-127, 127] range, because if joydev
would see [0, 4096] range it would perform automatic correction and
map values like this:

c0: 2048, c1: 2048, c2: 262144, c3: 262144
0 -> -32768
204 -> -29504
408 -> -26240
612 -> -22976
816 -> -19712
1020 -> -16448
1224 -> -13184
1428 -> -9920
1632 -> -6656
1836 -> -3392
2040 -> -128
2244 -> 3136
2448 -> 6400
2652 -> 9664
2856 -> 12928
3060 -> 16192
3264 -> 19456
3468 -> 22720
3672 -> 25984
3876 -> 29248
4080 -> 32512

Which is fine as far as I can see. What utility did you use that
reported [-127; 127] range?

-- 
Dmitry
