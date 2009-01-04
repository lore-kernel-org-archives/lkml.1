Return-Path: <linux-kernel-owner+w=401wt.eu-S1752680AbZADGnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbZADGnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 01:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbZADGnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 01:43:13 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:40600
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZADGnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 01:43:12 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 1/3]: Replace kernel/timeconst.pl with kernel/timeconst.sh
Date: Sun, 4 Jan 2009 00:43:08 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Ingo Oeser <ioe-lkml@rameria.de>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <200901031936.04642.rob@landley.net> <25035.1231045675@turing-police.cc.vt.edu>
In-Reply-To: <25035.1231045675@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901040043.08577.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009 23:07:55 Valdis.Kletnieks@vt.edu wrote:
> On Sat, 03 Jan 2009 19:36:04 CST, Rob Landley said:
> > On Saturday 03 January 2009 06:28:22 Ingo Oeser wrote:
> > > > +for i in "MSEC 1000" "USEC 1000000"
> > > > +do
> > > > +	NAME=$(echo $i | awk '{print $1}')
> > >
> > > cut -d' ' -f1  does the same
> > >
> > > > +	PERIOD=$(echo $i | awk '{print $2}')
> > >
> > > cut -d' ' -f2  does the same
>
> Close, but no cee-gar.  cut does something counter-intuitive with multiple
> blanks:

Yes, but in this case I'm the one passing in the data so I know there aren't 
multiple blanks.  (Or tabs instead of spaces.)

In a private email, Bernd Petrovitsch suggested "set -- $i" and then using 
NAME=$1; PERIOD=$2.  (I keep getting private email responses to these sort of 
threads, and then getting dismissed as the only one who cares about the issue.  
Less so this time around, but still...)  This apparently works all the way 
back to the bourne shell.  Not worth rolling another patch for, but if I do 
wind up rolling another patch for other reasons I might switch over to that.  
Both "cut" and "awk" are susv3, though.

Rob
