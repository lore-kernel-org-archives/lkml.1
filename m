Return-Path: <linux-kernel-owner+w=401wt.eu-S965897AbXILK20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965897AbXILK20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 06:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761234AbXILK2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 06:28:18 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:61507 "EHLO
	outbound8-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759699AbXILK2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 06:28:16 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Wed, 12 Sep 2007 12:27:54 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Hank Leininger" <hlein@progressive-comp.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, B.Steinbrink@gmx.de,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Request for Linux Kernel Mailing List archives
Message-ID: <20070912102754.GA25889@alberich.amd.com>
References: <467949CC.9090405@zytor.com>
 <20070620155231.GA18644@atjola.homenet> <46794E5B.6070506@zytor.com>
 <Pine.LNX.4.64.0706201210330.18771@marklar.spinoli.org>
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0706201210330.18771@marklar.spinoli.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 12 Sep 2007 10:27:56.0865 (UTC)
 FILETIME=[95C5DB10:01C7F527]
X-WSS-ID: 6AF960A40X87302996-01-01
Content-Type: multipart/mixed;
 boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain;
 charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 20, 2007 at 12:38:48PM -0400, Hank Leininger wrote:
> On Wed, 20 Jun 2007, H. Peter Anvin wrote:
> >Bj=F6rn Steinbrink wrote:
> >>
> >>marc.info supports that.
> >>http://marc.info/?i=3D467949CC.9090405@zytor.com
> >Excellent!  Didn't see that documented anywhere.
>=20
> You're right, it's not really.  In fact very little is documented.
> You'd have to discover it -- in the message view, the Message-ID is
> actually a self-referential link using the above syntax.
>=20
> A few relevant points:
> - - Such links never actually show you the corresponding message.  Inst=
ead:
>   - If the message-id is unique, you are sent a 302 redirect to the
>     message using the normal MARC message URL (l=3Dfoo&msgid=3D123)
>   - If the message-id is not unique (such as crossposting, or deliberat=
e
>     attempts to cause collisions) you'll be presented with a list of
>     messages, showing date, subject, author, and listname, to choose fr=
om.
> - - MARC doesn't currently touch message bodies for spam-obfuscation
>   purposes, but it does for headers, specifically From: and Message-ID:=
.
>   When MARC generates message-id-based links, they are obfuscated.
>   But it can read in links formed either way.  So, if you copy/paste th=
e
>   target of a Message-ID: link out of MARC, it will look slightly
>   different than if you just made your own http://marc.info/?i=3Dwhat@n=
ot,
>   but either form will work.
> - - We don't use < > surrounding the message-id, but again, will accept
>   URLs formed either way.
> - - We don't have Message-ID's for messages added before Dec, 2003.

Thanks for that usefull info.

Attached is a script containing a quick hack to enable look up of
a message-id at MARC with mutt(ng).

Posted to LKML just in case some other mutt(ng) user subscribed here
finds it useful.


Regards,

Andreas

--=20
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas =
McCoy

--lrZ03NoBR/3+SXJZ
Content-Type: application/x-sh
Content-Disposition: attachment;
 filename=show-mail.sh
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A# Author: Andreas Herrmann <andreas.herrmann3@amd.com>=0A#=0A=
# Look up message-id at MARC (http://marc.info).=0A#=0A# The script tries t=
o find the message-id at MARC.=0A# So on success you'll get an URL that you=
 can refer to=0A# when mailing with people that aren't subscribed to certai=
n=0A# mailing lists.=0A#=0A# Read http://marc.info/?l=3Dlinux-kernel&m=3D11=
8235886512436 for more info.=0A#=0A# Works with mutt(ng) but might be usabl=
e for other=0A# configurable mail clients as well.=0A#=0A# Installation and=
 mutt(ng) configuration is as follows:=0A#=0A# (1) Install the script such =
that it is in your command search path.=0A# (2) Add following key binding t=
o your mutt(ng) config file:=0A#=0A#	macro pager M ":set pipe_decode<enter>=
|show-mail.sh<enter>:unset pipe_decode<enter>"=0A#=0A# Pressing "M" within =
the pager will now call the below script.=0A#=0A# Note:	You have to show th=
e Message-ID in the pager. So either show it by=0A#	default via=0A#		unigno=
re message-id=0A#	or do a display-toggle-head with "h" before the script is=
 called.=0A=0Aclear=0Awhile read data=0A  do=0A  echo $data | grep -i -q "^=
message-id:"=0A  if [ $? -eq 0 ]=0A      then=0A      mid=3D`echo $data | a=
wk '{ print $2 }'`=0A  fi=0Adone=0A=0Aif [ -n "$mid" ]=0Athen=0A    echo fi=
refox "http://marc.info/?i=3D$mid"=0A    firefox "http://marc.info/?i=3D$mi=
d"=0Aelse=0A    echo "no Message-ID found"=0Afi=0A
--lrZ03NoBR/3+SXJZ--


