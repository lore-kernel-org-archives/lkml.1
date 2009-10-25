Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbZJYSjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbZJYSjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 14:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbZJYSjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 14:39:39 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:55576 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751094AbZJYSji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 14:39:38 -0400
X-Sasl-enc: mlrTDtcbhJTFIPEK9HIu168aE0608YKkmmvzBjDo+zv6 1256495982
Date: Sun, 25 Oct 2009 16:39:39 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>
Cc: gregkh@suse.de, alan@linux.intel.com,
       Andrew Morton <akpm@linux-foundation.org>, adobriyan@gmail.com,
       linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] serial: cascade needless conditionals
Message-ID: <20091025183939.GB10898@khazad-dum.debian.net>
References: <b8bf37780910250618h3edce547y41a8dd03e4fb4e71@mail.gmail.com>
 <20091025162019.GA10898@khazad-dum.debian.net>
 <b8bf37780910250937x14b8f008xd8443fe004749403@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8bf37780910250937x14b8f008xd8443fe004749403@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Oct 2009, André Goddard Rosa wrote:
> On 10/25/09, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> > On Sun, 25 Oct 2009, André Goddard Rosa wrote:
> >>  	if (flags == UPF_SPD_HI)
> >>  		altbaud = 57600;
> >> -	if (flags == UPF_SPD_VHI)
> >> +	else if (flags == UPF_SPD_VHI)
> >>  		altbaud = 115200;
> >> -	if (flags == UPF_SPD_SHI)
> >> +	else if (flags == UPF_SPD_SHI)
> >>  		altbaud = 230400;
> >> -	if (flags == UPF_SPD_WARP)
> >> +	else if (flags == UPF_SPD_WARP)
> >>  		altbaud = 460800;
> >
> > This changes code behaviour if more than one bit is set (which might never
> > happen for all I know...).  You should invert the order of the tests if you
> > want to make sure it is side-effect-free.
> 
> Do you mind explaining why? Notice that it's not (var & flag), it's =='.
> Can flags be equal more than one flag at the same time?

No, I obviously am going through coffee withdrawal :(  Sorry about this.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
