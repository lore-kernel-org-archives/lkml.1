Return-Path: <linux-kernel-owner+w=401wt.eu-S1762868AbZAORpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762868AbZAORpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 12:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755714AbZAORpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 12:45:16 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:19504 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbZAORpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 12:45:14 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: netlabel: UNLABELED ath9k not denying unlabeled traffic
Date: Thu, 15 Jan 2009 12:45:05 -0500
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       "SE-Linux" <selinux@tycho.nsa.gov>
References: <496D759A.7010401@gmail.com> <200901141736.43805.paul.moore@hp.com> <496E974E.1040806@gmail.com>
In-Reply-To: <496E974E.1040806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901151245.05494.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 January 2009 8:54:22 pm Justin P. Mattock wrote:
> Paul Moore wrote:
> apologize for the slow response
> (had to do some external activities);

No problem, I've got a day job too :)

> > NOTE: the domain mapping configuration only controls how outbound
> > network traffic is labeled on-the-wire; it "maps" the
> > LSM/SELinux "domains" to a specific labeling protocol
> > configuration, e.g. all apache_t traffic should be labeled with
> > CIPSO DOI 3 while all firefox_t traffic should not be labeled at
> > all.

...

> > I think what you mean to type is the following:
> >
> >  # netlabelctl unlbl add interface:wlan0 address:<radioadd> \
> >        label:system_u:object_r:netlabel_peer_t:s0
> >
> > ... note there is no "domain" argument, that only exists
> > for "netlabelctl map ..." commands.
> >
> > NOTE: if you really want to get fancy you can create new SELinux
> > domains for each type of media and add NetLabel configurations for
> > those new domains.  Imagine you create a new "internet_radio_t"
> > domain/type and only allow the "netplayer_t" domain (yeah, I made
> > that up but you get the point) access to network traffic labeled
> > with internet_radio_t. You would then use the following command to
> > label your incoming traffic with NetLabel:
> >
> >  # netlabelctl unlbl add interface:wlan0 address:<radioadd> \
> >        label:system_u:object_r:internet_radio_t:s0
> >
> > NOTE: you can also skip the "interface:wlan0" argument and just
> > use "default" instead if you want the configuration to apply to all
> > your network interfaces; although bear in mind that the "default"
> > configuration can be overridden by the interface specific
> > configurations.
>
> Alright, I thought you could use the map option for unlbl.

Yes, you can use configure the LSM/SELinux domain mapping to send 
unlabeled/"unlbl" packets (the default configuration maps all outbound 
traffic to "unlbl") but since you only really care about inbound 
traffic you can ignore the "map" option.

-- 
paul moore
linux @ hp
