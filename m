Return-Path: <linux-kernel-owner+w=401wt.eu-S1761754AbYDLM1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761754AbYDLM1d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 08:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759984AbYDLM1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 08:27:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:40217 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759924AbYDLM1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 08:27:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=rTM+2QCvxGs1qMEs5TFd+iHer0V9pcrSP8aG2e+AmaiI4YP0euKnPWhfX3j8wHuBJl0R0sBM0NFqaJ8zU996RprWrIC0BGTdqdwXbaCMzwwXK3y8sUVHsH7QmsTdQ2WV2OjxqNLslRXJ44MdIAQ9eijYhACUPotM/PJuLcLldGQ=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 6/8] rfkill: add the WWAN radio type
Date: Sat, 12 Apr 2008 14:28:56 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Inaky Perez-Gonzalez <inaky@linux.intel.com>,
       =?iso-8859-1?q?I=F1aky_P=E9rez-Gonz=E1lez?= 
	<inaky.perez-gonzalez@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <200804121236.45670.IvDoorn@gmail.com> <20080412121554.GB3402@khazad-dum.debian.net>
In-Reply-To: <20080412121554.GB3402@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804121428.57071.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 April 2008, Henrique de Moraes Holschuh wrote:
> On Sat, 12 Apr 2008, Ivo van Doorn wrote:
> > On Friday 11 April 2008, Henrique de Moraes Holschuh wrote:
> > > Unfortunately, instead of adding a generic Wireless WAN type, a technology-
> > > specific type (WiMAX) was added.  That's useless for other WWAN devices,
> > > such as EDGE, UMTS, X-RTT and other such radios.
> > 
> > Then perhaps we should replace WiMAX with the WWAN type?
> 
> And have KEY_WIMAX interact with WWAN, or rename KEY_WIMAX to KEY_WWAN as
> well?
> 
> I do think it should be OK to do both renames, since it is very unlikely
> that a device would have keys for WIMAX and WWAN at the same type.  We
> don't even have to rename KEY_WIMAX, we can have KEY_WWAN and KEY_WIMAX map
> both to the same keycode.
> 
> Inaky?

I would say rename, having multiple key definitions mapped to the same keycode 
sounds like a bad idea to me.

> > > Add a WWAN rfkill type for generic wireless WAN devices.  No keys are added
> > > as most devices use KEY_RADIO for WWAN control and need no specific keycode
> > > added.
> > 
> > In the discussion around the WiMAX addition I do remember people wanted
> > it to have a seperate key code because it was "different technology". Wouldn't that
> > be the same for all WWAN technologies?
> 
> IMO, this is an USER INTERFACE part of the kernel.  The user will either
> interact with radios one-by-one (and the rfkill class provides this anyway,
> even without separate types), or he will want to deal with abstract
> concepts: "all radios", "wireless wan", "wireles lan", "personal-space
> radios (UWB, BT)"...
> 
> I.e. I am not even sure we should have UWB and BT as separate types...  but
> naming UWB "Bluetooth" would be wrong, too, so a proper fix there is harder
> (breaks stable ABI with userspace).
> 
> > Aka, should the WiMAX keycode be changed to a WWAN keycode in input.h
> > and then be used for all WWAN rfkill switches?
> 
> I'd think so.
> 
> We can add a desc field to rfkill with a more human-friendly, not required
> to be unique, description of the switch.
> 
>  e.g.:  "Intel WiMAX 1234 radio switch"
>         "ThinkPad builtin bluetooth switch"
> 
> and so on.  It will be far more useful than making the switch type a
> technology-granular thing.  And it will be useful for GUIs in userspace.

Sounds good.

Ivo
