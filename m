Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbYFFO3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbYFFO3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 10:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbYFFO3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 10:29:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554AbYFFO3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 10:29:46 -0400
Subject: Re: iwl4965 oops in 2.6.26-rc5 x86_64
From: Dan Williams <dcbw@redhat.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Thomas Backlund <tmb@mandriva.org>, Ian Schram <ischram@telenet.be>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240806060659wf4e4088s8afdd2f7f854ea09@mail.gmail.com>
References: <4848289D.1080205@mandriva.org>
	 <1ba2fa240806051103q652accf5t1bd1d94630ebea5b@mail.gmail.com>
	 <48482BC3.4070402@mandriva.org> <4848482C.2080208@mandriva.org>
	 <48485F12.2050908@mandriva.org> <48488878.5040708@telenet.be>
	 <1ba2fa240806060432t73ecb318x89e877241aa6ef55@mail.gmail.com>
	 <48492734.9080901@mandriva.org> <48492E85.6010307@mandriva.org>
	 <1ba2fa240806060659wf4e4088s8afdd2f7f854ea09@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 10:29:29 -0400
Message-Id: <1212762569.28631.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-06 at 16:59 +0300, Tomas Winkler wrote:
> On Fri, Jun 6, 2008 at 3:33 PM, Thomas Backlund <tmb@mandriva.org> wrote:
> > Thomas Backlund skrev:
> >>
> >> Tomas Winkler skrev:
> >>>
> >>> On Fri, Jun 6, 2008 at 3:44 AM, Ian Schram <ischram@telenet.be> wrote:
> >>>>
> >>>> Isn't this the Oops Joonwoo Park wanted to patch with
> >>>>
> >>>> "[PATCH] iwlwifi: fix oops on wep key insertion" 27/5/2008
> >>>>
> >>>> invalid length of webkey that would/should be handled in mac80211?
> >>>>
> >>>> ian
> >>>
> >>> Yes, it looks like.
> >>
> >> Ummm, what has a wep key to do with me trying to access a WPA2-Personal
> >> encrypted net ?
> 
> Not sure yet, but mac is trying to assign default/static wep key.

The output of wpa_supplicant with "-dddt" would be quite useful in
figuring this out.

The supplicant does always _clear_ static WEP keys when it starts the
interface, when a connection drops, and when it quits.  Maybe that's
where it's coming from?  But it should just be setting the "disabled"
bit in the WEXT structure and sending a key of all zeros.

Dan

> :iwlcore:iwl_send_static_wepkey_cmd+0xcb/0xd5
> :iwlcore:iwl_set_default_wep_key+0xa2/0xbc
> 
> Try to set the encryption explicitly
> network={
>     psk="*************************"
>     scan_ssid=1
>     ssid="dlink"
>     pairwise=CCMP
>    group=CCMP
>  }
> 
> 
> >>
> >>> Thomas can you send out your wpa_supplicant config fiele
> >>>
> >>
> >> I could, but since I would have to remove any sensitive info such as the
> >> psk key, would it be of any use ?
> >
> > Anyway, here configs are:
> >
> > wpa_supplicant.conf
> > (I stripped all the comments from the file)
> > --- cut ---
> > ctrl_interface=/var/run/wpa_supplicant
> >
> > eapol_version=1
> >
> > ap_scan=1
> >
> > fast_reauth=1
> >
> > blob-base64-exampleblob={
> > SGVsbG8gV29ybGQhCg==
> > }
> >
> > network={
> >    psk="*************************"
> >    scan_ssid=1
> >    ssid="dlink"
> > }
> > --- cut ---
> >
> > ifcfg-wlan0
> > --- cut ---
> > DEVICE=wlan0
> > BOOTPROTO=dhcp
> > ONBOOT=yes
> > METRIC=35
> > MII_NOT_SUPPORTED=no
> > USERCTL=no
> > RESOLV_MODS=no
> > WIRELESS_MODE=Managed
> > WIRELESS_ESSID=dlink
> > WIRELESS_ENC_KEY='s:*************************'
> > WIRELESS_WPA_DRIVER=wext
> > IPV6INIT=no
> > IPV6TO4INIT=no
> > DHCP_CLIENT=dhclient
> > NEEDHOSTNAME=no
> > PEERDNS=yes
> > PEERYP=yes
> > PEERNTPD=no
> > --- cut ---
> >
> >>
> >>> I will provide a patch that disable hw encryption on long wep keys. It
> >>> get lost in my todo list.
> >>> Tomas
> >>>
> >>
> >
> > --
> > Thomas
> >
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

