Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbYIRJc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbYIRJc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 05:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbYIRJcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 05:32:18 -0400
Received: from web32601.mail.mud.yahoo.com ([68.142.207.228]:48523 "HELO
	web32616.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753892AbYIRJcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 05:32:17 -0400
X-YMail-OSG: bSyGoTkVM1k896lGnh42wMuHcMPmI4TyItSC8Gu7xtbxLctCEOnOPFVgJEEKYBpeATNHO2nvkPxNzhUnq_AtrO7tWiZD5Pkp.Y7W63uE_ZPGy3LY_t7.TmR5EAlIfjqVfd4e1K7TcVfV5mtOaVfg564urQ.MLQ--
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Thu, 18 Sep 2008 02:32:16 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
To: Greg Banks <gnb@melbourne.sgi.com>
Cc: linux-nfs list <linux-nfs@vger.kernel.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <151874.61127.qm@web32601.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Greg Banks <gnb@melbourne.sgi.com>
> To: Martin Knoblauch <knobi@knobisoft.de>
> Cc: linux-nfs list <linux-nfs@vger.kernel.org>; linux-kernel@vger.kernel.org
> Sent: Thursday, September 18, 2008 10:45:01 AM
> Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
> 
> Martin Knoblauch wrote:
> > ----- Original Message ----
> >
> >  
> >>
> >> I think having a tunable for client readahead is an excellent idea,
> >> although not to solve your particular problem.  The SLES10 kernel has a
> >> patch which does precisely that, perhaps Neil could post it.
> >>
> >> I don't think there's a lot of point having both a module parameter and
> >> a sysctl.
> >>
> >>    
> >
> >  Actually there is a good reason. The module parameter can be used to set the 
> new value at load time and never bother again. The sysctl is very convenient 
> when doing experiments.
> >  
> You can set module parameters after module load in
> /sys/module/$module/parameters.

 OK, one always learns new stuff :-)

> >  As Andrew already pointed out, the best solution would be a mount option.
> Yep.
> >  But that seems much more involved as my workaround patch.
> >
> >  
> Yep.

 Seeing Andrews Mails, it might be less involved that I thought :-) Will have a look.

> >> A maximum of 15 is unwise.  I've found that (at least with the older
> >> readahead mechanisms in SLES10) a multiple of 4 is required to preserve
> >> rsize-alignment of READ rpcs to the server, which helps a lot with wide
> >> RAID backends.  So in SGI we tune client readahead to 16.
> >>
> >>    
> >
> >  15 is the value that the Linux NFS client uses., at least since 2.6.3. 
> It's a silly value.

 I was not sure whether it was just arbitrary, or caused by some other internal limit. The definition made it look like it was somehow related to RPC_DEF_SLOT.

> > As it is not tunable up to today, the comment seems moot :-)  But it opens the 
> questions:
> >
> > a) should 1 be the minimum, or 0?
> >  
> Turning off client RA entirely is potentially useful.
> > b) can the backing_dev_info.ra_pages field safely be set to something higher 
> than 15?
> >  
> Yes.  Did I mention 16 ?

 You also mentioned that you do that at SGI. So, who knows whatelse there is changed :-) Anyway, thanks for the hint. 

> >  
> >> Your patch seems to have a bunch of other unrelated stuff mixed in.
> >>
> >>    
> >
> >  Yeah, someone already pointed out, that the Makefile hunk does not belong 
> there. But you say "a bunch" - anything else?
> >  
> I rapidly scrolled past some stuff about 64bit inodes.

 Ahh. Now I remember... when I implemented the module  parameter, I found that "enable_ino64" lacks a description. Yeah, should be a separate patch.

Cheers
Martin

