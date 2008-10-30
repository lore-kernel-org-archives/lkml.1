Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbYJ3UtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbYJ3UtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbYJ3UtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:49:15 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:44387 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753101AbYJ3UtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:49:14 -0400
X-Sasl-enc: lKrMPFDK/RQWBq8+J9NQV9yXDx/oQzKy4DeS7xhytSBs 1225399752
Date: Thu, 30 Oct 2008 18:49:05 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jonathan McDowell <noodles@earth.li>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Fix logic error in rfkill_check_duplicity
Message-ID: <20081030204905.GB29976@khazad-dum.debian.net>
References: <20081029164006.GH3162@earth.li> <1225309212.3068.44.camel@achroite> <20081030102746.GI3162@earth.li> <20081030144409.GJ3162@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030144409.GJ3162@earth.li>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008, Jonathan McDowell wrote:
> On Thu, Oct 30, 2008 at 10:27:46AM +0000, Jonathan McDowell wrote:
> > I'll have a prod at why the [hso] rfkill stuff isn't working next
> 
> Ok, I believe this is due to the addition of rfkill_check_duplicity in
> rfkill and the fact that test_bit actually returns a negative value
> rather than the postive one expected (which is of course equally true).
> So when the second WLAN device (the hso device, with the EEE PC WLAN
> being the first) comes along rfkill_check_duplicity returns a negative
> value and so rfkill_register returns an error. Patch below fixes this
> for me.

Good catch, I screwed up on that one.  Please forward it with my ack to
linux-wireless@kernel.org and to Ivo van Doorn <IvDoorn@gmail.com> and John
W. Linville <linville@tuxdriver.com>.

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

> -----
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index f949a48..1ba35a7 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -603,7 +603,7 @@ static int rfkill_check_duplicity(const struct rfkill *rfkil
>         }
>  
>         /* 0: first switch of its kind */
> -       return test_bit(rfkill->type, seen);
> +       return (test_bit(rfkill->type, seen)) ? 1 : 0;
>  }
>  
>  static int rfkill_add_switch(struct rfkill *rfkill)
> -----
> 
> J.
> 

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
