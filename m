Return-Path: <linux-kernel-owner+w=401wt.eu-S1762948AbYFFPWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762948AbYFFPWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762654AbYFFPWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:22:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761985AbYFFPWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:22:16 -0400
Subject: Re: iwl4965 oops in 2.6.26-rc5 x86_64
From: Dan Williams <dcbw@redhat.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Thomas Backlund <tmb@mandriva.org>, Ian Schram <ischram@telenet.be>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240806060812q28c270c4i12cc08f8665e9cc0@mail.gmail.com>
References: <4848289D.1080205@mandriva.org> <48482BC3.4070402@mandriva.org>
	 <4848482C.2080208@mandriva.org> <48485F12.2050908@mandriva.org>
	 <48488878.5040708@telenet.be>
	 <1ba2fa240806060432t73ecb318x89e877241aa6ef55@mail.gmail.com>
	 <48492734.9080901@mandriva.org> <48492E85.6010307@mandriva.org>
	 <1ba2fa240806060659wf4e4088s8afdd2f7f854ea09@mail.gmail.com>
	 <48494EF6.4020506@mandriva.org>
	 <1ba2fa240806060812q28c270c4i12cc08f8665e9cc0@mail.gmail.com>
Content-Type: text/plain; charset=utf8
Date: Fri, 06 Jun 2008 11:22:00 -0400
Message-Id: <1212765720.28631.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-06 at 18:12 +0300, Tomas Winkler wrote:
> On Fri, Jun 6, 2008 at 5:51 PM, Thomas Backlund <tmb@mandriva.org> wrote:
> > Tomas Winkler skrev:
> >>
> >> On Fri, Jun 6, 2008 at 3:33 PM, Thomas Backlund <tmb@mandriva.org> wrote:
> >>>
> >>> Thomas Backlund skrev:
> >>>>
> >>>> Tomas Winkler skrev:
> >>>>>
> >>>>> On Fri, Jun 6, 2008 at 3:44 AM, Ian Schram <ischram@telenet.be> wrote:
> >>>>>>
> >>>>>> Isn't this the Oops Joonwoo Park wanted to patch with
> >>>>>>
> >>>>>> "[PATCH] iwlwifi: fix oops on wep key insertion" 27/5/2008
> >>>>>>
> >>>>>> invalid length of webkey that would/should be handled in mac80211?
> >>>>>>
> >>>>>> ian
> >>>>>
> >>>>> Yes, it looks like.
> >>>>
> >>>> Ummm, what has a wep key to do with me trying to access a WPA2-Personal
> >>>> encrypted net ?
> >>
> >> Not sure yet, but mac is trying to assign default/static wep key.
> >>
> >> :iwlcore:iwl_send_static_wepkey_cmd+0xcb/0xd5
> >> :iwlcore:iwl_set_default_wep_key+0xa2/0xbc
> >>
> >> Try to set the encryption explicitly
> >> network={
> >>    psk="*************************"
> >>    scan_ssid=1
> >>    ssid="dlink"
> >>    pairwise=CCMP
> >>   group=CCMP
> >>  }
> >>
> >>
> >
> > That didn't help at all...
> >
> > What's more it prevented the wifi to work on 2.6.24.7 so I had to remove the
> > lines again...
> >
> So what's your AP configuration TKIP?

Yeah, the supplicant log he posted clearly shows that the GTK is TKIP.

﻿> 1212763152.516781: wpa_driver_wext_set_key: alg=2 key_idx=1 set_tx=0 seq_len=6 key_len=32
> 1212763152.516790: WPA: Key negotiation completed with 00:xx:xx:xx:xx:xx [PTK=CCMP GTK=TKIP]

Dan

> Second try also with sw decryption:
> 
> in /etc/modprobe.conf
> options iwl4965 swcrypto=1
> 
> 
> Tomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

