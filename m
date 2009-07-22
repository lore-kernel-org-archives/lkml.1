Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbZGVKp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbZGVKp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 06:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbZGVKpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 06:45:25 -0400
Received: from leia.mcbone.net ([194.97.104.42]:50954 "EHLO leia.mcbone.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbZGVKpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 06:45:24 -0400
X-Greylist: delayed 2821 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jul 2009 06:45:24 EDT
Subject: Re: Linux 2.6.27.27
From: Jens Rosenboom <jens@leia.mcbone.net>
To: Krzysztof Oledzki <olel@ans.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Troy Moure <twmoure@szypr.net>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       lwn@lwn.net, Ian Lance Taylor <iant@google.com>
In-Reply-To: <alpine.LNX.1.10.0907221022380.26357@bizon.gios.gov.pl>
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl>
	 <20090720151008.GC10015@suse.de>
	 <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain>
	 <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl>
	 <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
	 <alpine.LNX.1.10.0907210831210.29729@bizon.gios.gov.pl>
	 <alpine.LNX.1.10.0907211154480.29729@bizon.gios.gov.pl>
	 <alpine.LFD.2.01.0907210906400.19335@localhost.localdomain>
	 <alpine.LFD.2.01.0907211133010.19335@localhost.localdomain>
	 <alpine.LFD.2.00.0907212211040.4630@troy-laptop>
	 <alpine.LFD.2.01.0907211726140.19335@localhost.localdomain>
	 <alpine.LFD.2.01.0907211811410.19335@localhost.localdomain>
	 <alpine.LNX.1.10.0907220914150.26357@bizon.gios.gov.pl>
	 <alpine.LNX.1.10.0907221022380.26357@bizon.gios.gov.pl>
Content-Type: text/plain
Organization: Confused
Date: Wed, 22 Jul 2009 11:58:09 +0200
Message-Id: <1248256689.7237.2.camel@fnki-nb00130>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 10:32 +0200, Krzysztof Oledzki wrote:
> 
> On Wed, 22 Jul 2009, Krzysztof Oledzki wrote:
> 
> >
> >
> > On Tue, 21 Jul 2009, Linus Torvalds wrote:
> >
> >> 
> >> 
> >> On Tue, 21 Jul 2009, Linus Torvalds wrote:
> >>> 
> >>> Anyway, I bet we can work around the compiler bug by just changing the
> >>> type of "i" from "unsigned char" to be a plain "int".
> >> 
> >> IOW, like this.
> >>
> >> 		Linus
> >> 
> >> ---
> >> drivers/video/fbmon.c |    4 ++--
> >> 1 files changed, 2 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
> >> index 5c1a2c0..af4a15c 100644
> >> --- a/drivers/video/fbmon.c
> >> +++ b/drivers/video/fbmon.c
> >> @@ -256,8 +256,8 @@ static void fix_edid(unsigned char *edid, int fix)
> >> 
> >> static int edid_checksum(unsigned char *edid)
> >> {
> >> -	unsigned char i, csum = 0, all_null = 0;
> >> -	int err = 0, fix = check_edid(edid);
> >> +	unsigned csum = 0, all_null = 0;

I guess Linus shouldn't have deleted the "char" here...

[...]

> Here is a diff between a good and a bad kernel:
> 
> -edid_checksum debug: csum=0, all_null=255, err=1
> -edid_checksum debug: csum=0, all_null=255, err=1
> -Console: switching to colour frame buffer device 128x48
> +edid_checksum debug: csum=6400, all_null=255, err=0
> +Console: switching to colour frame buffer device 80x30
> 
> In the good one the function is called twice and it returns err=1 (==OK). 
> In the bad kernel it returns 0 because csum!=0x00 (==6400).

6400 is a multiple of 256, so as unsigned char it is ==0.

