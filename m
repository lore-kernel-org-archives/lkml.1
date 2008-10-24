Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbYJXNHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbYJXNHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 09:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbYJXNGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 09:06:51 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:48578 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbYJXNGu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 09:06:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jpqI8v/ooLJC9fi7X2k3Ic/C3CHVe9tJerlLP1ROzw/01L/UmGIchBDG5O2DzhJjpB
         D8wjt3WdsoaMXs0FM3ClqmmoInOiLMDRSambnaWg/Hfht0iU/j/cPugdelqog0twUDwH
         le1WC3LS/r3fECqQz70uQp1gOiRWj1oYa+6s0=
Message-ID: <50a66e370810240606ncb3dcd6gc949b734b1dcf488@mail.gmail.com>
Date: Fri, 24 Oct 2008 09:06:49 -0400
From: "Todd Hayton" <todd.hayton@gmail.com>
To: "Pekka Savola" <pekkas@netcore.fi>
Subject: Re: IPv6 multicast forwarding
Cc: "=?ISO-8859-1?Q?Alejandro_Riveira_Fern=E1ndez?=" <ariveira@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <alpine.LRH.2.00.0810241307360.1106@netcore.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <50a66e370810231511m10a10ca2oa870e9fbd55f4b0e@mail.gmail.com>
	 <20081024111044.74c15155@varda>
	 <alpine.LRH.2.00.0810241307360.1106@netcore.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 6:12 AM, Pekka Savola <pekkas@netcore.fi> wrote:
> On Fri, 24 Oct 2008, Alejandro Riveira Fernández wrote:
>>>
>>> Let me apologize in advance for the length of this message - it is long!
>>>
>>> I'm trying to test out IPv6 multicast forwarding on a 2.6.26 kernel
>>> and I'm getting some strange values for the upcall messages from the
>>> kernel. My code is below, but to give an overview, my setup is as
>>> follows:
>>>
>>>    sender ------ ff15::1 -----> [eth1] linux 2.6.26 [eth0] ------> ...
>
> Maybe this isn't the bug you're looking for but you shouldn't be using ff1x
> multicast addresses in a test like this; ff1x means that the multicast group
> is of "interface-local scope" and it isn't useful for multicast forwarding.
>  So the kernel might be correct in not installing multicast forwarding state
> for a group address like this (but if it's a conscious decision, maybe the
> failure mode should be better).  See S 2.7 of RFC4291.
>

Hey there, thanks for the response! I may be misinterpreting the RFC
but I thought ff15::1 was a site-local address. As in I break down
ff15::1 as follows -

0xff : identifies the address as multicast
0x15 : 4-bits flags and 4-bits scope where
  flags = 0x1 meaning that the T bit is set as this address is not a
permanently assigned address
  scope = 0x5 indicating site-local scope

Todd H


> --
> Pekka Savola                 "You each name yourselves king, yet the
> Netcore Oy                    kingdom bleeds."
> Systems. Networks. Security. -- George R.R. Martin: A Clash of Kings
