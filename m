Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbYILPZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbYILPZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 11:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757099AbYILPZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 11:25:47 -0400
Received: from bu3sch.de ([62.75.166.246]:42198 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757080AbYILPZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 11:25:45 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: I need help with a sparse warning
Date: Fri, 12 Sep 2008 17:25:06 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Steven Noonan <steven@uplinklabs.net>, LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>
References: <48C9D040.8010107@lwfinger.net> <f488382f0809111932v1cc1eb44kbe0bc0e97347c834@mail.gmail.com> <48C9DACE.5040308@lwfinger.net>
In-Reply-To: <48C9DACE.5040308@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809121725.06870.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 September 2008, Larry Finger wrote:
> Steven Noonan wrote:
> > On Thu, Sep 11, 2008 at 7:13 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> >> In file drivers/net/wireless/p54/p54common.c, the statement
> >>
> >>       priv->rx_mtu = (size_t) le16_to_cpu((__le16)bootrec->data[10]);
> >>
> >> generates the sparse warning
> >>
> >> .../p54common.c:185:29: warning: cast to restricted __le16
> >>
> >> where bootrec->data is u32, and priv->rx_mtu is u16.
> >>
> > 
> > (Whoops, didn't CC the mailing lists. Sorry about the double-message, Larry.)
> > 
> > If priv->rx_mtu is u16, I'm surprised it doesn't get noisy about the
> > size_t cast. Unless the machine it's being compiled on is 16-bit, that
> > should throw a truncation warning, because size_t should be a 32-bit
> > integer on 32-bit machines (typically).
> > 
> > I think if you change the (__le16) cast to (__le16 __force) it will
> > stop warning you about that particular issue.
> 
> This one gets rid of the sparse warning.
> 
>         priv->rx_mtu = le16_to_cpu((__le16 __force)
>                                    bootrec->data[10]);

I think you should rather fix the type of bootrec->data.
If it is u32, but the data in fact is __le16, please fix the struct instead
of adding dangerous casts.
Note that this is especially dangerous, because you cast between different
typesizes and endianesses at the same time.
