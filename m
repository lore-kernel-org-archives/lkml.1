Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbZGVPu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbZGVPu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbZGVPu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:50:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752523AbZGVPu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:50:58 -0400
Date: Wed, 22 Jul 2009 08:48:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Krzysztof Oledzki <olel@ans.pl>
cc: Troy Moure <twmoure@szypr.net>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       lwn@lwn.net, Ian Lance Taylor <iant@google.com>
Subject: Re: Linux 2.6.27.27
In-Reply-To: <alpine.LNX.1.10.0907221546480.26357@bizon.gios.gov.pl>
Message-ID: <alpine.LFD.2.01.0907220846350.19335@localhost.localdomain>
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl> <20090720151008.GC10015@suse.de> <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain> <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
 <alpine.LNX.1.10.0907210831210.29729@bizon.gios.gov.pl> <alpine.LNX.1.10.0907211154480.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907210906400.19335@localhost.localdomain> <alpine.LFD.2.01.0907211133010.19335@localhost.localdomain>
 <alpine.LFD.2.00.0907212211040.4630@troy-laptop> <alpine.LFD.2.01.0907211726140.19335@localhost.localdomain> <alpine.LFD.2.01.0907211811410.19335@localhost.localdomain> <alpine.LNX.1.10.0907221546480.26357@bizon.gios.gov.pl>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 22 Jul 2009, Krzysztof Oledzki wrote:

> 
> 
> On Tue, 21 Jul 2009, Linus Torvalds wrote:
> > 
> > IOW, like this.

Yeah, I'm a moron. Not at _all_ like that. I wish I hadn't sent out the 
patch, you'd have done it correctly by hand from my description.

> > diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
> > index 5c1a2c0..af4a15c 100644
> > --- a/drivers/video/fbmon.c
> > +++ b/drivers/video/fbmon.c
> > @@ -256,8 +256,8 @@ static void fix_edid(unsigned char *edid, int fix)
> > 
> > static int edid_checksum(unsigned char *edid)
> > {
> > -	unsigned char i, csum = 0, all_null = 0;
> > -	int err = 0, fix = check_edid(edid);
> > +	unsigned csum = 0, all_null = 0;
> > +	int i, err = 0, fix = check_edid(edid);

I don't know where the 'char' disappeared, but that was obviously not 
intended. I just meant to move the 'i' from one line to the other.

> > 
> > 	if (fix)
> > 		fix_edid(edid, fix);
> 
> Tested-by: Krzysztof Piotr Oledzki <ole@ans.pl>
> 
> On condition, that you keep "unsigned char" here. ;)

Indeed. I'll commit the fixed version. Thanks for testing and sorry for 
the idiot patch.

		Linus
